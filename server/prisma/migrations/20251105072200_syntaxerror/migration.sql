/*
  Warnings:

  - Made the column `location` on table `asset` required. This step will fail if there are existing NULL values in that column.
  - Made the column `description` on table `asset` required. This step will fail if there are existing NULL values in that column.
  - Made the column `name` on table `asset` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE `asset` MODIFY `location` VARCHAR(191) NOT NULL,
    MODIFY `description` VARCHAR(191) NOT NULL,
    MODIFY `name` VARCHAR(191) NOT NULL;
