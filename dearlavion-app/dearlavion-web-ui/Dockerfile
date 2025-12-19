FROM node:20-alpine as build
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install
COPY . .
RUN yarn build --configuration production

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
