
setopt AUTO_CD
setopt AUTO_PUSHD           # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
# create nice aliases for jumping in the last folders
# taken from https://thevaluable.dev/zsh-install-configure-mouseless/
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index
