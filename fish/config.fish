if status is-interactive
  ## Adding paths
  set -e fish_user_paths
  set -U fish_user_paths ~/bin ~/.local/bin
function fish_greeting
   
   echo 
   echo ░▀█▀▒██▀▒██▀░█▄░█▒▄▀▄▒█▀▄▒█▀▄░▒░░▀█░█▀█░▀█░█▀
   echo ░▒█▒░█▄▄░█▄▄░█▒▀█░█▀█░█▀▄░█▀▒░▀▀░█▄░█▄█░█▄░██
   echo Uptime: (set_color yellow; uptime -p | sed -e 's/up //g'; set_color normal)
   echo Machine: $hostname
   echo Shell: $SHELL
end
end

starship init fish | source
alias ls='exa -lah --icons'
alias vim='nvim'
alias vi='nvim'
alias edit='nvim'
alias cls='clear'
#alias glava='glava --desktop --force-mod=bars'

alias cleanup='sudo pacman -Rns (pacman -Qtdq)' # remove orphaned packages
alias pacsyu='sudo pacman -Syu'                  # update only standard pkgs
alias pacsyyu='sudo pacman -Syyu'                # Refresh pkglist & update standard pkgs
alias yaysua='yay -Sua --noconfirm'              # update only AUR pkgs (yay)
alias yaysyu='yay -Syu --noconfirm'              # update standard pkgs and AUR pkgs (yay)

alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"


alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias rm='rm -i'


export EDITOR=nvim;
export VISUAL=nvim;
fish_add_path /home/teenarp2026/.spicetify
