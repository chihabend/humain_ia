FROM node:22
WORKDIR /app
COPY . .
RUN npm install
CMD ["npx", "ts-node", "src/server.ts"] 