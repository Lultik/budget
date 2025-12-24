/*
  Warnings:

  - You are about to drop the column `name` on the `User` table. All the data in the column will be lost.
  - Added the required column `updatedAt` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- DropIndex
DROP INDEX "User_email_key";

-- AlterTable
ALTER TABLE "User" DROP COLUMN "name",
ADD COLUMN     "avatarUrl" TEXT,
ADD COLUMN     "firstName" TEXT,
ADD COLUMN     "fullName" TEXT,
ADD COLUMN     "lastName" TEXT,
ADD COLUMN     "locale" TEXT,
ADD COLUMN     "updatedAt" TIMESTAMP(3),
ALTER COLUMN "email" DROP NOT NULL;

UPDATE "User"
SET "updatedAt" = NOW()
WHERE "updatedAt" IS NULL;

ALTER TABLE "User"
ALTER COLUMN "updatedAt" SET NOT NULL;

-- CreateTable
CREATE TABLE "AuthIdentity" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "identifier" TEXT NOT NULL,
    "secret" TEXT,
    "profile" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AuthIdentity_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "AuthIdentity_userId_idx" ON "AuthIdentity"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "AuthIdentity_provider_identifier_key" ON "AuthIdentity"("provider", "identifier");

-- AddForeignKey
ALTER TABLE "AuthIdentity" ADD CONSTRAINT "AuthIdentity_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
