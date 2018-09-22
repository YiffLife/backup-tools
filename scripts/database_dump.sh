cd /home/mastodon/mastodon
echo "initiating database dump $(date +%Y%m%d_%H%M%S)" >> /home/mastodon/database_dump.log
docker exec mastodon_db_1 pg_dump -Fc -U postgres postgres > /home/mastodon/backups/backup_$(date +%Y%m%d_%H%M%S).dump
echo "finshed database dump $(date +%Y%m%d_%H%M%S)" >> /home/mastodon/database_dump.log
