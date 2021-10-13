# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

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
