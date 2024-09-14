# === Powerlevel10k Prompt ===
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# === SSH Agent Management ===
# wsl only
# https://unix.stackexchange.com/a/316560
# Note that ssh-add without arguments adds ~/.ssh/id_rsa, ~/.ssh/id_ecdsa, ~/.ssh/id_ed25519.
# You might want to pass ssh-add arguments if your private keys are in another file.
# ~/.zshrc for zsh shell and ~/.profile for vscode extension
# if [ ! -S ~/.ssh/ssh_auth_sock ]; then
#   eval `ssh-agent` > /dev/null
#   ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
# fi
# export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock

# === History Configuration ===
# https://github.com/ohmyzsh/ohmyzsh/blob/eeb01c18c1d1edff0c2563764a998b2d30947844/lib/history.zsh
# https://linux.die.net/man/1/zshoptions
HISTFILE=$HOME/.zsh_history
HISTSIZE=50000                # Max in-memory history entries
SAVEHIST=10000                # Max history entries saved to file
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

# === Prompt Options ===
setopt prompt_subst           # Allows prompt strings to be evaluated for parameter expansion, command substitution, and arithmetic expansion.
setopt interactive_comments   # any line beginning with # in your terminal will be ignored by Zsh.

# === Aliases ===
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-docker.html#cliv2-docker-aliases
alias aws="docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli"
alias mongo="docker run --user $(id -u):$(id -g) --rm -it -v $(pwd):/mongo mongo"
alias np="pnpm"
alias pn="pnpm"

# === Custom Functions ===
local_restart() {
  docker stop dentsu-postgres
  docker rm -v dentsu-postgres
  docker run --name dentsu-postgres -e POSTGRES_USER=dentsu_user -e POSTGRES_PASSWORD=foritech -e POSTGRES_DB=dentsu-piano-dev -p 4320:5432 --restart=always -d postgres
  until docker exec dentsu-postgres pg_isready; do
    echo -e "\033[31m$(date) - waiting for postgres...\033[0m"
    sleep 1
  done

  echo -e "\033[32mPostgres is ready.\033[0m"
  echo
}

local_sync_4i() {
  local_restart

  # https://www.postgresql.org/docs/current/app-psql.html
  docker exec -i dentsu-postgres pg_dump --dbname=postgresql://dentsu_user:foritech@10.0.0.10:4320/dentsu-piano-dev --format=custom --verbose --no-owner | docker exec -i dentsu-postgres pg_restore --username=dentsu_user --dbname=dentsu-piano-dev --verbose --no-owner
}

local_sync_dev() {
  local_restart

  # https://www.postgresql.org/docs/current/app-psql.html
  docker exec -i dentsu-postgres pg_dump --dbname=postgresql://adminlogin:Welcome%401234@azjaw1dpiadbp01.postgres.database.azure.com:5432/dentsu_piano_dev --format=custom --verbose --no-owner | docker exec -i dentsu-postgres pg_restore --username=dentsu_user --dbname=dentsu-piano-dev --verbose --no-owner
}

local_sync_qa() {
  local_restart

  # https://www.postgresql.org/docs/current/app-psql.html
  docker exec -i dentsu-postgres pg_dump --dbname=postgresql://adminlogin:Welcome%401234@azjaw1dpiadbp01.postgres.database.azure.com:5432/dentsu_piano_qa --format=custom --verbose --no-owner | docker exec -i dentsu-postgres pg_restore --username=dentsu_user --dbname=dentsu-piano-dev --verbose --no-owner
}

local_sync_staging() {
  local_restart

  # https://www.postgresql.org/docs/current/app-psql.html
  docker exec -i dentsu-postgres pg_dump --dbname=postgresql://adminlogin:Welcome%401234@azjaw1dpiadbp01.postgres.database.azure.com:5432/dentsu_piano_stg --format=custom --verbose --no-owner | docker exec -i dentsu-postgres pg_restore --username=dentsu_user --dbname=dentsu-piano-dev --verbose --no-owner
}

dev_sync_qa() {
  docker exec -it dentsu-postgres psql --dbname=postgresql://adminlogin:Welcome%401234@azjaw1dpiadbp01.postgres.database.azure.com:5432/dentsu_piano_dev -c "
    DROP SCHEMA \"piano-main\" CASCADE;
    DROP SCHEMA \"piano-bpm\" CASCADE;
  "

  # https://www.postgresql.org/docs/current/app-psql.html
  docker exec -i dentsu-postgres pg_dump --dbname=postgresql://adminlogin:Welcome%401234@azjaw1dpiadbp01.postgres.database.azure.com:5432/dentsu_piano_qa --format=custom --verbose --no-owner | docker exec -i dentsu-postgres pg_restore --dbname=postgresql://adminlogin:Welcome%401234@azjaw1dpiadbp01.postgres.database.azure.com:5432/dentsu_piano_dev --verbose --no-owner
}

4i_sync_dev() {
  docker exec -it dentsu-postgres psql --dbname=postgresql://dentsu_user:foritech@10.0.0.10:4320/dentsu-piano-dev -c "
    DROP SCHEMA \"piano-main\" CASCADE;
    DROP SCHEMA \"piano-bpm\" CASCADE;
  "

  # https://www.postgresql.org/docs/current/app-psql.html
  docker exec -i dentsu-postgres pg_dump --dbname=postgresql://adminlogin:Welcome%401234@azjaw1dpiadbp01.postgres.database.azure.com:5432/dentsu_piano_dev --format=custom --verbose --no-owner | docker exec -i dentsu-postgres pg_restore --dbname=postgresql://dentsu_user:foritech@10.0.0.10:4320/dentsu-piano-dev --verbose --no-owner
}

exec_sql_to_4_environments() {
  sql=$1

  docker exec -it dentsu-postgres psql --dbname=postgresql://dentsu_user:foritech@10.0.0.10:4320/dentsu-piano-dev -c "$sql"
  docker exec -it dentsu-postgres psql --dbname=postgresql://adminlogin:Welcome%401234@azjaw1dpiadbp01.postgres.database.azure.com:5432/dentsu_piano_dev -c "$sql"
  docker exec -it dentsu-postgres psql --dbname=postgresql://adminlogin:Welcome%401234@azjaw1dpiadbp01.postgres.database.azure.com:5432/dentsu_piano_qa -c "$sql"
  docker exec -it dentsu-postgres psql --dbname=postgresql://adminlogin:Welcome%401234@azjaw1dpiadbp01.postgres.database.azure.com:5432/dentsu_piano_stg -c "$sql"
}

test3_restart() {
  docker compose down --remove-orphans -v
  docker compose up -d
}

espm_restore() {
  mongo mongodump --uri=url --out /mongo/backup
  mongo mongorestore --drop --uri=url /mongo/backup
}

# === Compinit ===
fpath=(~/.zsh/completions $fpath)
autoload -Uz compinit
compinit -u

# === Plugins ===
# Ensure plugins are loaded after compinit
. ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Lazy load NVM if not in VS Code
if [ -z "$VSCODE_PID" ]; then
  export NVM_LAZY_LOAD=true
  export NVM_COMPLETION=true
  export VSCODE_SUGGEST=1
fi

. ~/.zsh/zsh-nvm/zsh-nvm.plugin.zsh
# . ~/.deno/env
# . "$HOME/.local/bin/env"

# Note the source command must be at the end of ~/.zshrc.
. ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# https://github.com/zsh-users/zsh-history-substring-search
# If you want to use zsh-syntax-highlighting along with this script, then make sure that you load it before you load this script:
. ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/Users/ran/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/Users/ran/miniconda3/etc/profile.d/conda.sh" ]; then
#         . "/Users/ran/miniconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/Users/ran/miniconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<

# === VS Code Terminal Shell Integration ===
# Enable rich shell integration in VS Code's integrated terminal
# https://code.visualstudio.com/docs/terminal/shell-integration
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  # Performance-first: inline the script path to avoid spawning Node on each shell startup
  VS_CODE_ZSH_INTEGRATION="/Applications/Visual Studio Code.app/Contents/Resources/app/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration-rc.zsh"
  if [[ -r "$VS_CODE_ZSH_INTEGRATION" ]]; then
    . "$VS_CODE_ZSH_INTEGRATION"
  # Fallback to portable approach if the app path differs (e.g., non-standard install)
  elif command -v code >/dev/null 2>&1; then
    . "$(code --locate-shell-integration-path zsh)"
  fi
fi

# === Keybindings ===
# wsl2
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# mac
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
