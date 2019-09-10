# Build
FROM node:12.8-alpine as build-stage

ARG NODE_ENV
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

# Archive
FROM node:12.8-alpine as archive-stage

ARG NODE_ENV
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app
COPY --from=build-stage /usr/src/app/node_modules node_modules

COPY . .
