FROM node:10.17.0-stretch

ENV HOME /home
RUN \
     wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
     echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
     apt-get update && \
     apt-get install -y google-chrome-stable && \
     rm -rf /var/lib/apt/lists/*
ENV NODE_OPTIONS --max-old-space-size=6144
RUN npm install npm@6.14 -g
RUN node -v && npm -v
COPY package*.json ./
COPY package-audit.js ./
RUN  node package-audit.js
RUN rm package-audit.js
RUN rm -rf package*.json*
WORKDIR /home

EXPOSE 8080
