# Étape 1 : Construction de l'application
FROM node:alpine as builder

# Installer les dépendances nécessaires pour construire des modules natifs
RUN apk add --no-cache python3 make g++

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers package.json et package-lock.json pour installer les dépendances
COPY package*.json ./

# Installer les dépendances
RUN npm ci

# Copier le reste des fichiers de l'application pour construire l'application
#COPY . .
COPY node_modules /app/node_modules

# Construire l'application (si nécessaire, par exemple pour un build front-end)
# RUN npm run build

# Étape 2 : Créer l'image finale
#FROM builder as app 
FROM node:alpine

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers nécessaires depuis l'étape de construction
COPY --from=builder /app .

RUN pwd
RUN ls -altr


COPY server.js . 
COPY index.html .


# Exposer le port sur lequel l'application va écouter
EXPOSE 3000

# Démarrer l'application
CMD ["npm", "start"]
