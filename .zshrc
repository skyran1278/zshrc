HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory

alias aws="docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli"

if [ -z "$VSCODE_PID" ]; then
    export NVM_LAZY_LOAD=true
fi

source /etc/zsh_command_not_found
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-nvm/zsh-nvm.plugin.zsh

eval "$(fasd --init auto)"

# Note the source command must be at the end of ~/.zshrc.
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
