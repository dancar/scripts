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

boxes = { #[cwd, line_number, time, date, user_and_host, git]
cwd:           box(' \\w '               , WHITE),
status:        box('$(__status)'         , LIGHT_GREEN),
line_number:   box('\\!'                 , LIGHT_GRAY),
time:          box('\\t'                 , LIGHT_CYAN),
date:          box('$(date "+%Y-%m-%d")' , LIGHT_BLUE),
user_and_host: box('\\u@\\H'             , LIGHT_YELLOW),
git:           box('$(__git_ps1)'        , YELLOW, true),
}
elements = [
  line('┌'), boxes.values, LINE, '\\n',
      ('└➤  '), NORMAL
]
puts elements.flatten.join("")
# puts "\$(if [ \$? == 0 ]; then echo zero; else echo nonzero; fi) "
