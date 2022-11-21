FROM node:16.17.0

ADD  file-server.tar.gz /app/

WORKDIR /app/file-server

RUN  npm config set registry https://registry.npm.taobao.org &&  npm install 

VOLUME  /app/file-server/file

CMD node app.js
