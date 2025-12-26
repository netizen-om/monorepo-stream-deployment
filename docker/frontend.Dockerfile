# =========================
# 1️⃣ Builder stage
# =========================
FROM oven/bun:alpine AS builder

WORKDIR /app

ARG DATABASE_URL
ENV DATABASE_URL=$DATABASE_URL

COPY package.json bun.lock turbo.json ./
COPY packages ./packages
COPY packages/db ./packages/db
COPY apps/web ./apps/web

RUN bun install
RUN cd packages/db && bunx prisma migrate dev
RUN bun run build


# =========================
# 2️⃣ Runtime stage (small)
# =========================
FROM oven/bun:alpine

WORKDIR /app

ENV NODE_ENV=production

# Copy ONLY what is needed to run
COPY --from=builder /app/apps/web/.next ./.next
COPY --from=builder /app/apps/web/public ./public
COPY --from=builder /app/apps/web/package.json ./package.json

EXPOSE 3000
CMD ["bun", "run", "start:web"]
