source ${ZDOTDIR}/themes/spaceship-prompt/spaceship.zsh-theme

SPACESHIP_TIME_SHOW=true
SPACESHIP_USER_SHOW=always

SPACESHIP_DIR_TRUNC_REPO=false

SPACESHIP_PROMPT_ORDER=(
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  exec_time     # Execution time
  line_sep      # Line break
  jobs          # Background jobs indicator
  venv          # virtualenv section
  conda         # conda virtualenv section
  exit_code     # Exit code section
  char          # Prompt character
)
