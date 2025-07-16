FROM node:22 AS build
WORKDIR /app
COPY . .
RUN npm install && npm run build

FROM node:22
WORKDIR /app
COPY --from=build /app/dist ./dist
RUN npm install -g serve
EXPOSE 4173
CMD ["serve", "-s", "dist"] 