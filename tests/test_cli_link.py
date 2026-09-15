from courier_emu.cli import _link_side, build_parser


def _link_args(*extra: str):
    return build_parser().parse_args(["link", "firmware.rom", *extra])


def _at_commands(command: list[str]) -> list[str]:
    return [command[index + 1] for index, item in enumerate(command) if item == "--at"]


def test_link_defaults_to_leased_line_and_opposite_switch_5_roles():
    args = _link_args()

    answer = _link_side(args, args.a_at, listen=True)
    originate = _link_side(args, args.b_at, listen=False)

    assert _at_commands(answer) == ["AT&L1"]
    assert _at_commands(originate) == ["AT&L1"]
    assert answer[answer.index("--dip-preset") + 1] == "dedicated-line"
    assert originate[originate.index("--dip-preset") + 1] == "dedicated-line-originate"


def test_link_preserves_explicit_per_side_commands():
    args = _link_args("--a-at", "ATI4", "--b-at", "ATZ")

    assert _at_commands(_link_side(args, args.a_at, listen=True)) == ["ATI4"]
    assert _at_commands(_link_side(args, args.b_at, listen=False)) == ["ATZ"]
