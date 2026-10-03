import json
import tarfile

from tools.archive_artifacts import archive_directory, digest_file


def test_archive_verified_before_pruning_and_preserves_tracked_evidence(tmp_path):
    experiment = tmp_path / 'artifacts/test-experiment'
    experiment.mkdir(parents=True)
    raw = experiment / 'capture.g711'
    raw.write_bytes(bytes(range(256)) * 10)
    tracked = experiment / 'tracked.g711'
    tracked.write_bytes(b'primary evidence')
    summary = experiment / 'summary.json'
    summary.write_text('{"connected": true}')
    profile = experiment / 'nvram.sav'
    profile.write_bytes(b'configuration')
    result = archive_directory(experiment, tmp_path, tmp_path / '.artifact-archives/run',
                               {'artifacts/test-experiment/tracked.g711'}, True, False)
    assert not raw.exists()
    assert tracked.exists() and summary.exists() and profile.exists()
    archive = tmp_path / result['archive']
    manifest = json.loads((tmp_path / result['manifest']).read_text())
    assert digest_file(archive) == manifest['sha256']
    assert result['files_pruned'] == 1
    with tarfile.open(archive) as tar:
        assert tar.extractfile('artifacts/test-experiment/capture.g711').read() == bytes(range(256)) * 10


def test_protected_experiment_retains_raw_capture(tmp_path):
    experiment = tmp_path / 'artifacts/working-control'
    experiment.mkdir(parents=True)
    raw = experiment / 'capture.g711'
    raw.write_bytes(b'important control')
    result = archive_directory(experiment, tmp_path, tmp_path / '.artifact-archives/run',
                               set(), True, True)
    assert raw.read_bytes() == b'important control'
    assert result['verified'] and result['files_pruned'] == 0
