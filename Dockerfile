FROM node:18

WORKDIR /app
COPY ./app /app

RUN npm init -y
EXPOSE 3000

CMD ["node", "server.js"]
