ps aux | grep -ie sidekiq | awk '{print $2}' | xargs kill -9
