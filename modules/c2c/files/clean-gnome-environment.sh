if [ ! -d $HOME/.gnome-env-backup ]; then
  mkdir $HOME/.gnome-env-backup
fi
for dir in .gconf .gconfd .gnome .gnome2 .gnome2_private .local .config
do
  mv -i $HOME/$dir $HOME/.gnome-env-backup/
done
