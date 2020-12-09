ps aux | grep -ie rsm | awk '{print $2}' | xargs kill -9
