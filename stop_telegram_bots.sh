ps aux | grep -ie run_telegram_bots | awk '{print $2}' | xargs kill -9
