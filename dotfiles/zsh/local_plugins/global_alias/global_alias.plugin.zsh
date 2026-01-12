# Global aliases {{{

# pipe to less
alias -g L='| less'
# pipe to less with line numbers
alias -g LN='| less -N'
# Grep output
alias -g G='| grep'
# RipGrep output
alias -g R='| rg'
# send output to bat as json
alias -g J='| bat -p -l json'
# send output to bat
alias -g B='| bat'
# send output to bat with choosing language
alias -g BL='| bat -l'
# show helpmessage in manpager
alias -g H='--help | nvim +Man!' # nice help viewer

# TODO: the following two should be covered by plugin or maybe kitty feature!
#
# pipe STDOUT + STDERR into xclip
alias -g XA='2>&1 | tee /dev/tty | xclip -i'
# pipe output to xclip but keep stdout there
alias -g X='| tee /dev/tty | xclip -i'

# }}}
