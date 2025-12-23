import Fastify from "fastify";
import { prisma } from "./db";

const app = Fastify({ logger: true });

app.get("/health", async () => {
  return { status: "ok" };
});

app.get("/families", async () => {
  const families = await prisma.family.findMany({
    include: {
      members: {
        include: {
          user: true,
        },
      },
    },
  });

  return families;
});

const PORT = 3001;

async function start() {
  try {
    await app.listen({ port: PORT, host: "0.0.0.0" });
    console.log(`API running on http://localhost:${PORT}`);
  } catch (err) {
    app.log.error(err);
    process.exit(1);
  }
}

start();
