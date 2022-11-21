FROM runnergo/debian:stable-slim 

ADD  runner  /data/runner/runner

ADD  entrypoint.sh /bin/

ADD  wait-for-it.sh /bin/
 
CMD ["/data/runner/runner","-c","/data/runner/dev.yaml"]

ENTRYPOINT  ["/bin/entrypoint.sh"]
