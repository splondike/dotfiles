#!/usr/bin/env python3
"""
Doesn't access all secrets, just ones tagged with a special value in
the comment.
"""

import argparse
import subprocess


def parse():
    parser = argparse.ArgumentParser(
        description="Simplified CLI for the OSX keychain that wraps the native one.",
    )
    # Maybe later
    # parser.add_argument(
    #     "--keychain",
    #     help="Specify the keychain to use rather than the default"
    # )
    subparsers = parser.add_subparsers(
        dest="command",
        help="Commands",
        required=True
    )

    set_parser = subparsers.add_parser("set", help="Set value help")
    set_parser.add_argument("key", help="The key to save the value at")

    get_parser = subparsers.add_parser("get", help="Get value help")
    get_parser.add_argument("key", help="The key to get the value of")

    list_parser = subparsers.add_parser("list", help="List all value keys")

    delete_parser = subparsers.add_parser("delete", help="Delete value help")
    delete_parser.add_argument("key", help="The key to delete")

    return parser.parse_args()

def _extract_value(line: str, prefix: str):
    l = len(prefix)
    return line[line.find("\"", l)+1:-1]


def command_list(args):
    command = ["security", "dump-keychain"]
    result = subprocess.run(command, capture_output=True, check=True)
    cls = ""
    acct = ""
    comment = ""
    for line_ in result.stdout.splitlines():
        line = line_.strip().decode()
        aprefix = "\"acct\"<blob>="
        sprefix = "\"svce\"<blob>="
        comprefix = "\"icmt\"<blob>="
        clsprefix = "class: \""
        if line.startswith(aprefix):
            acct = _extract_value(line, aprefix)
        if line.startswith(clsprefix):
            cls = line[len(clsprefix):-1]
        if line.startswith(comprefix):
            comment = _extract_value(line, comprefix)
        if line.startswith(sprefix):
            name = _extract_value(line, sprefix)
            if cls == "genp" and comment.startswith("##simplesecret##"):
                print(name)
            cls = ""
            acct = ""
            comment = ""


def command_get(args):
    command = ["security", "find-generic-password", "-s", args.key, "-w"]
    subprocess.run(command, check=True)


def command_set(args):
    password = input()
    command_delete(args)
    comment = "##simplesecret##"
    command = [
        "security",
        "add-generic-password",
        "-a",
        "password",
        "-s",
        args.key,
        "-C",
        "genp",
        "-U",
        "-T",
        "",
        "-w",
        password,
        "-j",
        comment,
    ]
    subprocess.run(command, check=True)


def command_delete(args):
    command = [
        "security",
        "delete-generic-password",
        "-s",
        args.key,
    ]
    subprocess.run(command, capture_output=True, check=True)


def main():
    result = parse()
    if result.command == "list":
        command_list(result)
    elif result.command == "get":
        command_get(result)
    elif result.command == "set":
        command_set(result)
    elif result.command == "delete":
        command_delete(result)
    else:
        raise RuntimeError("Unknown command: " + result.command)


if __name__ == "__main__":
    main()
