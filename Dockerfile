# STAGE 1: Build Stage
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci  # 'ci' is faster and more reliable than 'install' in pipelines
COPY . .
RUN npm run build

# STAGE 2: Production Dependencies Stage
FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
# Install ONLY production dependencies, skip devDependencies
RUN npm ci --only=production

# STAGE 3: Final Runner Stage
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
# Security: Don't run as root
USER node

# Copy only the compiled build from builder
COPY --from=builder /app/.next ./.next
# Copy production node_modules from deps
COPY --from=deps /app/node_modules ./node_modules
# Copy static files and package.json
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000

CMD ["npm", "start"]