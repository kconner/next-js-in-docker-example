FROM node:12.8-alpine

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
