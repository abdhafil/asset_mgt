/*
  Warnings:

  - You are about to drop the column `image` on the `Asset` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE `Asset` DROP COLUMN `image`,
    ADD COLUMN `imageUrl` VARCHAR(191) NULL;
