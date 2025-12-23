import { prisma } from "../src/db";

const DEFAULT_USERS = [
  {
    name: "Tim Apple",
    email: "tim@apple.com",
  },
];

async function main() {
  for (const user of DEFAULT_USERS) {
    await prisma.user.upsert({
      where: { email: user.email },
      update: user,
      create: user,
    });
  }
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
