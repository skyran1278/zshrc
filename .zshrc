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
setopt inc_append_history

alias aws="docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli"

if [ -z "$VSCODE_PID" ]; then
  export NVM_LAZY_LOAD=true
  export NVM_COMPLETION=true
fi

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-nvm/zsh-nvm.plugin.zsh

# Note the source command must be at the end of ~/.zshrc.
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
