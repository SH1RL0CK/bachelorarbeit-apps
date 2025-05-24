FROM gradle:8.14.0 AS builder
COPY --chown=gradle:gradle . /app
WORKDIR /app

RUN gradle wasmJsBrowserDistribution --no-daemon

FROM nginx:alpine
COPY --from=builder /app/composeApp/build/dist/wasmJs/productionExecutable/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]