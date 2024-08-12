ARG NODE_VERSION="20.x"
ARG ALPINE_VERSION="3.19"


# Étape 1 : Construction de l'application
FROM node:alpine as builder


# Installer les dépendances nécessaires pour construire des modules natifs
RUN apk add  --update  --no-cache bash python3 make g++


#Créer un utilisateur non privilégié pour la construction
RUN addgroup -S app && adduser -S app -G app

# Passer à cet utilisateur non root
USER app




# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers package.json et package-lock.json pour installer les dépendances
#COPY package*.json ./

COPY --chown=app:app package*.json ./


# Installer les dépendances
RUN npm ci

# Copier le reste des fichiers de l'application pour construire l'application
#COPY . .
#COPY node_modules /app/node_modules

COPY --chown=app:app node_modules /app/node_modules



# Construire l'application (si nécessaire, par exemple pour un build front-end)
# RUN npm run build

# Étape 2 : Créer l'image finale
#FROM builder as app 
FROM node:alpine

#Créer un utilisateur non privilégié pour la construction
RUN addgroup -S app && adduser -S app -G app

# Passer à cet utilisateur non root
USER app


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
