#!/bin/bash
#
# This file can contain commands that will be executed (as root) at the end of
# EndeavourOS install (in online mode only) on the target system.
#
# NOTE! This is an advanced feature, so you need to know exactly
# what you are doing. Otherwise bad things can happen...
# Sound knowledge of bash language and linux commands is required
# for a meaningful customization.
#
# If you add commands to this file, start the whole install process fresh
# with terminal command 'eos-welcome' after saving this file.
#
# Tip: save your customized commands into a file on an internet server
# and fetch that file with command:
#
#     wget -O ~/user_commands.bash "URL-referring-the-file"
#
# Here you may customize the installed system in several ways.
#
# Ideas for customization:
#   - install packages
#   - remove packages
#   - enable or disable system services
#   - writing dotfiles under $HOME
#   - etc.
#
# Example commands:
#     pacman -S --noconfirm --needed gufw geany chromium
#     pacman -Rsn --noconfirm xed
#     systemctl enable ufw
#
# There are some limitations to the commands:
#   - The 'pacman' commands mentioned above require option '--noconfirm',
#     otherwise the install process may hang because pacman waits for a
#     confirmation!
#   - Installing packages with 'yay' does not work because yay may not
#     be run as root.
#     The 'makepkg' command suffers from the same limitation.
#     This essentially blocks installing AUR packages here.
#
# Tip: if you write new files into the home directory of the new user,
# make sure to properly set the file permissions too.
#
#----------------------------------------------------------------------------------
#
# Now *you* can add your commands into function _PostInstallCommands below.
#
#----------------------------------------------------------------------------------

_PostInstallCommands() {
    ## Add your "late-install" commands here.
    ## This is executed as root near the end of calamares execution.

    local -r username="$1"              # new user you created for the target
    local -r home="/home/$username"     # fix home shell variable for specific username convention
    ## Now your commands. Some examples:
    #
    # echo "## Hello world!"           >> /home/$username/.bashrc
    # echo "export FUNCNEST=100"       >> /home/$username/.bashrc
    # echo "alias pacdiff=eos-pacdiff" >> /home/$username/.bashrc
    # chmod $username:$username           /home/$username/.bashrc
    _pacman() {


        pacman -S --noconfirm --needed kio-gdrive
    }
    _pacman

    _mkdots() {
        mkdir -p $home/Dev
        mkdir -p $home/.android
        mkdir -p $home/.sduckdots
        mkdir -p $home/.local/share/fonts
        mkdir -p $home/.fonts
        mkdir -p $home/.bin
        mkdir -p $home/.local/bin
        mkdir -p $home/.cache/lm-
    }
    _mkdots

    _flatpak() {
        echo -e "Install Flatpak & Predetermined Software"

        flatpak install com.microsoft.Edge #find full package name(s)
        flatpal install steam
        flatpak install lutris #xbox?
        flatpak install spotify
        flatpak install lm-aimodels #fix with actual name of software
        flatpak install
        if [ -z "$home/.zshrc" ]; then
            for app in $(ls /var/lib/flatpak/exports/bin); do echo -e 'alias ${app:-1}='$app'' >>/$home/.zshrc; done
        else
            for app in $(ls /var/lib/flatpak/exports/bin); do echo -e 'alias ${app:-1}='$app'' >>/$home/.bashrc; done
        fi

        echo -e "All Flatpak Software has been installed and aliases created"

    }
    _flatpak

    _nerd_fonts() {
        echo -e "Installing Nerd Fonts"
        for font in $(pacman -Sg nerd-fonts); do pacman -S --noconfirm --needed $font; done
        fc-cache -frv
        echo -e "Nerd Fonts Installed"
    }
    _nerd_fonts
    # ...
}

## Execute the commands if the parameter list is valid:

case "$1" in
    --iso-conf* | online | offline | community) ;;   # no more supported here
    *) _PostInstallCommands "$1" ;;
esac

