# Test
FROM node:12.8-alpine as test-stage
ENV NODE_ENV=development

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .

# Build
FROM test-stage as build-stage
ENV NODE_ENV=production

RUN npm run build
RUN npm prune --production

# Archive
FROM node:12.8-alpine as archive-stage
ENV NODE_ENV=production

WORKDIR /usr/src/app

COPY --from=build-stage /usr/src/app/package.json package.json
COPY --from=build-stage /usr/src/app/node_modules node_modules
COPY --from=build-stage /usr/src/app/.next .next
