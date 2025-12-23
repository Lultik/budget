import { prisma } from "../src/db";

async function main() {
  const user = await prisma.user.upsert({
    where: { email: "owner@example.com" },
    update: {},
    create: {
      email: "owner@example.com",
      name: "Owner",
      families: {
        create: {
          role: "OWNER",
          family: {
            create: {
              name: "My Family",
            },
          },
        },
      },
    },
  });

  console.log({ user });
}

main()
  .catch(console.error)
  .finally(() => prisma.$disconnect());
