FROM node:20-slim

# Install dependencies for sharp compatibility
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    autoconf \
    automake \
    zlib1g-dev \
    libpng-dev \
    nasm \
    bash \
    libvips-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/

COPY package.json package-lock.json* ./

# RUN npm install 
RUN npm install --production

ENV PATH=/opt/node_modules/.bin:$PATH

WORKDIR /opt/app

COPY . .

RUN chown -R node:node /opt/app

USER node

RUN npm run build

EXPOSE 1337

CMD ["npm", "run", "start"]