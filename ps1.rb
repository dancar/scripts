# coding: utf-8

RESET = '\\e[0m'
# DIM = '\\e[2m'
DIM = '\[$(tput dim)\]'
NORMAL = '\[$(tput sgr0)\]'
UNDERLINE = '\\[$(tput smul)\\]'

BLACK = '\\e[30m'
RED = '\\e[31m'
GREEN = '\\e[32m'
YELLOW = '\\e[33m'
BLUE = '\\e[34m'
MAGENTA = '\\e[35m'
CYAN = '\\e[36m'
WHITE = '\\e[97m'
LIGHT_GRAY = '\\e[37m'
DARK_GRAY = '\\e[90m'
LIGHT_RED = '\\e[91m'
LIGHT_GREEN = '\\e[92m'
LIGHT_YELLOW = '\\e[93m'
LIGHT_BLUE = '\\e[94m'
LIGHT_MAGENTA = '\\e[95m'
LIGHT_CYAN = '\\e[96m'
LINE = GREEN

def line(x)
  [ LINE, x ]
end

def box(x, c, last=false)
  ans = [line('['), c, x]
  ans.push last ? line(']') : line(']─')
  ans
end

cwd           = box(' \\w '               , WHITE)
line_number   = box('\\!'                 , LIGHT_GRAY)
time          = box('\\t'                 , LIGHT_CYAN)
date          = box('$(date "+%Y-%m-%d")' , LIGHT_BLUE)
user_and_host = box('\\u@\\H'             , LIGHT_MAGENTA)
git           = box('$(__git_ps1)'        , YELLOW, true)

boxes = [cwd, line_number, time, date, user_and_host, git]
elements = [
  line('╭─'), boxes, LINE, '─◈\\n',
  ('└─➤ '), NORMAL
]
puts elements.flatten.join("")
