﻿/*
Deployment script for MtelligentDB

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "MtelligentDB"
:setvar DefaultFilePrefix "MtelligentDB"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Creating [dbo].[ExperimentGoals]...';


GO
CREATE TABLE [dbo].[ExperimentGoals] (
    [Id]           INT IDENTITY (1, 1) NOT NULL,
    [ExperimentId] INT NOT NULL,
    [GoalId]       INT NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating FK_ExperimentGoals_ToExperiments...';


GO
ALTER TABLE [dbo].[ExperimentGoals] WITH NOCHECK
    ADD CONSTRAINT [FK_ExperimentGoals_ToExperiments] FOREIGN KEY ([ExperimentId]) REFERENCES [dbo].[Experiments] ([Id]);


GO
PRINT N'Creating FK_ExperimentGoals_ToGoals...';


GO
ALTER TABLE [dbo].[ExperimentGoals] WITH NOCHECK
    ADD CONSTRAINT [FK_ExperimentGoals_ToGoals] FOREIGN KEY ([GoalId]) REFERENCES [dbo].[Goals] ([Id]);


GO
Select * from Cohorts where Type = 'Mtelligent.Entities.Cohorts.AllUsersCohort, Mtelligent.Entities';

if (@@ROWCOUNT = 0)
begin

Insert into Cohorts (Name, SystemName, Type, Created, CreatedBy) Values ('All Users', 'All users', 'Mtelligent.Entities.Cohorts.AllUsersCohort, Mtelligent.Entities', getDate(), 'System')

end

Select * from Cohorts where Type = 'Mtelligent.Entities.Cohorts.AuthenticatedUsersCohort, Mtelligent.Entities';

if (@@ROWCOUNT = 0)
begin

Insert into Cohorts (Name, SystemName, Type, Created, CreatedBy) Values ('Authenticated Users', 'Authenticated users', 'Mtelligent.Entities.Cohorts.AuthenticatedUsersCohort, Mtelligent.Entities', getDate(), 'System')

end

GO

GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[ExperimentGoals] WITH CHECK CHECK CONSTRAINT [FK_ExperimentGoals_ToExperiments];

ALTER TABLE [dbo].[ExperimentGoals] WITH CHECK CHECK CONSTRAINT [FK_ExperimentGoals_ToGoals];


GO
PRINT N'Update complete.';


GO
