FROM oven/bun:alpine

WORKDIR /usr/src/app

COPY ./packages ./packages
COPY ./bun.lock ./bun.lock

COPY ./package.json ./package.json
COPY ./turbo.json ./turbo.json

COPY ./apps/backend ./apps/backend

RUN bun install
RUN cd packages/db && bunx prisma generate


EXPOSE 8080

CMD [ "bun", "run", "start:backend" ]