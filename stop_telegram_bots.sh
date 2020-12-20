ps aux | grep -ie bot_listener | awk '{print $2}' | xargs kill -9
