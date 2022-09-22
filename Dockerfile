FROM ubuntu:20.04
COPY redis.conf /
RUN \
  apt-get update && \
  apt-get install -y sudo redis && \
  sudo cp /redis.conf /etc/redis/
#COPY redis.conf /
CMD [ "redis-server", "/etc/redis/redis.conf" ]
#CMD [ "sleep", "600" ]
