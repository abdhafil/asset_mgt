/*
  Warnings:

  - A unique constraint covering the columns `[categoryId]` on the table `Category` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `categoryId` to the `Category` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `category` ADD COLUMN `categoryId` INTEGER NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX `Category_categoryId_key` ON `Category`(`categoryId`);

-- AddForeignKey
ALTER TABLE `Category` ADD CONSTRAINT `Category_categoryId_fkey` FOREIGN KEY (`categoryId`) REFERENCES `Asset`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- RenameIndex
ALTER TABLE `category` RENAME INDEX `category_name_key` TO `Category_name_key`;
