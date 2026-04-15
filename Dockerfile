# STAGE 1: Build Stage
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# STAGE 2: Production Dependencies Stage
FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# STAGE 3: Final Runner Stage
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
USER node

# 1. Copy the build output
COPY --from=builder /app/.next ./.next
# 2. Copy production dependencies
COPY --from=deps /app/node_modules ./node_modules
# 3. Copy configuration and manifest files
COPY --from=builder /app/package.json ./package.json
# Next.js often needs the config file to run correctly
COPY --from=builder /app/next.config* ./ 2>/dev/null || true
# 4. Copy public folder ONLY if it exists (using a wildcard trick)
COPY --from=builder /app/public* ./public/
# If your app uses 'static' output, uncomment the line below:
# COPY --from=builder /app/static* ./static/

EXPOSE 3000

CMD ["npm", "start"]