import { prismaClient } from "@repo/db/client";

Bun.serve({
  port: 8081,
  fetch(req, server) {
    // upgrade the request to a WebSocket
    if (server.upgrade(req)) {
      return; // do not return a Response
    }
    console.log("Websocket App listening on port 8080");
    return new Response("Upgrade failed", { status: 500 });
  },
  websocket: {
    message(ws, message) {
      console.log("Creating USer");

      const createUser = async () => {
        try {
          const user = await prismaClient.user.create({
            data: {
              username: Math.random().toString(),
              password: Math.random().toString(),
            },
          });
          console.log(user);
        } catch (error) {
          console.log("Error while creating User \n", error);
        }
      };

      createUser();

      ws.send(message);
    },
  },
});
