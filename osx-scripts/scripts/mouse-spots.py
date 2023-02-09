"""
Monitors stdin for events coming from Karabiner to allow warping the mouse pointer. I've tended
to pipe in a fifo that Karabiner writes to and this reads from.
"""

import sys
import select
import pyautogui as pa

while True:
    select.select([sys.stdin], [], [sys.stdin])
    line = sys.stdin.readline().strip()
    if line == "":
        continue
    try:
        args = line.split(" ")
        y_offset = 200

        screen_size = pa.size()
        x = None
        y = None
        if args[0] == "center":
            x = screen_size.width // 2
            y = screen_size.height // 2
        else:
            if args[0] == "top":
                y = y_offset
            else:
                y = screen_size.height - y_offset


            position_idx = int(args[1])
            chunk_width = screen_size.width // 5
            x = chunk_width * (position_idx + 1)

        if x and y:
            pa.moveTo(x, y)
    except IndexError:
        print(line.encode())
        print("Invalid input")
