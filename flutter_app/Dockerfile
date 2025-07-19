FROM ubuntu AS builder
RUN apt-get update
RUN apt-get install -y curl git unzip
RUN git clone https://github.com/flutter/flutter.git 
ENV PATH="/flutter/bin:${PATH}"
COPY . /app
WORKDIR /app
RUN flutter clean
RUN dart run build_runner build --delete-conflicting-outputs
RUN flutter build web

FROM nginx
COPY --from=builder /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]