FROM  runnergo/debian:stable-slim

ADD manage /data/manage/

ADD entrypoint.sh /bin/

ADD wait-for-it.sh  /bin/
 
CMD ["/data/manage/manage","-c","/data/manage/dev.yaml"]

ENTRYPOINT  ["/bin/entrypoint.sh"]
