#!/bin/bash -x
# Change password at first login
exec > /tmp/changepwd.log 2>&1
zenity --info --text="Veuillez changer votre mot de passe utilisateur.\n\nIl doit être suffisament long et complexe.\nRègles:\n\t- 8 caractères\n\t- lettres majuscules/minuscules\n\t- chiffres"
userpasswd
if [ $? -eq 0 ]; then
    unlink ~/.config/autostart/changepwd.desktop
fi
