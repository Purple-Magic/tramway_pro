ps aux | grep -ie detective | awk '{print $2}' | xargs kill -9
