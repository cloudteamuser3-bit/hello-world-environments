#!/usr/bin/env python3
"""Print the image_tag currently recorded in environments/<env>.yaml."""

import sys

import yaml


def main() -> None:
    if len(sys.argv) != 2:
        print("Usage: read_env_tag.py <path-to-env.yaml>", file=sys.stderr)
        sys.exit(1)

    with open(sys.argv[1]) as f:
        data = yaml.safe_load(f) or {}

    print(data.get("image_tag", "none"))


if __name__ == "__main__":
    main()
