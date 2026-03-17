#!/bin/bash
DB="$HOME/.cache/xfce4/notifyd/log.sqlite"

case "$1" in
  count)
    UNREAD=$(sqlite3 "$DB" "SELECT COUNT(*) FROM notifications WHERE is_read=0;")
    TOTAL=$(sqlite3 "$DB" "SELECT COUNT(*) FROM notifications;")
    if [ "$UNREAD" -gt 0 ]; then
      echo "{\"text\": \"$UNREAD\", \"tooltip\": \"$UNREAD unread / $TOTAL total\", \"class\": \"unread\"}"
    else
      echo "{\"text\": \"\", \"tooltip\": \"No new notifications\", \"class\": \"empty\"}"
    fi
    ;;

  list)
    sqlite3 -json "$DB" \
      "SELECT id, datetime(timestamp, 'unixepoch', 'localtime') as time, app_name, summary, body, is_read
       FROM notifications ORDER BY timestamp DESC LIMIT 100;"
    ;;

  read)
    sqlite3 "$DB" "UPDATE notifications SET is_read=1 WHERE id='$2';"
    ;;

  read-all)
    sqlite3 "$DB" "UPDATE notifications SET is_read=1;"
    ;;

  delete)
    sqlite3 "$DB" "DELETE FROM notifications WHERE id='$2';"
    ;;

  clear-read)
    sqlite3 "$DB" "DELETE FROM notifications WHERE is_read=1;"
    ;;

  clear-all)
    sqlite3 "$DB" "DELETE FROM notifications;"
    ;;
esac
