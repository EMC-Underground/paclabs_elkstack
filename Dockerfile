FROM docker.elastic.co/elasticsearch/elasticsearch:5.6.2
MAINTAINER Daniel Guerra <daniel.guerra69@gmail.com>

RUN bin/elasticsearch-plugin install x-pack --batch

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["elasticsearch"]
