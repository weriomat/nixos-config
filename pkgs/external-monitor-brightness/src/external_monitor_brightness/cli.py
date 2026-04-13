#!/usr/bin/env python3
import argparse
import re
import subprocess
import sys
from typing import List, Tuple, Optional


def run_ddcutil(args: List[str]) -> subprocess.CompletedProcess:
    """Execute ddcutil with given arguments."""
    try:
        result = subprocess.run(
            ["ddcutil"] + args, capture_output=True, text=True, check=True
        )
        return result
    except subprocess.CalledProcessError as e:
        print(f"Error: {e.stderr}", file=sys.stderr)
        raise
    except FileNotFoundError:
        print(
            "Error: ddcutil not found.",
            file=sys.stderr,
        )
        sys.exit(1)


def run_swayosd(brightness: int) -> subprocess.CompletedProcess:
    """Execute swayosd-client with given arguments."""
    try:
        result = subprocess.run(
            [
                "swayosd-client",
                "--custom-progress",
                str(brightness / 100),
                "--custom-icon",
                "video-display",
            ],
            capture_output=True,
            text=True,
            check=True,
        )
        return result
    except subprocess.CalledProcessError as e:
        print(f"Error: {e.stderr}", file=sys.stderr)
        raise
    except FileNotFoundError:
        print(
            "Error: swayosd-client not found.",
            file=sys.stderr,
        )
        sys.exit(1)


def detect_displays() -> List[Tuple[int, str]]:
    """Detect all DDC/CI capable displays."""
    displays = []
    result = run_ddcutil(["detect"])

    current_num = None
    for line in result.stdout.splitlines():
        if match := re.match(r"^Display\s+(\d+)", line):
            current_num = int(match.group(1))
        elif current_num and "DRM_connector:" in line:
            name = line.split("DRM_connector:")[-1].strip()
            displays.append((current_num, name))
            current_num = None

    return displays


def get_brightness(display_num: int) -> Optional[int]:
    """Get current brightness (VCP code 10)."""
    try:
        result = run_ddcutil(["--display", str(display_num), "getvcp", "10"])
        if match := re.search(r"current value =\s+(\d+)", result.stdout):
            return int(match.group(1))
    except subprocess.CalledProcessError:
        pass
    return None


def set_brightness(display_num: int, amount: int, relative: bool = False) -> bool:
    """Set or adjust brightness."""
    try:
        if relative:
            op = "+" if amount >= 0 else "-"
            val = abs(amount)
            run_ddcutil(["--display", str(display_num), "setvcp", "10", op, str(val)])
        else:
            amount = max(0, min(100, amount))
            run_ddcutil(["--display", str(display_num), "setvcp", "10", str(amount)])
        return True
    except subprocess.CalledProcessError:
        print(f"Failed to adjust display {display_num}", file=sys.stderr)
        return False


def log(args, number: int, name: str):
    current = get_brightness(number)
    if not current and current != 0:
        print(f"No Brightness found for monitor {name}", file=sys.stderr)
        sys.exit(1)

    if args.swayosd:
        run_swayosd(current)

    if not args.quiet:
        print(f"Display {name}({number}): {current}%")


def main():
    parser = argparse.ArgumentParser(
        description="Control external monitor brightness via ddcutil"
    )

    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument(
        "--list", "-l", action="store_true", help="List displays and current brightness"
    )
    group.add_argument(
        "--inc", type=int, metavar="N", help="Increase brightness by N percent"
    )
    group.add_argument(
        "--dec", type=int, metavar="N", help="Decrease brightness by N percent"
    )
    group.add_argument(
        "--set", type=int, metavar="N", help="Set absolute brightness (0-100)"
    )

    parser.add_argument(
        "--quiet",
        "-q",
        action="store_true",
        help="Quiet the logger (for use in e.g. waybar)",
    )

    parser.add_argument(
        "--swayosd",
        "-s",
        action="store_true",
        help="Notify swayosd about change",
    )

    args = parser.parse_args()

    try:
        displays = detect_displays()
    except Exception:
        sys.exit(1)

    if not displays:
        print(
            "No DDC/CI displays found. Check 'ddcutil detect' manually.",
            file=sys.stderr,
        )
        sys.exit(1)

    if args.list:
        if not args.quiet:
            print("Detected displays:")
            for num, name in displays:
                current = get_brightness(num)
                print(f"  Display {num}: {name} (brightness: {current}%)")
        return

    for number, name in displays:
        if args.inc:
            set_brightness(number, args.inc, True)

            if args.swayosd or not args.quiet:
                log(args, number, name)

        elif args.dec:
            set_brightness(number, -args.dec, True)
            if args.swayosd or not args.quiet:
                log(args, number, name)
        elif args.set:
            set_brightness(number, args.set, False)
            if args.swayosd or not args.quiet:
                log(args, number, name)


if __name__ == "__main__":
    main()
