# =========================
# 1️⃣ Builder stage
# =========================
FROM oven/bun:alpine AS builder

WORKDIR /app

ARG DATABASE_URL
ENV DATABASE_URL=$DATABASE_URL

COPY package.json bun.lock turbo.json ./
COPY packages ./packages
# COPY packages/db ./packages/db
COPY apps/web ./apps/web

RUN bun install
RUN cd packages/db && bunx prisma migrate dev
RUN bun run build

# =========================
# 2️⃣ Runtime stage
# =========================
FROM node:18-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000

# 1. Copy the standalone output
COPY --from=builder /app/apps/web/.next/standalone ./

# 2. Copy static assets
COPY --from=builder /app/apps/web/.next/static ./apps/web/.next/static
COPY --from=builder /app/apps/web/public ./apps/web/public

RUN rm -rf node_modules && \
    node -e "const pkg=require('./package.json'); delete pkg.dependencies['@repo/db']; require('fs').writeFileSync('package.json', JSON.stringify(pkg, null, 2))" && \
    npm install --omit=dev && \
    npm cache clean --force

EXPOSE 3000

CMD ["node", "server.js"]

# =========================
# 2️⃣ Runtime stage (small)
# =========================
# FROM oven/bun:alpine

# WORKDIR /app

# ENV NODE_ENV=production

# # COPY --from=builder /app/node_modules ./node_modules

# # Copy ONLY what is needed to run
# # COPY --from=builder /app/apps/web/.next ./.next
# # COPY --from=builder /app/apps/web/public ./public
# # COPY --from=builder /app/apps/web/package.json ./package.json

# COPY --from=builder /app/apps/web/.next/standalone ./
# COPY --from=builder /app/apps/web/.next/static ./apps/web/.next/static
# COPY --from=builder /app/apps/web/public ./apps/web/public

# EXPOSE 3000
# # CMD ["bun", "run", "next", "start"]
# CMD ["bun", "server.js"]
