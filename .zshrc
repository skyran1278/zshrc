# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '/home/ran/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

source /etc/zsh_command_not_found

alias aws="docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli"

if [ -z "$VSCODE_PID" ]; then
    export NVM_LAZY_LOAD=true
fi

eval "$(fasd --init auto)"
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-nvm/zsh-nvm.plugin.zsh

# Note the source command must be at the end of ~/.zshrc.
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
