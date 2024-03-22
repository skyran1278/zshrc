# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# https://linux.die.net/man/1/zshoptions
# history
HISTSIZE=2000                 # in-memory
SAVEHIST=1000                 # history file
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_all_dups   # If a new command line being added to the history list duplicates an older one, the older command is removed from the list (even if it is not the previous event).
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data, like inc_append_history
setopt hist_fcntl_lock        # On recent operating systems this may provide better performance, in particular avoiding history corruption when files are stored on NFS.

# directories
setopt auto_cd
setopt auto_pushd             # automatically push directories onto directory stack to allow for easy navigation popd
setopt pushd_ignore_dups
setopt pushdminus             # cd -

# prompt
setopt prompt_subst           # Allows prompt strings to be evaluated for parameter expansion, command substitution, and arithmetic expansion.

# comment
setopt interactive_comments  # Allow comments even in interactive shells.

alias aws="docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli"
alias yd="yarn dev"
alias pd="pnpm dev"
alias np="pnpm"
alias pn="pnpm"

local-restart() {
  docker stop dentsu-postgres
  docker rm -v dentsu-postgres
  docker run --name dentsu-postgres -e POSTGRES_PASSWORD=root -p 5432:5432 --restart=always -d postgres:15
  until docker exec dentsu-postgres pg_isready; do
    echo -e "\033[31m$(date) - waiting for postgres...\033[0m"
    sleep 1
  done

  echo -e "\033[32mPostgres is ready.\033[0m"
  echo
  # https://www.postgresql.org/docs/current/app-psql.html
  docker exec -it dentsu-postgres psql -U postgres -d postgres -c "CREATE SCHEMA bpm;"
}

local-seed() {
  cat ./libs/db/seeder.sql | docker exec -i dentsu-postgres psql -U postgres -d postgres
  cat ./libs/bpm-db/bpm-seeder.sql | docker exec -i dentsu-postgres psql -U postgres -d postgres
}

local-sync() {
  docker stop dentsu-postgres
  docker rm -v dentsu-postgres
  docker run --name dentsu-postgres -e POSTGRES_PASSWORD=root -p 5432:5432 --restart=always -d postgres:15
  until docker exec dentsu-postgres pg_isready; do
    echo -e "\033[31m$(date) - waiting for postgres...\033[0m"
    sleep 1
  done

  echo -e "\033[32mPostgres is ready.\033[0m"
  echo
  # https://www.postgresql.org/docs/current/app-psql.html
  docker exec -i dentsu-postgres pg_dump --host=10.0.0.10 --port=5433 --dbname=dentsu-piano-dev --username=dentsu_user --format=custom --verbose --no-owner | docker exec -i dentsu-postgres pg_restore --username=postgres --dbname=postgres --verbose --no-owner

  # home mac to windows
  # docker exec -i dentsu-postgres pg_dump --host=192.168.0.255 --port=5432 --dbname=postgres --username=postgres --format=custom --verbose --no-owner | docker exec -i dentsu-postgres pg_restore --username=postgres --dbname=postgres --verbose --no-owner

  # server to local
  # docker exec -i dentsu-postgres pg_dump --host=10.0.0.10 --port=5433 --dbname=dentsu-piano-dev --username=dentsu_user --format=custom --verbose --no-owner --data-only --disable-triggers --superuser=dentsu_user | docker exec -i dentsu-postgres pg_restore --username=postgres --dbname=postgres --verbose --no-owner --disable-triggers --superuser=postgres
  # local to server
  # docker exec -i dentsu-postgres pg_dump --username=postgres --format=custom --verbose --data-only --dbname=postgres --no-owner --disable-triggers --superuser=postgres | docker exec -i dentsu-postgres pg_restore --host=10.0.0.10 --port=5433 --dbname=dentsu-piano-dev --username=dentsu_user --verbose --no-owner --disable-triggers --superuser=dentsu_user
}

test-restart() {
  docker stop test-postgres
  docker rm -v test-postgres
  docker run --name test-postgres -e POSTGRES_PASSWORD=root -p 5433:5432 --restart=always -d postgres
  until docker exec test-postgres pg_isready; do
    echo -e "\033[31m$(date) - waiting for postgres...\033[0m"
    sleep 1
  done

  echo -e "\033[32mPostgres is ready.\033[0m"
  echo
}

# dev-restart() {
#   docker exec -it dentsu-postgres psql -h 10.0.0.10 -p 5433 -d dentsu-piano-dev -U dentsu_user -c "
#     DROP SCHEMA public CASCADE;
#     CREATE SCHEMA public;

#     DROP SCHEMA bpm CASCADE;
#     CREATE SCHEMA bpm;
#   "
# }

# dev-seed() {
#   cat ./libs/db/seeder.sql | docker exec -i dentsu-postgres psql -h 10.0.0.10 -p 5433 -d dentsu-piano-dev -U dentsu_user
#   cat ./libs/bpm-db/bpm-seeder.sql | docker exec -i dentsu-postgres psql -h 10.0.0.10 -p 5433 -d dentsu-piano-dev -U dentsu_user

#   # docker cp ./libs/db/seeder.sql dentsu-postgres:/seeder.sql
#   # docker exec -it dentsu-postgres psql -h 10.0.0.10 -p 5433 -d dentsu-piano-dev -U dentsu_user -f /seeder.sql

#   # docker cp ./libs/bpm-db/bpm-seeder.sql dentsu-postgres:/seeder.sql
#   # docker exec -it dentsu-postgres psql -h 10.0.0.10 -p 5433 -d dentsu-piano-dev -U dentsu_user -f /seeder.sql
# }


if [ -z "$VSCODE_PID" ]; then
  export NVM_LAZY_LOAD=true
  export NVM_COMPLETION=true
fi

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-nvm/zsh-nvm.plugin.zsh

# Note the source command must be at the end of ~/.zshrc.
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
