/*
  Warnings:

  - You are about to alter the column `password` on the `User` table. The data in that column could be lost. The data in that column will be cast from `Text` to `VarChar(256)`.
  - Added the required column `name` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "TypeCategory" AS ENUM ('letter', 'asset');

-- CreateEnum
CREATE TYPE "ConditionAsset" AS ENUM ('good', 'maintenance', 'broken');

-- CreateEnum
CREATE TYPE "PriorityTicket" AS ENUM ('low', 'normal', 'critical');

-- CreateEnum
CREATE TYPE "StatusTicket" AS ENUM ('pending', 'progress', 'done');

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "name" VARCHAR(256) NOT NULL,
ALTER COLUMN "password" SET DATA TYPE VARCHAR(256);

-- CreateTable
CREATE TABLE "Staff" (
    "id" TEXT NOT NULL,
    "position" VARCHAR(256) NOT NULL,
    "phone" VARCHAR(256) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,

    CONSTRAINT "Staff_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Category" (
    "id" TEXT NOT NULL,
    "title" VARCHAR(256) NOT NULL,
    "description" TEXT,
    "status" BOOLEAN NOT NULL,
    "type" "TypeCategory" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Asset" (
    "id" TEXT NOT NULL,
    "assetCode" TEXT NOT NULL,
    "name" VARCHAR(256) NOT NULL,
    "condition" "ConditionAsset" NOT NULL,
    "usedBy" VARCHAR(256) NOT NULL,
    "fiscalType" VARCHAR(256) NOT NULL,
    "fiscal_year" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "categoryId" TEXT NOT NULL,
    "roomId" TEXT NOT NULL,

    CONSTRAINT "Asset_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Ticket" (
    "id" TEXT NOT NULL,
    "ticketCode" TEXT NOT NULL,
    "title" VARCHAR(256) NOT NULL,
    "description" TEXT NOT NULL,
    "priority" "PriorityTicket" NOT NULL,
    "status" "StatusTicket" NOT NULL DEFAULT 'pending',
    "reporterNIP" VARCHAR(256) NOT NULL,
    "reporterName" VARCHAR(256) NOT NULL,
    "reporterPhone" VARCHAR(256) NOT NULL,
    "feedback" TEXT,
    "openedAt" DATE NOT NULL,
    "closedAt" TIMESTAMP(3),
    "confirmedAt" TIMESTAMPTZ,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "roomId" TEXT NOT NULL,
    "createdBy" TEXT NOT NULL,
    "confirmedBy" TEXT,

    CONSTRAINT "Ticket_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Staff_userId_key" ON "Staff"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Asset_assetCode_key" ON "Asset"("assetCode");

-- CreateIndex
CREATE UNIQUE INDEX "Ticket_ticketCode_key" ON "Ticket"("ticketCode");

-- AddForeignKey
ALTER TABLE "Staff" ADD CONSTRAINT "Staff_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Asset" ADD CONSTRAINT "Asset_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "Category"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Asset" ADD CONSTRAINT "Asset_roomId_fkey" FOREIGN KEY ("roomId") REFERENCES "Room"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ticket" ADD CONSTRAINT "Ticket_roomId_fkey" FOREIGN KEY ("roomId") REFERENCES "Room"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ticket" ADD CONSTRAINT "Ticket_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ticket" ADD CONSTRAINT "Ticket_confirmedBy_fkey" FOREIGN KEY ("confirmedBy") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
