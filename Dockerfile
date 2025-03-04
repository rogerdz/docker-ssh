FROM node:14-alpine AS build

WORKDIR /src
ADD . .

ENV NODE_ENV=production

RUN apk --update add python3 make g++ nodejs \
  && npm install \
  && apk del make gcc g++ python3 \
  && rm -rf /tmp/* /var/cache/apk/* /root/.npm /root/.node-gyp

# make coffee executable
RUN chmod +x ./node_modules/coffee-script/bin/coffee

RUN rm -rf .gitignore .dockerignore package-lock.json

FROM node:14-alpine

COPY --from=build /src /src

# Connect to container with name/id
ENV CONTAINER=

# Shell to use inside the container
ENV CONTAINER_SHELL=bash

# Server key
ENV KEYPATH=./id_rsa

# Server port
ENV PORT=22

# Enable web terminal
ENV HTTP_ENABLED=false

# HTTP Port
ENV HTTP_PORT=8022

EXPOSE 22 8022

WORKDIR /src

CMD ["npm", "start"]
