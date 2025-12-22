import Fastify from "fastify";

const app = Fastify();

app.get("/health", async () => {
  return { status: "ok" };
});

const port = 3001;

app.listen({ port }, (err) => {
  if (err) {
    app.log.error(err);
    process.exit(1);
  }

  console.log(`API running on http://localhost:${port}`);
});
