FROM node:20.18.3-alpine3.21
RUN addgroup -S rakhi && adduser -S rakhi -G rakhi
RUN mkdir /opt/backend
RUN chown -R rakhi:rakhi /opt/backend
WORKDIR /opt/backend
COPY *.js .
COPY package.json .
RUN npm install
ENV DB_HOST="mysql"
USER rakhi
CMD ["node", "index.js"]