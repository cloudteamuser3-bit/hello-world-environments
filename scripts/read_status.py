#!/usr/bin/env python3
"""Read status/<env>.json and print KEY=VALUE lines. Pure stdlib json."""

import json
import sys


def main() -> None:
    if len(sys.argv) != 2:
        print("Usage: read_status.py <path-to-status.json>", file=sys.stderr)
        sys.exit(1)

    with open(sys.argv[1]) as f:
        data = json.load(f)

    print(f"RESULT={data.get('result', '')}")
    print(f"IMAGE_TAG={data.get('image_tag', '')}")
    print(f"IMAGE_DIGEST={data.get('image_digest', '')}")
    print(f"APPLIED_AT={data.get('applied_at', '')}")


if __name__ == "__main__":
    main()
