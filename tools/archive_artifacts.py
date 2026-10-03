"""Index experiments and verify compressed captures before pruning local copies."""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
import tarfile
import time
from datetime import datetime, timezone
from pathlib import Path


KEEP_RAW = {
    'imodem-slmodemd-v90-factory-profile-audit-20261003',
    'imodem-slmodemd-v90-live-profile-audit-20261003',
    'imodem-slmodemd-v90-fresh-7e1-ni1-audit-20261003',
    'imodem-slmodemd-v90-lapm-drained-soak-20261002',
    'imodem-analog-x2-53333-production-20261003',
}


def digest_file(path: Path) -> str:
    with path.open('rb') as stream:
        return digest_stream(stream)


def digest_stream(stream) -> str:
    digest = hashlib.sha256()
    for chunk in iter(lambda: stream.read(1024 * 1024), b''):
        digest.update(chunk)
    return digest.hexdigest()


def snapshot(path: Path) -> tuple[int, int]:
    stat = path.stat()
    return stat.st_size, stat.st_mtime_ns


def evidence(directory: Path) -> dict:
    """Extract explicit results, without treating CONNECT as data verification."""
    for name in ('payload-analysis.json', 'verification.json', 'summary.json'):
        path = directory / name
        if not path.exists():
            continue
        try:
            data = json.loads(path.read_text())
        except (ValueError, UnicodeError):
            continue
        if not isinstance(data, dict):
            continue
        result = {'source': path.as_posix()}
        for key in ('connected', 'data_delivery', 'goal_requirements_verified',
                    'analog_connect_rate_bps', 'imodem_connect_rate_bps',
                    'negotiated_links', 'retrain_requests'):
            if key in data:
                result[key] = data[key]
        for key in ('imodem_to_smartlink', 'smartlink_to_imodem'):
            if isinstance(data.get(key), dict):
                result[key] = {field: data[key][field] for field in
                               ('packets_sent', 'packets_received_exactly_once',
                                'all_packets_match') if field in data[key]}
        return result
    return {'finding': 'No compact result recorded; consult the retained reports.'}


def prunable(path: Path, relative: str, tracked: set[str]) -> bool:
    if relative in tracked or path.suffix.lower() in {'.py', '.md', '.patch', '.sav', '.txt'}:
        return False
    if path.suffix == '.json' and path.stat().st_size <= 65536:
        return False
    return True


def archive_directory(directory: Path, repo: Path, destination: Path,
                      tracked: set[str], prune: bool, preserve: bool) -> dict:
    files = sorted(p for p in directory.rglob('*') if p.is_file() and not p.is_symlink())
    before = {p: snapshot(p) for p in files}
    manifest = [{'path': p.relative_to(repo).as_posix(), 'bytes': before[p][0],
                 'sha256': digest_file(p)} for p in files]
    destination.mkdir(parents=True, exist_ok=True)
    archive = destination / (directory.name + '.tar.gz')
    if archive.exists():
        raise FileExistsError(f'Refusing to overwrite {archive}')
    temporary = archive.with_suffix('.gz.partial')
    try:
        with tarfile.open(temporary, 'w:gz', compresslevel=6) as tar:
            for p in files:
                tar.add(p, arcname=p.relative_to(repo).as_posix(), recursive=False)
        # Read every archived byte back; matching file sizes alone is insufficient.
        with tarfile.open(temporary, 'r:gz') as tar:
            for record in manifest:
                stream = tar.extractfile(record['path'])
                if stream is None:
                    raise ValueError(f'Missing archive member {record["path"]}')
                with stream:
                    actual = digest_stream(stream)
                if actual != record['sha256']:
                    raise ValueError(f'Archive checksum mismatch: {record["path"]}')
        if any(snapshot(p) != before[p] for p in files):
            raise RuntimeError(f'Capture changed during archiving: {directory}')
        temporary.rename(archive)
    finally:
        temporary.unlink(missing_ok=True)
    archive_hash = digest_file(archive)
    # Persist the full recovery manifest before deleting any source file.
    manifest_path = archive.with_suffix('.manifest.json')
    manifest_path.write_text(json.dumps({'archive': archive.name,
        'sha256': archive_hash, 'verified': True, 'files': manifest}, indent=2) + '\n')
    removed = []
    if prune and not preserve:
        for p, record in zip(files, manifest):
            if prunable(p, record['path'], tracked):
                if snapshot(p) != before[p] or digest_file(p) != record['sha256']:
                    raise RuntimeError(f'Capture changed before pruning: {p}')
                p.unlink()
                removed.append(record)
    return {'archive': archive.relative_to(repo).as_posix(),
            'manifest': manifest_path.relative_to(repo).as_posix(),
            'sha256': archive_hash, 'verified': True,
            'archive_bytes': archive.stat().st_size,
            'source_bytes': sum(r['bytes'] for r in manifest),
            'files_archived': len(manifest), 'files_pruned': len(removed),
            'bytes_pruned': sum(r['bytes'] for r in removed),
            'raw_preserved': preserve}


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--apply', action='store_true', help='Create and verify archives')
    parser.add_argument('--prune', action='store_true', help='Remove only verified untracked output')
    parser.add_argument('--date', action='append', default=[], help='Experiment date suffix to archive')
    parser.add_argument('--quiet-seconds', type=int, default=600)
    args = parser.parse_args()
    if args.prune and not args.apply:
        parser.error('--prune requires --apply')
    repo = Path(__file__).resolve().parents[1]
    tracked = set(subprocess.check_output(['git', 'ls-files', '-z'], cwd=repo)
                  .decode().rstrip('\0').split('\0'))
    stamp = datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
    destination = repo / '.artifact-archives' / stamp
    index_path = repo / 'artifacts/experiment-index.json'
    previous = {}
    if index_path.exists():
        previous = {r['experiment']: r for r in
                    json.loads(index_path.read_text()).get('experiments', [])}
    rows = []
    for directory in sorted((repo / 'artifacts').iterdir()):
        if not directory.is_dir() or directory.is_symlink():
            continue
        files = [p for p in directory.rglob('*') if p.is_file() and not p.is_symlink()]
        relative = directory.relative_to(repo).as_posix()
        finding = evidence(directory)
        if 'source' in finding:
            finding['source'] = Path(finding['source']).relative_to(repo).as_posix()
        row = {'experiment': directory.name, 'directory': relative,
               'purpose': re.sub(r'-20\d{6}.*$', '', directory.name).replace('-', ' '),
               'purpose_basis': 'Directory label; result is taken from the cited report.',
               'result': finding, 'local_bytes_before': sum(p.stat().st_size for p in files)}
        old = previous.get(directory.name, {})
        history = list(old.get('previous_archives', []))
        if old.get('archive'):
            history.append({key: old[key] for key in
                            ('archive', 'manifest', 'sha256', 'verified', 'archive_bytes',
                             'source_bytes', 'files_archived', 'files_pruned', 'bytes_pruned')
                            if key in old})
        if history:
            row['previous_archives'] = history
        selected = bool(args.date) and any(date in directory.name for date in args.date)
        recent = any(time.time() - p.stat().st_mtime < args.quiet_seconds for p in files)
        preserve = directory.name in KEEP_RAW or directory.name.startswith('real-courier-')
        if selected and files and not recent and args.apply:
            row.update(archive_directory(directory, repo, destination, tracked, args.prune, preserve))
            print(f'{directory.name}: verified archive, pruned {row["bytes_pruned"]} bytes', flush=True)
        else:
            row['disposition'] = ('recently modified; left untouched' if selected and recent
                                  else 'planned archive' if selected else 'retained in place')
        rows.append(row)
    index = {'created_utc': stamp, 'archive_storage': '.artifact-archives/ (local, ignored by Git)',
             'restore': 'tar -xzf ARCHIVE -C REPOSITORY_ROOT; check SHA-256 against its manifest',
             'experiments': rows}
    index_path.write_text(json.dumps(index, indent=2) + '\n')
    lines = ['# Experiment index', '',
             'Labels describe the experiment purpose; linked reports contain the actual findings.', '',
             'Compressed archives are local under `.artifact-archives/`, outside Git tracking.',
             'The JSON index records archive locations, checksums, and cleanup accounting.', '',
             '| Experiment | Result evidence | Storage |', '|---|---|---|']
    for row in rows:
        source = row['result'].get('source')
        link = f'[report]({Path(source).relative_to("artifacts").as_posix()})' if source else 'No compact report'
        storage = ('Archive verified; raw preserved' if row.get('raw_preserved') else
                   'Archive verified; generated output pruned' if row.get('files_pruned') else
                   'Archive verified' if row.get('archive') else row['disposition'])
        lines.append(f'| {row["experiment"]} | {link} | {storage} |')
    (repo / 'artifacts/experiment-index.md').write_text('\n'.join(lines) + '\n')
    print(json.dumps({'experiments': len(rows), 'archives': sum('archive' in r for r in rows),
                      'bytes_pruned': sum(r.get('bytes_pruned', 0) for r in rows),
                      'archive_bytes': sum(r.get('archive_bytes', 0) for r in rows)}), flush=True)


if __name__ == '__main__':
    main()
