
# Keys for accessing the repository
# https://restic.readthedocs.io/en/latest/030_preparing_a_new_repo.html?highlight=b2#backblaze-b2
export B2_ACCOUNT_KEY="$key"
export B2_ACCOUNT_ID="$id"
export RESTIC_REPOSITORY="$repo"
export RESTIC_PASSWORD_FILE="$pwfilepath"

# Let's go home
cd /home/mastodon/mastodon

# Set a date variable
DATE=$(date +%Y%m%d_%H%M%S)

# Let's make some logs...
touch /home/mastodon/logs/backup/backup_$DATE.log

echo "-------initiating restic backup $(date +%Y%m%d_%H%M%S)" >> /home/mastodon/logs/backup/backup_$DATE.log

# Now we will backup everything in /home/mastodon! You can change this to backup the whole system, but add --exclude="/proc/" --exclude="/sys/"

/usr/local/bin/restic -r $repo backup /home/mastodon >> /home/mastodon/logs/backup/backup_$DATE.log

echo "-------finished restic backup $(date +%Y%m%d_%H%M%S)" >> /home/mastodon/logs/backup/backup_$DATE.log

echo "-------initiating restic forget" >> /home/mastodon/logs/backup/backup_$DATE.log

# Let's forget some old backups, don't want to end up with terabytes of backups. We're not made of money, I'm sure.

/usr/local/bin/restic forget --keep-last 4 --keep-daily 7 --keep-weekly 8 --keep-monthly 24 >> /home/mastodon/logs/backup/backup_$DATE.log

echo "-------finished restic forget" >> /home/mastodon/logs/backup/backup_$DATE.log

# All done.