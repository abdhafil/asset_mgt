-- AlterTable
ALTER TABLE `asset` ADD COLUMN `isActive` BOOLEAN NOT NULL DEFAULT true;

-- AlterTable
ALTER TABLE `category` ADD COLUMN `isActive` BOOLEAN NOT NULL DEFAULT true;

-- AlterTable
ALTER TABLE `maintenance` ADD COLUMN `isActive` BOOLEAN NOT NULL DEFAULT true;
