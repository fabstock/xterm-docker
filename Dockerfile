FROM node:alpine as builder

## Install build toolchain, install node deps and compile native add-ons
RUN apk add --no-cache python3 make g++
COPY package*.json ./

#RUN npm install xtermjs
RUN npm ci


FROM node:alpine as app

## Copy built node modules and binaries without including the toolchain
COPY --from=builder node_modules .



# Utiliser une image de base Node.js
#FROM node:18-alpine

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier package.json et package-lock.json
#COPY package*.json ./

# Installer les dépendances
#RUN npm install

# Copier le reste des fichiers de l'application
#COPY . .

# Exposer le port sur lequel l'application va écouter
EXPOSE 3000

# Démarrer l'application
CMD ["npm", "start"]

