import sys
from typing import List
from kitty.boss import Boss
from kittens.tui.handler import result_handler


def main(args):
    pass

@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    window = boss.window_id_map.get(target_window_id)
    screen = window.screen
    cursor = screen.cursor
    # print(dir(screen))

    # TODO: How to draw coloured text, how to read the escape codes used?
    # screen.as_text(lambda x: print(x))
    # screen.draw("ls -l")

    # Erase lines, but also erases the prompt maybe? Might have to do some shenanigans
    # for _ in range(10):
    #     screen.cursor_up()
    # screen.delete_lines(10)
    # screen.cursor_up()
    # screen.delete_lines(2)

    # screen.set_margins(0, 10)

    # Send characters
    # Run $ kitty +kitten show_key to work out key codes
    for _ in range(10):
        window.send_text("normal", "\x1b[D")

    # print(screen.line(cursor.y))
    # print(cursor.x, cursor.y)
    # print(dir(cursor))

    # print(boss.window_id_map.get(target_window_id).as_dict())
    # with open("/tmp/foo", "w") as fh:
    #     fh.write("bar")
    # w = boss.window_id_map.get(target_window_id)
    # if w is not None:
    #     w.paste("foo")

