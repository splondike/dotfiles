Instructions for installing a Fedora desktop from scratch.

1. Install the Sway Fedora spin. Don't set the keyboard layout to Colemak since we'll do that with Kanata.
2. Install the packages in `packages.txt`
3. Copy all the home directory directories from a backup.
4. Run the `./stow-linux.sh` script.
5. Download the kanata binary and put it into `/opt/kanata/kanata`. Copy the rest of its config in from the `root/kanata/` package. Start the Systemd service.
6. Set up Autologin: https://wiki.archlinux.org/title/SDDM#Autologin
7. Put `*/10 * * * * /usr/bin/vdirsyncer sync` in the user crontab.
8. Copy stuff to `/etc/backup`. Symlink backup_local to /etc/cron.hourly and backup_remote to /etc/cron.daily.
