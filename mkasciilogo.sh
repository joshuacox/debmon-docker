#/bin/sh
# make an ascii art logo from DDD.jpg
jp2a --color --background=dark --chars='  DDeebbmmoonn' -b --height=20 debmon-docker.jpg | tee debmon-docker.txt
echo 'https://github.com/joshuacox/debmon-docker'>> debmon-docker.txt
