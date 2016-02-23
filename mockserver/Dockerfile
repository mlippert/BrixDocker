FROM node:5.6
LABEL Description="This image is used to start the Mock Endpoint Server, which provides custom responses to endpoints used by the IPS and CE"

EXPOSE 9099
ENV NODE_ENV=docker
WORKDIR /app
ENTRYPOINT ["node", "index.js"]
