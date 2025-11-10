/*
  Warnings:

  - Added the required column `maintenance_type` to the `Maintenance` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `maintenance` ADD COLUMN `maintenance_type` VARCHAR(191) NOT NULL;
