FROM oven/bun:alpine

WORKDIR /usr/src/app

ARG DATABASE_URL

COPY ./packages .
COPY ./bun.lock .

COPY package.json .
COPY ./turbo.json .

COPY ./apps/web .

RUN bun install
RUN bun run db:generate
RUN DATABASE_URL=${DATABASE_URL} bun run build

EXPOSE 3000

CMD [ "bun", "run", "start:web" ]