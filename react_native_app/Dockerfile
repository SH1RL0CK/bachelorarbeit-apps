FROM node:24-alpine AS build
WORKDIR /app
RUN npm install -g pnpm
COPY package*.json .
RUN pnpm i
COPY . .
RUN npx expo export --platform web

FROM nginx
COPY --from=build /app/dist/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]