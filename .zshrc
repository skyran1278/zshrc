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

if [ -z "$VSCODE_PID" ]; then
  export NVM_LAZY_LOAD=true
  export NVM_COMPLETION=true
fi

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-nvm/zsh-nvm.plugin.zsh

# Note the source command must be at the end of ~/.zshrc.
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
