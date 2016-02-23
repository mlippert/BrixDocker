FROM node:5.6
LABEL Description="This image is used to start the BrixServer (IPS)"

EXPOSE 8088
ENV NODE_ENV=docker
WORKDIR /app
ENTRYPOINT ["node", "brixapp.js"]
