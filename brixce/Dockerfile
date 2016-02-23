FROM node:5.6
LABEL Description="This image is used to start the Brix Correctness Engine (CE)"

# This should be removed once the log target is configurable. -mjl
RUN mkdir -p /mnt/brix/log

EXPOSE 8090
ENV NODE_ENV=docker
WORKDIR /app
ENTRYPOINT ["node", "ceapp.js"]
