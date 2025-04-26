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
test3_restart() {
  docker compose down --remove-orphans -v
  docker compose up -d
}

espm_restore() {
  mongo mongodump --uri=url --out /mongo/backup
  mongo mongorestore --drop --uri=url /mongo/backup
}

# === Compinit ===
# fpath=(~/.zsh/completions $fpath)
# autoload -Uz compinit
# compinit -u

# === Plugins ===
# Ensure plugins are loaded after compinit
. ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Lazy load NVM if not in VS Code
if [ -z "$VSCODE_PID" ]; then
  export NVM_LAZY_LOAD=true
  export NVM_COMPLETION=true
fi

. ~/.zsh/zsh-nvm/zsh-nvm.plugin.zsh
# . ~/.deno/env

# Note the source command must be at the end of ~/.zshrc.
. ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# https://github.com/zsh-users/zsh-history-substring-search
# If you want to use zsh-syntax-highlighting along with this script, then make sure that you load it before you load this script:
. ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

# === Keybindings ===
# wsl2
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# mac
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
