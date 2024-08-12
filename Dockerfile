#ARG ALPINE_VERSION="3.18"
#ARG NODE_VERSION=""
#ARG NODE_VERSION="20.x"
#ARG ALPINE_VERSION=""

# Étape 1 : Construction de l'application
#FROM node:${NODE_VERSION}-alpine${ALPINE_VERSION} as builder
FROM node:alpine as builder

# Installer les dépendances nécessaires pour construire des modules natifs
RUN apk add --update --no-cache bash python3 make g++

# Créer un utilisateur non privilégié pour la construction
RUN addgroup -S app && adduser -S app -G app

# Créer le répertoire de l'application et donner les droits à l'utilisateur
RUN mkdir /app && chown -R app:app /app

# Passer à cet utilisateur non root
USER app

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers package.json et package-lock.json pour installer les dépendances
COPY --chown=app:app package*.json ./

# Installer les dépendances
RUN npm ci
RUN id && ls -altr && pwd   && env

# Copier le reste des fichiers de l'application pour construire l'application
#COPY --chown=app:app . .

# Étape 2 : Créer l'image finale
#FROM node:${NODE_VERSION}-alpine${ALPINE_VERSION}
FROM node:alpine

# Créer un utilisateur non privilégié pour l'exécution de l'application
RUN addgroup -S app && adduser -S app -G app

# Passer à cet utilisateur non root
USER app

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers nécessaires depuis l'étape de construction
COPY --from=builder /app /app
RUN id && ls -altr && pwd   && env


# Copier les fichiers supplémentaires
COPY --chown=app:app server.js .
COPY --chown=app:app index.html .

# Exposer le port sur lequel l'application va écouter
EXPOSE 3000

# Démarrer l'application
CMD ["npm", "start"]

