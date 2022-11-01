-- CreateEnum
CREATE TYPE "UserRoles" AS ENUM ('ADMIN', 'DEVELOPER', 'TEAM_LEAD', 'AGILE_COACH');

-- CreateEnum
CREATE TYPE "TeamSyncStatus" AS ENUM ('INCOMPLETE', 'IN_PROGRESS', 'COMPLETED', 'CANCELED');

-- CreateEnum
CREATE TYPE "SyncPackageStatus" AS ENUM ('NOT_SYNCED', 'SYNCED');

-- CreateEnum
CREATE TYPE "SyncItemStatus" AS ENUM ('NOT_SYNCED', 'SYNCED');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "name" TEXT,
    "avatarUrl" TEXT,
    "displayName" TEXT,
    "bio" TEXT,
    "role" "UserRoles" NOT NULL DEFAULT 'DEVELOPER',
    "teamId" TEXT,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Team" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "agileCoachId" TEXT NOT NULL,
    "teamLeadId" TEXT NOT NULL,
    "isSynced" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "Team_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TeamSync" (
    "id" TEXT NOT NULL,
    "teamSyncId" TEXT NOT NULL,
    "status" "TeamSyncStatus" NOT NULL DEFAULT 'INCOMPLETE',

    CONSTRAINT "TeamSync_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SyncPackage" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "syncPackageId" TEXT NOT NULL,
    "creatorId" TEXT NOT NULL,
    "status" "SyncPackageStatus" NOT NULL DEFAULT 'NOT_SYNCED',

    CONSTRAINT "SyncPackage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SyncItem" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "syncItemId" TEXT NOT NULL,
    "creatorId" TEXT NOT NULL,
    "status" "SyncItemStatus" NOT NULL DEFAULT 'NOT_SYNCED',

    CONSTRAINT "SyncItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SyncItemTag" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "SyncItemTag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_SyncItemToSyncItemTag" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Team_name_key" ON "Team"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Team_teamLeadId_key" ON "Team"("teamLeadId");

-- CreateIndex
CREATE UNIQUE INDEX "_SyncItemToSyncItemTag_AB_unique" ON "_SyncItemToSyncItemTag"("A", "B");

-- CreateIndex
CREATE INDEX "_SyncItemToSyncItemTag_B_index" ON "_SyncItemToSyncItemTag"("B");

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Team" ADD CONSTRAINT "Team_agileCoachId_fkey" FOREIGN KEY ("agileCoachId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Team" ADD CONSTRAINT "Team_teamLeadId_fkey" FOREIGN KEY ("teamLeadId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TeamSync" ADD CONSTRAINT "TeamSync_teamSyncId_fkey" FOREIGN KEY ("teamSyncId") REFERENCES "Team"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SyncPackage" ADD CONSTRAINT "SyncPackage_syncPackageId_fkey" FOREIGN KEY ("syncPackageId") REFERENCES "TeamSync"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SyncPackage" ADD CONSTRAINT "SyncPackage_creatorId_fkey" FOREIGN KEY ("creatorId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SyncItem" ADD CONSTRAINT "SyncItem_syncItemId_fkey" FOREIGN KEY ("syncItemId") REFERENCES "SyncPackage"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SyncItem" ADD CONSTRAINT "SyncItem_creatorId_fkey" FOREIGN KEY ("creatorId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_SyncItemToSyncItemTag" ADD CONSTRAINT "_SyncItemToSyncItemTag_A_fkey" FOREIGN KEY ("A") REFERENCES "SyncItem"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_SyncItemToSyncItemTag" ADD CONSTRAINT "_SyncItemToSyncItemTag_B_fkey" FOREIGN KEY ("B") REFERENCES "SyncItemTag"("id") ON DELETE CASCADE ON UPDATE CASCADE;
