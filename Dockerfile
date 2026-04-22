# STAGE 1: Build
FROM node:20-alpine AS builder
WORKDIR /app

# Install libc6-compat to handle shared library dependencies for certain native modules
RUN apk add --no-cache libc6-compat

COPY package*.json ./
RUN npm ci

# Copy the rest of the application code
COPY . .
RUN npm run build

# STAGE 2: Runner (Optimized for production)
FROM node:20-alpine AS runner
WORKDIR /app

# Set environment variables for production
ENV NODE_ENV=production
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

# Create a non-privileged user for security
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy the public folder for static assets (logos, icons, etc.)
# Note: Ensure the 'public' folder exists in your project root
COPY --from=builder /app/public ./public

# Copy the standalone build and static files
# Next.js standalone mode only includes the code needed for production
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

# Start the application using node directly instead of npm for better performance
CMD ["node", "server.js"]