ps aux | grep -ie bot_telegram | awk '{print $2}' | xargs kill -9
