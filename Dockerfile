# Online Tavla - Dockerfile
# TODO: Dalga 18 - A1-18 fazında implement edilecek
FROM node:18-alpine
WORKDIR /app
COPY . .
RUN npm install --production
EXPOSE 3000
CMD ["node", "server.js"]