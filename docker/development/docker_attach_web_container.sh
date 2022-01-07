docker attach $(echo $(docker ps -aqf "name=development_web") | grep -o "^.* ")
