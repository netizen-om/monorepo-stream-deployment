FROM oven/bun:alpine

WORKDIR /usr/src/app

ARG DATABASE_URL

COPY ./packages ./packages
COPY ./bun.lock ./bun.lock

COPY ./package.json ./package.json
COPY ./turbo.json ./turbo.json

COPY ./apps/web ./apps/web

RUN bun install
RUN cd packages/db && bunx prisma db push
RUN cd packages/db && bunx prisma generate
RUN DATABASE_URL=${DATABASE_URL} bun run build

EXPOSE 3000

CMD [ "bun", "run", "start:web" ]