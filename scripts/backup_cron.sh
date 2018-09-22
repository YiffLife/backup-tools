cd /home/mastodon/mastodon
echo "--------------@@@------------------" >> /home/mastodon/backup_cron.log
echo "-------initiating restic backup $(date +%Y%m%d_%H%M%S)" >> /home/mastodon/backup_cron.log
restic -r b2:yl-backup backup /home/mastodon >> /home/mastodon/backup_cron.log
echo "-------finished restic backup $(date +%Y%m%d_%H%M%S)" >> /home/mastodon/backup_cron.log
echo "-------initiating restic forget" >> /home/mastodon/backup_cron.log
restic forget --keep-last 4 --keep-daily 7 --keep-weekly 8 --keep-monthly 24
echo "-------finished restic forget" >> /home/mastodon/backup_cron.log
echo "--------------###------------------" >> /home/mastodon/backup_cron.log
