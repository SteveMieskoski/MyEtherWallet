FROM node:10.17.0-stretch

ENV HOME /home
#RUN \
#     wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
#     echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
#     apt-get update && \
#     apt-get install -y google-chrome-stable && \
#     rm -rf /var/lib/apt/lists/*
#RUN apt get install chromium-browser
RUN apt-get update \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 \
#      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*
#RUN apt-get install -yq \
#    gconf-service libasound2 libatk1.0-0 libatk-bridge2.0-0 libc6 libcairo2 libcups2 libdbus-1-3 \
#    libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
#    libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 \
#    libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates \
#    fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget

# Run everything after as non-privileged user.
#USER pptruser
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
