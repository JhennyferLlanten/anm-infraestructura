FROM node:18-alpine
WORKDIR /app
RUN npm init -y && npm install pg
COPY server.js .
COPY html/ ./html/
EXPOSE 3001
CMD ["node", "server.js"]
