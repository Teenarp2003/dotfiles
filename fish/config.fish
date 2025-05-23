if status is-interactive
  ## Adding paths
  set -e fish_user_paths
  set -U fish_user_paths ~/.config/bin ~/.local/bin ~/.local/share/gem/ruby/3.0.0/bin
function fish_greeting
   
    #   echo 
    #   echo ░▀█▀▒██▀▒██▀░█▄░█▒▄▀▄▒█▀▄▒█▀▄░▒░░▀█░█▀█░▀█░█▀
    #   echo ░▒█▒░█▄▄░█▄▄░█▒▀█░█▀█░█▀▄░█▀▒░▀▀░█▄░█▄█░█▄░██
       echo Uptime: (set_color yellow; uptime -p | sed -e 's/up //g'; set_color normal)
    #   echo Machine: $hostname
    #   echo Shell: $SHELL
  end
end

starship init fish | source
alias ls='eza -lah --icons'
alias vim='nvim'
alias vi='nvim'
alias edit='nvim'
alias cls='clear'
#alias glava='glava --desktop --force-mod=bars'
alias lampp='sudo /opt/lampp/lampp'
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
alias mount-phone='sshfs -p 8022 u0_a412@192.168.1.6:/sdcard/ ~/Phone'
alias fzf='fzf -e'
alias feh='feh --scale-down'
export EDITOR=/usr/bin/nvim;
export VISUAL=nvim;

fish_add_path /home/teenarp2026/.spicetify
nitch



# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
