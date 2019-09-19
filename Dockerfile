# Test
FROM node:12.8-alpine as test-target
ENV NODE_ENV=development
ENV PATH $PATH:/usr/src/app/node_modules/.bin
ARG npm_install_command=ci

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm $npm_install_command

COPY . .

# Build
FROM test-target as build-target
ENV NODE_ENV=production

RUN npm run build
RUN npm prune --production

# Archive
FROM node:12.8-alpine as archive-target
ENV NODE_ENV=production
ENV PATH $PATH:/usr/src/app/node_modules/.bin

WORKDIR /usr/src/app

COPY --from=build-target /usr/src/app/node_modules node_modules
COPY --from=build-target /usr/src/app/.next .next

CMD ["next", "start"]
