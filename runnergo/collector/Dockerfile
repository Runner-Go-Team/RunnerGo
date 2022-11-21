FROM runnergo/debian:stable-slim 

ADD  collector  /data/collector/collector

ADD  entrypoint.sh /bin/

ADD  wait-for-it.sh /bin/
 
CMD ["/data/collector/collector","-c","/data/collector/dev.yaml"]

ENTRYPOINT  ["/bin/entrypoint.sh"]
