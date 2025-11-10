/*
  Warnings:

  - Made the column `notes` on table `maintenance` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE `maintenance` MODIFY `notes` VARCHAR(191) NOT NULL;
