# three stages will be used:
# `build` stage, `test` stage and `packaging` stage.

# build stage
FROM node:current-alpine as builder
RUN mkdir -p app && chown -R node:node app
WORKDIR app
COPY package*.json ./
USER node
RUN npm install
COPY --chown=node:node . . 

# test stage
FROM builder as test
WORKDIR app
# image build will fail as long as `npm run test` returns a non-zero exit code when failing
RUN npm run test

# package stage
FROM node:current-alpine
COPY --from=builder app app
WORKDIR app
# ensuring that application is running as less-privileged user
USER node
EXPOSE 8080
CMD ["node", "app.js"]
