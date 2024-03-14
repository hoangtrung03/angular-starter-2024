# ;-------------;
# ; Build stage ;
# ;-------------;
FROM node:20-alpine as builder

WORKDIR /app

RUN npm install -g yarn

COPY . .

RUN --mount=type=cache,id=yarn-cache,target=/usr/local/share/.cache/yarn/v6 \
    yarn install --frozen-lockfile && \
    yarn build

# ;---------------;
# ; Runtime stage ;
# ;---------------;
FROM nginx:stable-alpine as runtime

COPY --from=builder /app/dist/angular-boilerplate /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
