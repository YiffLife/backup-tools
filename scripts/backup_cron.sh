export B2_ACCOUNT_KEY="$key" 
export B2_ACCOUNT_ID="$id" 
export RESTIC_REPOSITORY="$repo" 
export RESTIC_PASSWORD_FILE="$pwfilepath" 

cd /home/mastodon/mastodon 
DATE=$(date +%Y%m%d_%H%M%S) 
touch /home/mastodon/logs/backup/backup_$DATE.log 
echo "-------initiating restic backup $(date +%Y%m%d_%H%M%S)" >> /home/mastodon/logs/backup/backup_$DATE.log 
/usr/local/bin/restic -r $repo backup /home/mastodon >> /home/mastodon/logs/backup/backup_$DATE.log
echo "-------finished restic backup $(date +%Y%m%d_%H%M%S)" >> /home/mastodon/logs/backup/backup_$DATE.log 
echo "-------initiating restic forget" >> /home/mastodon/logs/backup/backup_$DATE.log 
/usr/local/bin/restic forget --keep-last 4 --keep-daily 7 --keep-weekly 8 --keep-monthly 24 >> /home/mastodon/logs/backup/backup_$DATE.log
echo "-------finished restic forget" >> /home/mastodon/logs/backup/backup_$DATE.log 