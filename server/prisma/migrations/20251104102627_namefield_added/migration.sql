/*
  Warnings:

  - Added the required column `name` to the `Asset` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `asset` ADD COLUMN `name` INTEGER NOT NULL;
