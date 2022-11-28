#!/bin/sh

# Cronitor URL - optional
MONITOR_URL='https://cronitor.link/p/b437916643d24eea9a322ce3de64709b/sNMIyG'

# Keys for accessing the repository
# https://restic.readthedocs.io/en/latest/030_preparing_a_new_repo.html?highlight=b2#backblaze-b2
export B2_ACCOUNT_KEY="$key"
export B2_ACCOUNT_ID="$id"
export RESTIC_REPOSITORY="$repo"
export RESTIC_PASSWORD_FILE="$pwfilepath"

# Let's go home
cd /home/mastodon

# Optional Cronitor state check
curl $MONITOR_URL?state=run

# Set a date variable
DATE=$(date +%Y%m%d_%H%M%S)

# Making some logs...
touch /home/mastodon/logs/backup/backup_$DATE.log

# Making a backup of nginx configs
cp -r /etc/nginx* /home/mastodon/nginxbackup

# Now we will backup everything in /home/mastodon! You can change this to backup the whole system, but add --exclude="/proc/" --exclude="/sys/"
echo "-------initiating restic backup $(date +%Y%m%d_%H%M%S)" >> /home/mastodon/logs/backup/backup_$DATE.log
restic -r $repo backup /home/mastodon >> /home/mastodon/logs/backup/backup_$DATE.log
echo "-------finished restic backup $(date +%Y%m%d_%H%M%S)" >> /home/mastodon/logs/backup/backup_$DATE.log

# Let's forget some old backups, don't want to end up with terabytes of backups. We're not made of money, I'm sure.
echo "-------initiating restic forget" >> /home/mastodon/logs/backup/backup_$DATE.log
restic forget --keep-last 4 --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune >> /home/mastodon/logs/backup/backup_$DATE.log
echo "-------finished restic forget" >> /home/mastodon/logs/backup/backup_$DATE.log

# Removing some old log files
find /home/mastodon/backups/backup_* -mtime +5 -exec rm {} \;

# Optional Cronitor state check
curl $MONITOR_URL?state=complete

# All done.
