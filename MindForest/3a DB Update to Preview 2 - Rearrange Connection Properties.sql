/*
   Sonntag, 06. April 201415:24:37
   User: 
   Server: (LocalDB)\v11.0
   Database: C:\DATEN\PROJEKTE\MINDFOREST\SOURCE\MINDFOREST\MINDFOREST\APP_DATA\MUTMACHEREI.MDF
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE Mind.Connections
	DROP CONSTRAINT FK_Mind_Connections_FromNode
GO
ALTER TABLE Mind.Connections
	DROP CONSTRAINT FK_Mind_Connections_ToNode
GO
ALTER TABLE Mind.Nodes SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE Mind.Connections
	DROP CONSTRAINT DF_Mind_Connections_CreatedAt
GO
ALTER TABLE Mind.Connections
	DROP CONSTRAINT DF_Mind_Connections_CreatedBy
GO
ALTER TABLE Mind.Connections
	DROP CONSTRAINT DF_Mind_Connections_ModifiedAt
GO
ALTER TABLE Mind.Connections
	DROP CONSTRAINT DF_Mind_Connections_ModifiedBy
GO
CREATE TABLE Mind.Tmp_Connections
	(
	Id bigint NOT NULL IDENTITY (1, 1),
	FromId bigint NOT NULL,
	ToId bigint NOT NULL,
	Position int NOT NULL,
	IsVisible bit NULL,
	IsExpanded bit NULL,
	Class varchar(200) NULL,
	Style varchar(1000) NULL,
	Color varchar(10) NULL,
	Width varchar(10) NULL,
	Hook nvarchar(MAX) NULL,
	CreatedAt datetime2(3) NOT NULL,
	CreatedBy sysname NOT NULL,
	ModifiedAt datetime2(3) NOT NULL,
	ModifiedBy sysname NOT NULL,
	ForeignId varchar(40) NULL,
	ForeignOrigin nvarchar(200) NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE Mind.Tmp_Connections SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE Mind.Tmp_Connections ADD CONSTRAINT
	DF_Mind_Connections_CreatedAt DEFAULT (sysdatetime()) FOR CreatedAt
GO
ALTER TABLE Mind.Tmp_Connections ADD CONSTRAINT
	DF_Mind_Connections_CreatedBy DEFAULT (suser_sname()) FOR CreatedBy
GO
ALTER TABLE Mind.Tmp_Connections ADD CONSTRAINT
	DF_Mind_Connections_ModifiedAt DEFAULT (sysdatetime()) FOR ModifiedAt
GO
ALTER TABLE Mind.Tmp_Connections ADD CONSTRAINT
	DF_Mind_Connections_ModifiedBy DEFAULT (user_id()) FOR ModifiedBy
GO
SET IDENTITY_INSERT Mind.Tmp_Connections ON
GO
IF EXISTS(SELECT * FROM Mind.Connections)
	 EXEC('INSERT INTO Mind.Tmp_Connections (Id, FromId, ToId, Position, IsVisible, IsExpanded, Style, Color, Width, Hook, CreatedAt, CreatedBy, ModifiedAt, ModifiedBy, ForeignId, ForeignOrigin)
		SELECT Id, FromId, ToId, Position, IsVisible, IsExpanded, Style, Color, Width, Hook, CreatedAt, CreatedBy, ModifiedAt, ModifiedBy, ForeignId, ForeignOrigin FROM Mind.Connections WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT Mind.Tmp_Connections OFF
GO
DROP TABLE Mind.Connections
GO
EXECUTE sp_rename N'Mind.Tmp_Connections', N'Connections', 'OBJECT' 
GO
ALTER TABLE Mind.Connections ADD CONSTRAINT
	PK_Connections PRIMARY KEY NONCLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE Mind.Connections ADD CONSTRAINT
	U_Mind_Connections_FromTo UNIQUE CLUSTERED 
	(
	FromId,
	ToId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Mind_Connections_ToFrom ON Mind.Connections
	(
	ToId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE Mind.Connections ADD CONSTRAINT
	FK_Mind_Connections_FromNode FOREIGN KEY
	(
	FromId
	) REFERENCES Mind.Nodes
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE Mind.Connections ADD CONSTRAINT
	FK_Mind_Connections_ToNode FOREIGN KEY
	(
	ToId
	) REFERENCES Mind.Nodes
	(
	Id
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT


/*  Add IDENTITY to Mind.Nodes */
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE Mind.Nodes
	DROP CONSTRAINT DF_Mind_Nodes_IsTreeRoot
GO
ALTER TABLE Mind.Nodes
	DROP CONSTRAINT DF_Mind_Nodes_RestrictAccess
GO
ALTER TABLE Mind.Nodes
	DROP CONSTRAINT DF_Mind_Nodes_CreatedAt
GO
ALTER TABLE Mind.Nodes
	DROP CONSTRAINT DF_Mind_Nodes_CreatedBy
GO
ALTER TABLE Mind.Nodes
	DROP CONSTRAINT DF_Mind_Nodes_ModifiedAt
GO
ALTER TABLE Mind.Nodes
	DROP CONSTRAINT DF_Mind_Nodes_ModifiedBy
GO
CREATE TABLE Mind.Tmp_Nodes
	(
	Id bigint NOT NULL IDENTITY (1, 1),
	Lang varchar(2) NULL,
	UserId int NULL,
	NodeType varchar(10) NULL,
	IsTreeRoot bit NOT NULL,
	TreeSettings xml NULL,
	Icon nvarchar(1000) NULL,
	Class nvarchar(200) NULL,
	Style nvarchar(1000) NULL,
	Color varchar(10) NULL,
	BackColor varchar(10) NULL,
	CloudColor varchar(10) NULL,
	FontName nvarchar(100) NULL,
	FontSize varchar(10) NULL,
	FontWeight varchar(10) NULL,
	FontStyle varchar(10) NULL,
	ReminderAt datetime2(2) NULL,
	Progress tinyint NULL,
	Link nvarchar(1000) NULL,
	LinkTestedAt datetime2(2) NULL,
	LinkStatus smallint NULL,
	MediaStreamId varchar(50) NULL,
	MediaType varchar(50) NULL,
	MediaOffest decimal(7, 2) NULL,
	MediaLength decimal(7, 2) NULL,
	MediaCycle bit NULL,
	Hook nvarchar(MAX) NULL,
	RestrictAccess bit NOT NULL,
	ForeignId varchar(40) NULL,
	ForeignOrigin nvarchar(200) NULL,
	CreatedAt datetime2(3) NOT NULL,
	CreatedBy sysname NOT NULL,
	ModifiedAt datetime2(3) NOT NULL,
	ModifiedBy sysname NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE Mind.Tmp_Nodes SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE Mind.Tmp_Nodes ADD CONSTRAINT
	DF_Mind_Nodes_IsTreeRoot DEFAULT ((0)) FOR IsTreeRoot
GO
ALTER TABLE Mind.Tmp_Nodes ADD CONSTRAINT
	DF_Mind_Nodes_RestrictAccess DEFAULT ((0)) FOR RestrictAccess
GO
ALTER TABLE Mind.Tmp_Nodes ADD CONSTRAINT
	DF_Mind_Nodes_CreatedAt DEFAULT (sysdatetime()) FOR CreatedAt
GO
ALTER TABLE Mind.Tmp_Nodes ADD CONSTRAINT
	DF_Mind_Nodes_CreatedBy DEFAULT (suser_sname()) FOR CreatedBy
GO
ALTER TABLE Mind.Tmp_Nodes ADD CONSTRAINT
	DF_Mind_Nodes_ModifiedAt DEFAULT (sysdatetime()) FOR ModifiedAt
GO
ALTER TABLE Mind.Tmp_Nodes ADD CONSTRAINT
	DF_Mind_Nodes_ModifiedBy DEFAULT (suser_sname()) FOR ModifiedBy
GO
SET IDENTITY_INSERT Mind.Tmp_Nodes ON
GO
IF EXISTS(SELECT * FROM Mind.Nodes)
	 EXEC('INSERT INTO Mind.Tmp_Nodes (Id, Lang, UserId, NodeType, IsTreeRoot, TreeSettings, Icon, Class, Style, Color, BackColor, CloudColor, FontName, FontSize, FontWeight, FontStyle, ReminderAt, Progress, Link, LinkTestedAt, LinkStatus, MediaStreamId, MediaType, MediaOffest, MediaLength, MediaCycle, Hook, RestrictAccess, ForeignId, ForeignOrigin, CreatedAt, CreatedBy, ModifiedAt, ModifiedBy)
		SELECT Id, Lang, UserId, NodeType, IsTreeRoot, TreeSettings, Icon, Class, Style, Color, BackColor, CloudColor, FontName, FontSize, FontWeight, FontStyle, ReminderAt, Progress, Link, LinkTestedAt, LinkStatus, MediaStreamId, MediaType, MediaOffest, MediaLength, MediaCycle, Hook, RestrictAccess, ForeignId, ForeignOrigin, CreatedAt, CreatedBy, ModifiedAt, ModifiedBy FROM Mind.Nodes WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT Mind.Tmp_Nodes OFF
GO
ALTER TABLE Mind.Connections
	DROP CONSTRAINT FK_Mind_Connections_FromNode
GO
ALTER TABLE Mind.Connections
	DROP CONSTRAINT FK_Mind_Connections_ToNode
GO
ALTER TABLE Mind.NodeTexts
	DROP CONSTRAINT FK_Mind_NodeTexts_Nodes
GO
ALTER TABLE Mind.Permissions
	DROP CONSTRAINT FK_Mind_Permission_Node
GO
DROP TABLE Mind.Nodes
GO
EXECUTE sp_rename N'Mind.Tmp_Nodes', N'Nodes', 'OBJECT' 
GO
ALTER TABLE Mind.Nodes ADD CONSTRAINT
	PK_Mind_Nodes PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE Mind.Nodes ADD CONSTRAINT
	CK_Mind_Nodes_Progress CHECK (([Progress] IS NULL OR [Progress]>=(0) AND [Progress]<=(100)))
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE Mind.Permissions ADD CONSTRAINT
	FK_Mind_Permission_Node FOREIGN KEY
	(
	NodeId
	) REFERENCES Mind.Nodes
	(
	Id
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE Mind.Permissions SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE Mind.NodeTexts ADD CONSTRAINT
	FK_Mind_NodeTexts_Nodes FOREIGN KEY
	(
	NodeId
	) REFERENCES Mind.Nodes
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE Mind.NodeTexts SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE Mind.Connections ADD CONSTRAINT
	FK_Mind_Connections_FromNode FOREIGN KEY
	(
	FromId
	) REFERENCES Mind.Nodes
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE Mind.Connections ADD CONSTRAINT
	FK_Mind_Connections_ToNode FOREIGN KEY
	(
	ToId
	) REFERENCES Mind.Nodes
	(
	Id
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE Mind.Connections SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


/*  Add IDENTITY to Web.Membership */
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE Web.Membership
	DROP CONSTRAINT FK_Web_Membership_UserProfile
GO
ALTER TABLE Web.UserProfiles SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE Web.Membership
	DROP CONSTRAINT df_Web_Membership_IsConfirmed
GO
ALTER TABLE Web.Membership
	DROP CONSTRAINT df_Web_Membership_PasswordFailuresSinceLastSuccess
GO
CREATE TABLE Web.Tmp_Membership
	(
	UserId int NOT NULL IDENTITY (1, 1),
	CreateDate datetime NULL,
	ConfirmationToken nvarchar(128) NULL,
	IsConfirmed bit NULL,
	LastPasswordFailureDate datetime NULL,
	PasswordFailuresSinceLastSuccess int NOT NULL,
	Password nvarchar(128) NOT NULL,
	PasswordChangedDate datetime NULL,
	PasswordSalt nvarchar(128) NOT NULL,
	PasswordVerificationToken nvarchar(128) NULL,
	PasswordVerificationTokenExpirationDate datetime NULL
	)  ON [PRIMARY]
GO
ALTER TABLE Web.Tmp_Membership SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE Web.Tmp_Membership ADD CONSTRAINT
	df_Web_Membership_IsConfirmed DEFAULT ((0)) FOR IsConfirmed
GO
ALTER TABLE Web.Tmp_Membership ADD CONSTRAINT
	df_Web_Membership_PasswordFailuresSinceLastSuccess DEFAULT ((0)) FOR PasswordFailuresSinceLastSuccess
GO
SET IDENTITY_INSERT Web.Tmp_Membership ON
GO
IF EXISTS(SELECT * FROM Web.Membership)
	 EXEC('INSERT INTO Web.Tmp_Membership (UserId, CreateDate, ConfirmationToken, IsConfirmed, LastPasswordFailureDate, PasswordFailuresSinceLastSuccess, Password, PasswordChangedDate, PasswordSalt, PasswordVerificationToken, PasswordVerificationTokenExpirationDate)
		SELECT UserId, CreateDate, ConfirmationToken, IsConfirmed, LastPasswordFailureDate, PasswordFailuresSinceLastSuccess, Password, PasswordChangedDate, PasswordSalt, PasswordVerificationToken, PasswordVerificationTokenExpirationDate FROM Web.Membership WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT Web.Tmp_Membership OFF
GO
DROP TABLE Web.Membership
GO
EXECUTE sp_rename N'Web.Tmp_Membership', N'Membership', 'OBJECT' 
GO
ALTER TABLE Web.Membership ADD CONSTRAINT
	pk_Web_Membership PRIMARY KEY CLUSTERED 
	(
	UserId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE Web.Membership ADD CONSTRAINT
	FK_Web_Membership_UserProfile FOREIGN KEY
	(
	UserId
	) REFERENCES Web.UserProfiles
	(
	UserId
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT
