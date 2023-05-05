import os
import socket
from i3ipc import Connection


# Set the path to the socket file
socket_name = "/tmp/sway_tool_socket.socket"

i3 = Connection()

WINDOW_SIZES = [0.5, 0.33, 0.25, 0.2]
WINDOW_SIZES_REVERSE = list(reversed(WINDOW_SIZES))

def focus_left():
    i3.command('focus left')

def focus_right():
    i3.command('focus right')
    
def focus_up():
    i3.command('focus up')

def focus_down():
    i3.command('focus down')

def get_window_size(window):
    parent = window.parent
    return window.rect.width / parent.rect.width, parent.rect.height / window.rect.height

def make_smaller(window):
    width_ratio, height_ratio = get_window_size(window)
    if window.parent.layout == 'splith':
        for r in WINDOW_SIZES:
            if width_ratio > (r+0.01):
                window.command(f"resize set width {int(r*100)} ppt")
                break
        else:
            return False
        return True

    elif window.parent.layout == 'splitv':
        for r in WINDOW_SIZES:
            if height_ratio > (r+0.01):
                window.command(f"resize set height {int(r*100)} ppt")
                break
        else:
            return False
        return True

def make_bigger(window):
    width_ratio, height_ratio = get_window_size(window)
    if window.parent.layout == 'splith':
        for r in WINDOW_SIZES_REVERSE:
            if width_ratio < (r-0.01):
                window.command(f"resize set width {int(r*100)} ppt")
                break
        else:
            return False
        return True

    elif window.parent.layout == 'splitv':
        for r in WINDOW_SIZES:
            if height_ratio < (r-0.01):
                window.command(f"resize set height {int(r*100)} ppt")
                break
        else:
            return False
        return True

def move_left():
    window = i3.get_tree().find_focused()
    if has_two_workspace_windows(window):
        if window_is_left(window):
            if not make_smaller(window):
                i3.command('move left')
            return True
        elif window_is_right(window):
            if not make_bigger(window):
                i3.command('move left')
            return True
    i3.command('move left')
    return True

def move_right():
    window = i3.get_tree().find_focused()
    if has_two_workspace_windows(window):
        if window_is_right(window):
            if not make_smaller(window):
                i3.command('move right')
            return True
        elif window_is_left(window):
            if not make_bigger(window):
                i3.command('move right')
            return True
    i3.command('move right')
    return True
    
def move_up():
    i3.command('move up')

def move_down():
    i3.command('move down')


def has_two_workspace_windows(window):
    return len(window.parent.nodes) == 2

def window_is_left(window):
    return window.parent.nodes[0] == window and window.parent.layout == 'splith'

def window_is_right(window):
    return window.parent.nodes[1] == window and window.parent.layout == 'splith'

def window_is_top(window):
    return window.parent.nodes[0] == window and window.parent.layout == 'splitv'

def window_is_bottom(window):
    return window.parent.nodes[1] == window and window.parent.layout == 'splitv'

if os.path.exists(socket_name):
    os.remove(socket_name)


sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
sock.bind(socket_name)
sock.listen(1)


while True:
    conn, addr = sock.accept()
    data = conn.recv(1024)
    if data.decode().rstrip()=="left":
        focus_left()
    elif data.decode().rstrip()=="right":
        focus_right()
    elif data.decode().rstrip()=="up":
        focus_up()
    elif data.decode().rstrip()=="down":
        focus_down()
    elif data.decode().rstrip()=="move_left":
        move_left()
    elif data.decode().rstrip()=="move_right":
        move_right()
    elif data.decode().rstrip()=="move_up":
        move_up()
    elif data.decode().rstrip()=="move_down":
        move_down()

    conn.close()

