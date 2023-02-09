import re
import subprocess

def mark(text, args, Mark, extra_cli_args, *a):
    regex = r"([a-z0-9]+[-_])+[a-z0-9]+"
    for idx, m in enumerate(re.finditer(regex, text, re.I)):
        start, end = m.span()
        mark_text = text[start:end].replace('\n', '').replace('\0', '')
        yield Mark(idx, start, end, mark_text, {})


def handle_result(args, data, target_window_id, boss, extra_cli_args, *a):
    w = boss.window_id_map.get(target_window_id)
    if w is not None:
        w.paste_bytes(data["match"][0].encode())
