# STAGE 1: Build
FROM node:20-alpine AS builder
WORKDIR /app
# On installe les outils nécessaires pour certains packages natifs si besoin
RUN apk add --no-cache libc6-compat
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# STAGE 2: Runner (Ultra léger)
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# On ne copie que le dossier standalone (pré-compilé avec ses propres node_modules)
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

# On lance directement le serveur node (plus rapide et léger que npm start)
CMD ["node", "server.js"]