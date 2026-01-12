# =======================================================
#
# Shell Functions
#
#
# =======================================================

# Clipboard functions{{{

# TODO: is implemented as zsh plugin already?
xcfile()
{ # TODO (Berti): review
  cat $1 | xclip -selection clipboard
}

xpfile()
{
  filename=$1
  xclip -o > "$filename"
}


#}}}


# FIXME: use virtualenv
# but create vmr and move
create_python_venv () {
  python3 -m venv "${PYTHON_VENVS}/$(basename $(pwd))"
}

activate_python_venv () {
  source "$(poetenv)/bin/activate"
  # source "$PYTHON_VENVS}/$(basename $(pwd))/bin/activate"
}
python::venv::name () {
  dir_=$1
  git_base_path=$(_git_base_path "$dir_")
  hash_=$(echo "$git_base_path" | md5sum | head -c 10)
  base_path=$(basename "$git_base_path")
  venv_name="$base_path-$hash_"
  venv_path=$PYTHON_VENVS/$venv_name
  print "$venv_path"
}

python::venv::create () {
  venv_path=$(python::venv::name "$PWD")
  python3 -m venv "$venv_path"
}

python::venv::delete () {
  venv_path=$(python::venv::name "$PWD")
  rm -rf "$venv_path"
}

python::venv::activate () {
  venv_path=$(python::venv::name "$PWD")
  source "$venv_path/bin/activate"
}

python::venv::pactivate () {
  source "$(poetenv)/bin/activate"
}

python::venv::pdelete () {
  if [ -z "$1" ]; then
    python_version=python3.8
  else
    python_version=$1
  fi
  poetry env remove "${python_version}"

}

# convenience around databricks dbfs cli
dbfsl () {
  dbfs ls dbfs:$1
}


# interact with my configured vpn service
vpn () {
  opt=$1
  case $opt
  in
    status)
      systemctl status vpn
      ;;
    *)
      sudo systemctl "$opt" vpn
      ;;
  esac
}

_is_git_repo () {
  git rev-parse --is-inside-work-tree
}

_git_base_path() {
  base_path=$(git rev-parse --show-toplevel)
  print "$base_path"
}


cheat() {
  command_=$1
  curl "cheat.sh/${command_}"
}

weather() {
  options_=$1
  curl "wttr.in/${options_}"
}

work() {
  workdir="${WORKSPACE}/$1"
  if [ -d  "$workdir" ]; then
    cd "$workdir"
  else
    echo "creating $workdir"
    mkdir -p "$workdir"
    cd "$workdir"
  fi
}

pyf() {
  if [ $# -eq 0 ]; then
    folders="."
  else
    folders=($@)
  fi

  fd -E "__init__.py" ".py$" $folders
}


# Function to find files with specified extensions, optionally excluding __init__.py
find_files() {
  local exclude_init=true
  local extensions=("py")
  local folders=(".")

  while [[ $# -gt 0 ]]; do
    case $1 in
      --include-init)
        exclude_init=false
        shift
        ;;
      -t|--type)
        shift
        extensions=(${1//,/ })
        shift
        ;;
      *)
        folders+=("$1")
        shift
        ;;
    esac
  done

  local ext_pattern=$(printf "|%s" "${extensions[@]}")
  ext_pattern=${ext_pattern:1}  # Remove leading |

  if $exclude_init; then
    fd -E "__init__.py" -e $ext_pattern ${folders[@]}
  else
    fd -e $ext_pattern ${folders[@]}
  fi
}

# Function to open files with the specified editor
vpy() {
  local editor=${EDITOR:-nvim}
  local folders=(".")

  if [[ $# -gt 0 ]]; then
    folders=("$@")
  fi

  "$editor" $(find_files "${folders[@]}")
}

# Generalized function for opening files with specified types
# TODO: make v command out of it, -> should become fpath function and loaded on invocation only
ev() {
  local editor=${EDITOR:-nvim}
  local extensions=("py")
  local include_init=false
  local folders=(".")

  while [[ $# -gt 0 ]]; do
    case $1 in
      --include-init)
        include_init=true
        shift
        ;;
      -t|--type)
        shift
        extensions=(${1//,/ })
        shift
        ;;
      *)
        folders+=("$1")
        shift
        ;;
    esac
  done

  if $include_init; then
    "$editor" $(find_files --include-init -t "${extensions[@]}" "${folders[@]}")
  else
    "$editor" $(find_files -t "${extensions[@]}" "${folders[@]}")
  fi
}


# cdg() {
#     git_base_path=$(git rev-parse --show-toplevel 2>/dev/null)
#     if [ $? -ne 0 ]; then
#         echo "Not a git repository"
#         return 1
#     fi
#     cd "$git_base_path"
# }

# interaction with git repo and worktree - but not working as expected
# FIXME: need to fix issues and redesign properly
cdg() {
    if [ $# -eq 0 ]; then
        git_base_path=$(git rev-parse --show-toplevel 2>/dev/null)
        if [ $? -ne 0 ]; then
            echo "Not a git repository"
            return 1
        fi
        cd "$git_base_path"
    else
        branch_name=$1
        git_base_path=$(git rev-parse --show-toplevel 2>/dev/null)
        if [ $? -ne 0 ]; then
            echo "Not a git repository"
            return 1
        fi
        worktree_path="${git_base_path}/worktrees/${branch_name}"

        if [ -d "$worktree_path" ]; then
            cd "$worktree_path"
        else
            echo "Worktree for branch '$branch_name' does not exist. Create it? (y/n)"
            read answer
            if [ "$answer" != "${answer#[Yy]}" ]; then
                mkdir -p "$worktree_path"
                git worktree add "$worktree_path" "$branch_name"
                cd "$worktree_path"
            else
                echo "Operation canceled."
                return 1
            fi
        fi
    fi
}

# FIXME: is bash completion so inactive
# Autocompletion for branch names
# _cdg_complete() {
#     local cur branches
#     cur=${COMP_WORDS[COMP_CWORD]}
#     branches=$(git branch --all | grep -v '/HEAD' | grep -oE '[^ ]+$')
#     COMPREPLY=( $(compgen -W "$branches" -- "$cur") )
# }
# complete -F _cdg_complete cdg

# Fzf version of cdg
cdg_fzf() {
    git_base_path=$(git rev-parse --show-toplevel 2>/dev/null)
    if [ $? -ne 0 ]; then
        echo "Not a git repository"
        return 1
    fi
    branch_name=$(git branch --all | grep -v '/HEAD' | grep -oE '[^ ]+$' | fzf)
    if [ -z "$branch_name" ]; then
        echo "No branch selected"
        return 1
    fi
    cdg "$branch_name"
}



knew () {
  # restart kde after crashing - happens quite regular
        kquitapp5 plasmashell
        kstart5 plasmashell
}



# {{{
# mkcd is equivalent to takedir
# FIXME: load from omz instead of copying here!
function mkcd takedir() {
  mkdir -p $@ && cd ${@:$#}
}

function takeurl() {
  local data thedir
  data="$(mktemp)"
  curl -L "$1" > "$data"
  tar xf "$data"
  thedir="$(tar tf "$data" | head -n 1)"
  rm "$data"
  cd "$thedir"
}

function takegit() {
  git clone "$1"
  cd "$(basename ${1%%.git})"
}

function take() {
  if [[ $1 =~ ^(https?|ftp).*\.tar\.(gz|bz2|xz)$ ]]; then
    takeurl "$1"
  elif [[ $1 =~ ^([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?$ ]]; then
    takegit "$1"
  else
    takedir "$@"
  fi
}

# }}}

# FIXME: make a bit more user friendly so i utilize it
# e.g. --recursive option to traverse subfolders, globbing and such
# create __init__.py in all folders provided if not exist
function initpy() {
  for f in $@
    do
      touch $f/__init__.py
    done
}


