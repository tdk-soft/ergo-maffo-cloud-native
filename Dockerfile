# STAGE 1: Build
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# STAGE 2: Production Dependencies
FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# STAGE 3: Final Runner
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
# On définit l'utilisateur avant pour la sécurité
USER node

# On copie uniquement le strict nécessaire
COPY --from=builder --chown=node:node /app/package.json ./
COPY --from=builder --chown=node:node /app/.next ./.next
COPY --from=deps --chown=node:node /app/node_modules ./node_modules

# Si vous avez un fichier next.config.js, décommentez la ligne suivante :
# COPY --from=builder --chown=node:node /app/next.config.js ./

EXPOSE 3000

CMD ["npm", "start"]