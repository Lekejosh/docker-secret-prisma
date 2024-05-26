import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient();
import { faker } from "@faker-js/faker";
async function main() {
  await prisma.user.create({
    data: {
      name: faker.person.firstName(),
      age: 7,
    },
  });
  console.log(`Database has been seeded. 🌱`);
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });
