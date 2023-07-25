IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;

GO

CREATE TABLE [Checkpoints] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(8) NULL,
    [ProgramName] nvarchar(8) NULL,
    [JclName] nvarchar(8) NULL,
    [PsbName] nvarchar(max) NULL,
    CONSTRAINT [PK_Checkpoints] PRIMARY KEY ([Id])
);

GO

CREATE TABLE [DBD] (
    [Name] nvarchar(8) NOT NULL,
    [XmlData] xml NULL,
    CONSTRAINT [PK_DBD] PRIMARY KEY ([Name])
);

GO

CREATE TABLE [Hosts] (
    [HostName] nvarchar(450) NOT NULL,
    [Listeners] nvarchar(max) NULL,
    [LastUpdate] datetime2 NULL,
    [StartTime] datetime2 NULL,
    [Active] bit NOT NULL,
    CONSTRAINT [PK_Hosts] PRIMARY KEY ([HostName])
);

GO

CREATE TABLE [Logs] (
    [RID] uniqueidentifier NOT NULL,
    [Data] nvarchar(max) NULL,
    [Program] nvarchar(8) NULL,
    [Terminal] nvarchar(8) NULL,
    [LogTime] datetime2 NOT NULL,
    [SessionId] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_Logs] PRIMARY KEY ([RID])
);

GO

CREATE TABLE [MFS] (
    [Name] nvarchar(8) NOT NULL,
    [Dif] xml NULL,
    [Dof] xml NULL,
    [Mid] xml NULL,
    [Mod] xml NULL,
    CONSTRAINT [PK_MFS] PRIMARY KEY ([Name])
);

GO

CREATE TABLE [MfsFormats] (
    [Name] nvarchar(8) NOT NULL,
    [XmlData] xml NULL,
    [IsInput] bit NOT NULL,
    CONSTRAINT [PK_MfsFormats] PRIMARY KEY ([Name])
);

GO

CREATE TABLE [MfsMessages] (
    [Name] nvarchar(8) NOT NULL,
    [IsInput] bit NOT NULL,
    [XmlData] xml NULL,
    CONSTRAINT [PK_MfsMessages] PRIMARY KEY ([Name])
);

GO

CREATE TABLE [Programs] (
    [ProgramName] nvarchar(8) NOT NULL,
    [IsBMP] bit NOT NULL,
    [Language] nvarchar(max) NULL,
    [ShedulingType] int NOT NULL,
    CONSTRAINT [PK_Programs] PRIMARY KEY ([ProgramName])
);

GO

CREATE TABLE [PSB] (
    [Name] nvarchar(8) NOT NULL,
    [XmlData] xml NULL,
    CONSTRAINT [PK_PSB] PRIMARY KEY ([Name])
);

GO

CREATE TABLE [Systems] (
    [Name] nvarchar(8) NOT NULL,
    CONSTRAINT [PK_Systems] PRIMARY KEY ([Name])
);

GO

CREATE TABLE [Terminals] (
    [Name] nvarchar(8) NOT NULL,
    [User] nvarchar(max) NULL,
    [Encoding] nvarchar(max) NULL,
    [Host] nvarchar(max) NULL,
    [Conversation] uniqueidentifier NOT NULL,
    [ConnectionTime] datetime2 NULL,
    CONSTRAINT [PK_Terminals] PRIMARY KEY ([Name])
);

GO

CREATE TABLE [CheckPointMemoryState] (
    [Id] int NOT NULL IDENTITY,
    [MemoryAddress] int NOT NULL,
    [Data] varbinary(max) NULL,
    [CheckpointId] int NOT NULL,
    CONSTRAINT [PK_CheckPointMemoryState] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_CheckPointMemoryState_Checkpoints_CheckpointId] FOREIGN KEY ([CheckpointId]) REFERENCES [Checkpoints] ([Id]) ON DELETE CASCADE
);

GO

CREATE TABLE [CheckPointPcbState] (
    [Id] int NOT NULL IDENTITY,
    [PcbIndex] int NOT NULL,
    [Rsa] int NOT NULL,
    [KeyFeedbackArea] nvarchar(max) NULL,
    [RawData] varbinary(max) NULL,
    [CheckpointId] int NOT NULL,
    CONSTRAINT [PK_CheckPointPcbState] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_CheckPointPcbState_Checkpoints_CheckpointId] FOREIGN KEY ([CheckpointId]) REFERENCES [Checkpoints] ([Id]) ON DELETE CASCADE
);

GO

CREATE TABLE [Regions] (
    [Name] nvarchar(8) NOT NULL,
    [SystemName] nvarchar(8) NULL,
    [MaxThreads] int NOT NULL,
    [Enabled] bit NOT NULL,
    [LocalEncoding] nvarchar(max) NULL,
    [TerminalEncoding] nvarchar(max) NULL,
    [TMConnectionString] nvarchar(max) NULL,
    CONSTRAINT [PK_Regions] PRIMARY KEY ([Name]),
    CONSTRAINT [FK_Regions_Systems_SystemName] FOREIGN KEY ([SystemName]) REFERENCES [Systems] ([Name]) ON DELETE NO ACTION
);

GO

CREATE TABLE [TransactionMappings] (
    [RegionId] nvarchar(8) NOT NULL,
    [TransactionCode] nvarchar(8) NOT NULL,
    [ExecutableName] nvarchar(max) NULL,
    [PsbName] nvarchar(max) NULL,
    CONSTRAINT [PK_TransactionMappings] PRIMARY KEY ([RegionId], [TransactionCode]),
    CONSTRAINT [FK_TransactionMappings_Regions_RegionId] FOREIGN KEY ([RegionId]) REFERENCES [Regions] ([Name]) ON DELETE CASCADE
);

GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Name') AND [object_id] = OBJECT_ID(N'[Systems]'))
    SET IDENTITY_INSERT [Systems] ON;
INSERT INTO [Systems] ([Name])
VALUES (N'DEFAULT');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Name') AND [object_id] = OBJECT_ID(N'[Systems]'))
    SET IDENTITY_INSERT [Systems] OFF;

GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Name', N'Enabled', N'LocalEncoding', N'MaxThreads', N'SystemName', N'TMConnectionString', N'TerminalEncoding') AND [object_id] = OBJECT_ID(N'[Regions]'))
    SET IDENTITY_INSERT [Regions] ON;
INSERT INTO [Regions] ([Name], [Enabled], [LocalEncoding], [MaxThreads], [SystemName], [TMConnectionString], [TerminalEncoding])
VALUES (N'$CONTROL', CAST(1 AS bit), N'ibm037', 0, N'DEFAULT', NULL, N'ibm037');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Name', N'Enabled', N'LocalEncoding', N'MaxThreads', N'SystemName', N'TMConnectionString', N'TerminalEncoding') AND [object_id] = OBJECT_ID(N'[Regions]'))
    SET IDENTITY_INSERT [Regions] OFF;

GO

CREATE INDEX [IX_CheckPointMemoryState_CheckpointId] ON [CheckPointMemoryState] ([CheckpointId]);

GO

CREATE INDEX [IX_CheckPointPcbState_CheckpointId] ON [CheckPointPcbState] ([CheckpointId]);

GO

CREATE INDEX [IX_Regions_SystemName] ON [Regions] ([SystemName]);

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20201107113811_InitialCreate', N'3.1.32');

GO

CREATE VIEW [dbo].[DbdsView] AS
SELECT [Name], segm.ref.value('(NAME/text())[1]', 'nvarchar(50)')   as SegmentName,
    segm.ref.value('(PARENT/@ParentName)[1]', 'nvarchar(50)')       as ParentName,
    field.ref.value('(@NAME)', 'nvarchar(8)')                       as FieldName,
    field.ref.value('(@START)', 'int')                              as FieldOffset,
    field.ref.value('(@BYTES)', 'int')                              as FieldLength,
    field.ref.value('(@TYPE)', 'char(1)')                           as FieldType,
    field.ref.value('(@SEQ)', 'char(1)')                            as FieldSequenceType,
    [XmlData].query('//SEGM')                                       as segments,
    segm.ref.query('.')                                             as SegmentXml,
    field.ref.query('.')                                            as FieldXml,
    HASHBYTES('MD5', CAST(segm.ref.query('.') AS nvarchar(4000)))   as SegmentHash,
    HASHBYTES('MD5', CAST(field.ref.query('.') AS nvarchar(4000)))  as FieldHash
FROM [dbo].[DBD] d
CROSS APPLY d.[XmlData].nodes('//SEGM') segm(ref)
CROSS APPLY segm.ref.nodes('FIELD') field(ref)

GO

CREATE VIEW [dbo].[ServiceQueues] AS
SELECT        svc.name AS service_name, svc.service_id, svc.principal_id, svc.service_queue_id, queue.name AS queue_name, queue.is_ms_shipped
FROM            sys.services AS svc INNER JOIN
                         sys.service_queues AS queue ON queue.object_id = svc.service_queue_id
WHERE        (queue.is_ms_shipped = 0)

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20201107114042_CreateViews', N'3.1.32');

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20201107114519_EnableQueues', N'3.1.32');

GO

DECLARE @var0 sysname;
SELECT @var0 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Programs]') AND [c].[name] = N'Language');
IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [Programs] DROP CONSTRAINT [' + @var0 + '];');
ALTER TABLE [Programs] ALTER COLUMN [Language] nvarchar(max) NOT NULL;

GO


ALTER VIEW [dbo].[DbdsView] AS
SELECT [Name],
dbd.ref.value('(ACCESS/@Method)[1]', 'nvarchar(8)') as Method,
dbd.ref.value('(ACCESS/@OSMethod)[1]', 'nvarchar(8)') as OSMethod,
segm.ref.value('(NAME/text())[1]', 'nvarchar(50)') as SegmentName,
segm.ref.value('(PARENT/@ParentName)[1]', 'nvarchar(50)') as ParentName,
field.ref.value('(@NAME)', 'nvarchar(8)') as FieldName,
field.ref.value('(@START)', 'int') as FieldOffset,
field.ref.value('(@BYTES)', 'int') as FieldLength,
field.ref.value('(@TYPE)', 'char(1)') as FieldType,
field.ref.value('(@SEQ)', 'char(1)') as FieldSequenceType,
[XmlData].query('//SEGM') as segments,
segm.ref.query('.') as SegmentXml,
field.ref.query('.') as FieldXml,
HASHBYTES('MD5', CAST(segm.ref.query('.') AS nvarchar(4000))) as SegmentHash,
HASHBYTES('MD5', CAST(field.ref.query('.') AS nvarchar(4000))) as FieldHash
FROM [dbo].[DBD] d
CROSS APPLY d.[XmlData].nodes('/DATASET-DBD') dbd(ref)
CROSS APPLY dbd.ref.nodes('//SEGM') segm(ref)
CROSS APPLY segm.ref.nodes('FIELD') field(ref)

GO

CREATE VIEW [dbo].[LChildsView]
AS
SELECT [Name] as SourceDBD,
segm.ref.value('(NAME/text())[1]', 'nvarchar(50)') as SourceSegment,
field.ref.value('(@DBNAME)', 'nvarchar(8)') as TargetDbd,
field.ref.value('(@SEGNAME)', 'nvarchar(8)') as TargetSegment

FROM [dbo].[DBD] d
CROSS APPLY d.[XmlData].nodes('//SEGM') segm(ref)
CROSS APPLY segm.ref.nodes('LCHILD') field(ref)

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20211102073903_ModifyDbdViews', N'3.1.32');

GO

ALTER VIEW [dbo].[LChildsView]
            AS
            SELECT [Name] as SourceDBD,
            segm.ref.value('(NAME/text())[1]', 'nvarchar(50)') as SourceSegment,
            field.ref.value('(@DBNAME)', 'nvarchar(8)') as TargetDbd,
            field.ref.value('(@SEGNAME)', 'nvarchar(50)') as TargetSegment,
            dbd.ref.value('(ACCESS/@Method)[1]', 'nvarchar(8)') as Method,
            dbd.ref.value('(ACCESS/@OSMethod)[1]', 'nvarchar(8)') as OSMethod,
            field.ref.value('(@POINTER)', 'nvarchar(8)') as ConnectionType

            FROM [dbo].[DBD] d
            CROSS APPLY d.[XmlData].nodes('/DATASET-DBD') dbd(ref)
            CROSS APPLY d.[XmlData].nodes('//SEGM') segm(ref)
            CROSS APPLY segm.ref.nodes('LCHILD') field(ref)

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20211116142529_ModifyLchildsView', N'3.1.32');

GO

ALTER VIEW [dbo].[DbdsView] AS
            SELECT [Name],
            dbd.ref.value('(ACCESS/@Method)[1]', 'nvarchar(8)') as Method,
            dbd.ref.value('(ACCESS/@OSMethod)[1]', 'nvarchar(8)') as OSMethod,
            segm.ref.value('(NAME/text())[1]', 'nvarchar(50)') as SegmentName,
            segm.ref.value('(PARENT/@ParentName)[1]', 'nvarchar(50)') as ParentName,
            field.ref.value('(@NAME)', 'nvarchar(8)') as FieldName,
            field.ref.value('(@START)', 'int') as FieldOffset,
            field.ref.value('(@BYTES)', 'int') as FieldLength,
            field.ref.value('(@TYPE)', 'char(1)') as FieldType,
            field.ref.value('(@SEQ)', 'char(1)') as FieldSequenceType,
            [XmlData].query('//SEGM') as segments,
            segm.ref.query('.') as SegmentXml,
            field.ref.query('.') as FieldXml,
            HASHBYTES('MD5', CAST(segm.ref.query('.') AS nvarchar(4000))) as SegmentHash,
            HASHBYTES('MD5', CAST(field.ref.query('.') AS nvarchar(4000))) as FieldHash
            FROM [dbo].[DBD] d
            CROSS APPLY d.[XmlData].nodes('/*') dbd(ref)
            CROSS APPLY dbd.ref.nodes('//SEGM') segm(ref)
            CROSS APPLY segm.ref.nodes('FIELD') field(ref)

GO

ALTER VIEW [dbo].[LChildsView] AS
            SELECT [Name] as SourceDBD,
            segm.ref.value('(NAME/text())[1]', 'nvarchar(50)') as SourceSegment,
            field.ref.value('(@DBNAME)', 'nvarchar(8)') as TargetDbd,
            field.ref.value('(@SEGNAME)', 'nvarchar(50)') as TargetSegment,
            dbd.ref.value('(ACCESS/@Method)[1]', 'nvarchar(8)') as Method,
            dbd.ref.value('(ACCESS/@OSMethod)[1]', 'nvarchar(8)') as OSMethod,
            field.ref.value('(@POINTER)', 'nvarchar(8)') as ConnectionType
            FROM [dbo].[DBD] d
            CROSS APPLY d.[XmlData].nodes('/*') dbd(ref)
            CROSS APPLY d.[XmlData].nodes('//SEGM') segm(ref)
            CROSS APPLY segm.ref.nodes('LCHILD') field(ref)

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20211215121634_ModifyViews', N'3.1.32');

GO

CREATE TABLE [Segment] (
    [DbdName] nvarchar(8) NOT NULL,
    [SegmentName] nvarchar(8) NOT NULL,
    [Copybook] nvarchar(max) NULL,
    CONSTRAINT [PK_Segment] PRIMARY KEY ([DbdName], [SegmentName])
);

GO

ALTER VIEW [dbo].[DbdsView] AS
                SELECT [Name],
                dbd.ref.value('(ACCESS/@Method)[1]', 'nvarchar(8)') as Method,
                dbd.ref.value('(ACCESS/@OSMethod)[1]', 'nvarchar(8)') as OSMethod,
                segm.ref.value('(NAME/text())[1]', 'nvarchar(50)') as SegmentName,
                segm.ref.value('(PARENT/@ParentName)[1]', 'nvarchar(50)') as ParentName,
                segm.ref.value('(BYTES/@Max)[1]', 'nvarchar(50)') as SegmentBytes,
                segm.ref.value('let $n := . return count(../SEGM[. << $n])+1', 'int') as SegmentNum,
                field.ref.value('(@NAME)', 'nvarchar(8)') as FieldName,
                field.ref.value('(@START)', 'int') as FieldOffset,
                field.ref.value('(@BYTES)', 'int') as FieldLength,
                field.ref.value('(@TYPE)', 'char(1)') as FieldType,
                field.ref.value('(@SEQ)', 'char(1)') as FieldSequenceType,
                [XmlData].query('//SEGM') as segments,
                segm.ref.query('.') as SegmentXml,
                field.ref.query('.') as FieldXml,
                HASHBYTES('MD5', CAST(segm.ref.query('.') AS nvarchar(4000))) as SegmentHash,
                HASHBYTES('MD5', CAST(field.ref.query('.') AS nvarchar(4000))) as FieldHash
                FROM [dbo].[DBD] d
                CROSS APPLY d.[XmlData].nodes('/*') dbd(ref)
                CROSS APPLY dbd.ref.nodes('//SEGM') segm(ref)
                CROSS APPLY segm.ref.nodes('FIELD') field(ref)

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20220223125329_ModifyDbdsViewCreateSegmentTable', N'3.1.32');

GO

ALTER VIEW [dbo].[DbdsView] AS
                SELECT [Name],
                dbd.ref.value('(ACCESS/@Method)[1]', 'nvarchar(8)') as Method,
                dbd.ref.value('(ACCESS/@OSMethod)[1]', 'nvarchar(8)') as OSMethod,
                segm.ref.value('(NAME/text())[1]', 'nvarchar(50)') as SegmentName,
                segm.ref.value('(PARENT/@ParentName)[1]', 'nvarchar(50)') as ParentName,
                segm.ref.value('(BYTES/@Max)[1]', 'nvarchar(50)') as SegmentBytes,
                segm.ref.value('let $n := . return count(../SEGM[. << $n])+1', 'int') as SegmentNum,
                field.ref.value('(@NAME)', 'nvarchar(8)') as FieldName,
                field.ref.value('(@START)', 'int') as FieldOffset,
                field.ref.value('(@BYTES)', 'int') as FieldLength,
                field.ref.value('(@TYPE)', 'char(1)') as FieldType,
                field.ref.value('(@SEQ)', 'char(1)') as FieldSequenceType,
                [XmlData].query('//SEGM') as segments,
                segm.ref.query('.') as SegmentXml,
                field.ref.query('.') as FieldXml,
                HASHBYTES('MD5', CAST(segm.ref.query('.') AS nvarchar(4000))) as SegmentHash,
                HASHBYTES('MD5', CAST(field.ref.query('.') AS nvarchar(4000))) as FieldHash
                FROM [dbo].[DBD] d
                CROSS APPLY d.[XmlData].nodes('/*') dbd(ref)
                CROSS APPLY dbd.ref.nodes('//SEGM') segm(ref)
                OUTER APPLY segm.ref.nodes('FIELD') field(ref)

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20220817150224_FixDdbsViewForSegmentsOptionalFileds', N'3.1.32');

GO

ALTER TABLE [TransactionMappings] ADD [SpaSize] int NOT NULL DEFAULT 0;

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20220830143029_ModifyMappingsTable', N'3.1.32');

GO

CREATE TABLE [REGION_OPTION] (
    [REGION_NAME] nvarchar(8) NOT NULL,
    [Name] nvarchar(8) NOT NULL,
    [Value] nvarchar(max) NULL,
    CONSTRAINT [PK_REGION_OPTION] PRIMARY KEY ([REGION_NAME], [Name]),
    CONSTRAINT [FK_REGION_OPTION_Regions_REGION_NAME] FOREIGN KEY ([REGION_NAME]) REFERENCES [Regions] ([Name]) ON DELETE CASCADE
);

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230125145338_AddRegionOption', N'3.1.32');

GO


