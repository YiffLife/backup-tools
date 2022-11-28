#!/bin/sh
# Optional Cronitor URL for status checks, work in progress for real monitoring
MONITOR_URL=''
cd /home/mastodon
curl $MONITOR_URL?state=run
echo "initiating database dump $(date +%Y%m%d_%H%M%S)" >> /home/mastodon/database_dump.log
pg_dump -Fc mastodon_production -f /home/mastodon/backups/backup_$(date +%Y%m%d_%H%M%S).dump
echo "finshed database dump $(date +%Y%m%d_%H%M%S)" >> /home/mastodon/database_dump.log
curl $MONITOR_URL?state=complete
