/****** Object:  Table [dbo].[WQ_REGION]    Script Date: 19/05/2015 12:50:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WQ_REGION](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RE_NAME] [varchar](50) NOT NULL,
	[RE_APPLICATION_CONNECTION_STRING] [varchar](max) NULL,
	[RE_CWASIZE] [int] NOT NULL,
	[RE_SECMGRCFG] [varchar](max) NULL,
	[RE_QUEUE_CONNECTION_STRING] [varchar](max) NULL,
	[RE_CODEPAGE] [int] NOT NULL,
	[RE_STRING_RUNTIME_ENCODING] [varchar](max) NOT NULL,
	[RE_PARALLEL_DESTINATION] [int] NULL,
	[RE_LOGLEVEL] [tinyint] DEFAULT (2) NOT NULL,
	[RE_Status] [tinyint] Default (0) NOT NULL,
 CONSTRAINT [PK_WQ_REGION] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_REGION_NAME] ON [dbo].[WQ_REGION]
(
	[RE_NAME] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[GET_REGION_ID]    Script Date: 09/12/2013 12:50:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER FUNCTION [dbo].[GET_VERSION]()
RETURNS int
AS
BEGIN
	-- Return the result of the function
	RETURN 1

END
GO	

CREATE FUNCTION [dbo].[GET_REGION_ID]
(
	@region_name varchar(50)
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @region_id int

	-- Add the T-SQL statements to compute the return value here
	SELECT @region_id = ID FROM WQ_REGION WHERE WQ_REGION.RE_NAME = @region_name;

	-- Return the result of the function
	RETURN @region_id

END
GO

CREATE FUNCTION [dbo].[GET_QIXMS_TRANSACTION_ID]
(
	@qixmstransaction_name varchar(8)
)
RETURNS int
AS
BEGIN
	DECLARE @qixmstransaction_id int
	SELECT @qixmstransaction_id = ID FROM WQ_QIXMS_TRANSACTION WHERE WQ_QIXMS_TRANSACTION.TRI_NAME = @qixmstransaction_name;
	RETURN @qixmstransaction_id
END
GO

/****** Object:  StoredProcedure [dbo].[GET_CWASIZE]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_CWASIZE] @region_name varchar(50)
AS
BEGIN
   select RE_CWASIZE from WQ_REGION where RE_NAME = @region_name
END
GO
/****** Object:  StoredProcedure [dbo].[GET_SECMGRCFG] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_SECMGRCFG] @region_name varchar(50)
AS
BEGIN
   select RE_SECMGRCFG from WQ_REGION where RE_NAME = @region_name
END
GO
/****** Object:  StoredProcedure [dbo].[GET_TSQUEUES_CONNECTION_STRING]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_TSQUEUES_CONNECTION_STRING] @region_name varchar(50)AS
BEGIN
	SELECT RE_QUEUE_CONNECTION_STRING FROM WQ_REGION WHERE RE_NAME=@region_name;
END
GO
/****** Object:  StoredProcedure [dbo].[ADD_REGION]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ADD_REGION] @region_name varchar(50), @cwa_size int, @codepage int, @connection_string text
AS
BEGIN
	INSERT INTO WQ_REGION(RE_NAME, RE_CWASIZE, RE_APPLICATION_CONNECTION_STRING, RE_CODEPAGE) VALUES(@region_name, @cwa_size, @connection_string, @codepage)
END
GO
/****** Object:  StoredProcedure [dbo].[GET_CODEPAGE]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_CODEPAGE]  @region_name varchar(50)
AS
BEGIN
	SELECT RE_CODEPAGE FROM WQ_REGION WHERE RE_NAME = @region_name
END
GO
/****** Object:  StoredProcedure [dbo].[GET_INITIAL_TRANSACTION]    Script Date: 17/05/2021 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_INITIAL_TRANSACTION]  @region_name varchar(50)
AS
BEGIN
	SELECT RO_VALUE FROM WQ_REGION_OPTIONS as ro JOIN WQ_REGION as r ON ro.RO_FK_REGION = r.ID WHERE r.RE_NAME = @region_name AND ro.RO_NAME = 'InitialTransaction'
END
GO
/****** Object:  StoredProcedure [dbo].[GET_APPLICATION_CONNECTION_STRING]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_APPLICATION_CONNECTION_STRING] @region_name varchar(50)
AS
BEGIN
   select RE_APPLICATION_CONNECTION_STRING from WQ_REGION where RE_NAME = @region_name
END
GO
/****** Object:  Table [dbo].[WQ_PROGRAMS_PATH]    Script Date: 09/12/2013 12:50:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WQ_PROGRAMS_PATH](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PP_FK_REGION] [int] NOT NULL,
	[PP_PATH] [varchar](800) NOT NULL,
 CONSTRAINT [PK_WQ_MODULES_PATHS] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE UNIQUE NONCLUSTERED INDEX [UNIQUE_WQ_PROGRAMS_PATH] ON [dbo].[WQ_PROGRAMS_PATH]
(
	[PP_FK_REGION] ASC,
	[PP_PATH] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WQ_MQ_QUEUE]    Script Date: 01/17/2014 16:09:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WQ_MQ_QUEUE](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[MQ_NAME] [varchar](max) NOT NULL,
	[MQ_TRANSACTION] [varchar](8) NOT NULL,
	[MQ_MODE] [tinyint] NOT NULL,
	[MQ_FK_REGION] [int] NOT NULL,
 CONSTRAINT [PK_WQ_MQ_QUEUE] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[WQ_MAPS_PATH]    Script Date: 09/12/2013 12:50:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WQ_MAPS_PATH](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MP_FK_REGION] [int] NOT NULL,
	[MP_PATH] [varchar](800) NOT NULL,
 CONSTRAINT [PK_WQ_MAPS_PATH] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE UNIQUE NONCLUSTERED INDEX [UNIQUE_WQ_MAPS_PATH] ON [dbo].[WQ_MAPS_PATH]
(
	[MP_FK_REGION] ASC,
	[MP_PATH] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WQ_QIXMS_TRANSACTION]    Script Date: 19/05/2015 12:50:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WQ_QIXMS_TRANSACTION](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TRI_FK_REGION] [int] NOT NULL,
	[TRI_NAME] [varchar](50) NOT NULL,
	[TRI_PROGRAM] [varchar](50) NOT NULL,
	[TRI_CONVERSATIONAL] [bit] NOT NULL,
 CONSTRAINT [PK_WQ_QIXMS_TRANSACTION] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO


-- Creating table 'WQ_USER'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
-- Creating table 'WQ_USER_TRANSACTIONS'
CREATE TABLE [dbo].[WQ_USER_TRANSACTIONS] (
    [ID] int IDENTITY(1,1) NOT NULL,
    [UR_USERID] varchar(8)  NOT NULL,
    [UR_FK_QIXMS_TRANSACTIONID] int  NOT NULL,
);
GO
SET ANSI_PADDING OFF
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

-- Creating table 'WQ_TRANSACTION_SECURITY_OPTIONS'
CREATE TABLE [dbo].[WQ_TRANSACTION_SECURITY_OPTIONS] (
    [TSO_SIGN] bit  NOT NULL,
    [TSO_PASSWORD] varchar(max)  NULL,
    [TSO_KNOWN_USER] bit  NOT NULL,
    [TSO_PK_QIXMS_TRANSACTION] int  NOT NULL
);
GO
SET ANSI_PADDING OFF
GO


-- Creating primary key on [ID] in table 'WQ_USER_TRANSACTIONS'
ALTER TABLE [dbo].[WQ_USER_TRANSACTIONS]
ADD CONSTRAINT [PK_WQ_USER_TRANSACTIONS]
    PRIMARY KEY CLUSTERED ([ID] ASC);
GO


-- Creating primary key on [TSO_PK_QIXMS_TRANSACTION] in table 'WQ_TRANSACTION_SECURITY_OPTIONS'
ALTER TABLE [dbo].[WQ_TRANSACTION_SECURITY_OPTIONS]
ADD CONSTRAINT [PK_WQ_TRANSACTION_SECURITY_OPTIONS]
    PRIMARY KEY CLUSTERED ([TSO_PK_QIXMS_TRANSACTION] ASC);
GO


/****** Object:  Table [dbo].[WQ_FORWARD_TRANSACTION]    Script Date: 09/12/2013 12:50:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WQ_FORWARD_TRANSACTION](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FT_FK_REGION] [int] NOT NULL,
	[FT_TRANSACTION_ID] [varchar](100) NOT NULL,
	[FT_DESTINATION] [varchar](50) NOT NULL,
	[FT_REMOTE_TRANSACTION] [varchar](100) NOT NULL,
 CONSTRAINT [PK_WQ_FORWARD_TRANSACTION] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE UNIQUE NONCLUSTERED INDEX [UNIQUE_WQ_FORWARD_TRANSACTION] ON [dbo].[WQ_FORWARD_TRANSACTION]
(
	[FT_DESTINATION] ASC,
	[FT_FK_REGION] ASC,
	[FT_REMOTE_TRANSACTION] ASC,
	[FT_TRANSACTION_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WQ_FORWARD_DESTINATION]    Script Date: 09/12/2013 12:50:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WQ_FORWARD_DESTINATION](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FD_HOSTID] [varchar](50) NOT NULL,
	[FD_HOSTNAME] [text] NOT NULL,
	[FD_PORT] [int] NOT NULL,
	[FD_FK_REGION] [int] NOT NULL,
 CONSTRAINT [PK_WQ_FORWARD_DESTINATION] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE UNIQUE NONCLUSTERED INDEX [UNIQUE_WQ_FORWARD_DESTINATION] ON [dbo].[WQ_FORWARD_DESTINATION]
(
	[FD_FK_REGION] ASC,
	[FD_HOSTID] ASC,
	[FD_PORT] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WQ_TS]    Script Date: 09/12/2013 12:50:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WQ_TS](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TS_FK_REGION] [int] NOT NULL,
	[TS_CODEPAGE] [int] NOT NULL,
 CONSTRAINT [PK_WQ_TS] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TERMINAL_SERVER_REGION] ON [dbo].[WQ_TS]
(
	[TS_FK_REGION] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WQ_TRANSACTION]    Script Date: 09/12/2013 12:50:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WQ_TRANSACTION](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TR_FK_REGION] [int] NOT NULL,
	[TR_NAME] [varchar](50) NOT NULL,
	[TR_PROGRAM] [varchar](50) NOT NULL,
	[TR_TWASIZE] [int] NOT NULL,
 CONSTRAINT [PK_WQ_TRANSACTION] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TRANSACTION_REGION] ON [dbo].[WQ_TRANSACTION]
(
	[TR_FK_REGION] ASC,
	[TR_NAME] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UNIQUE_WQ_TRANSACTION] ON [dbo].[WQ_TRANSACTION]
(
	[TR_FK_REGION] ASC,
	[TR_NAME] ASC,
	[TR_PROGRAM] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WQ_TD_QUEUE]    Script Date: 09/12/2013 12:50:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WQ_TD_QUEUE](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TD_FK_REGION] [int] NOT NULL,
	[TD_NAME] [varchar](4) NOT NULL,
	[TD_ENABLED] [bit] NOT NULL,
	[TD_MSMQ_HOST] [varchar](50) NOT NULL,
 CONSTRAINT [PK_WQ_TD_QUEUE] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_WQ_TD_QUEUE] ON [dbo].[WQ_TD_QUEUE]
(
	[TD_FK_REGION] ASC,
	[TD_NAME] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UNIQUE_WQ_TD_QUEUE] ON [dbo].[WQ_TD_QUEUE]
(
	[TD_FK_REGION] ASC,
	[TD_NAME] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WQ_SESSION]    Script Date: 09/12/2013 12:50:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WQ_SESSION](
	[ID] [uniqueidentifier] NOT NULL,
	[SE_COMMAREA] [varbinary](max) NULL,
	[SE_USER_INPUT] [varbinary](max) NULL,
	[SE_TRANSACTION] [varchar](4) NULL,
	[SE_FK_REGION] [int] NOT NULL,
 CONSTRAINT [PK_WQ_SESSION] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[WQ_REGION_OPTIONS]    Script Date: 09/12/2013 12:50:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WQ_REGION_OPTIONS](
	[RO_FK_REGION] [int]NOT NULL,
	[RO_NAME] [varchar](80) NOT NULL,
	[RO_VALUE] [varchar](max) NULL,
 CONSTRAINT [PK_WQ_REGION_OPTIONS] PRIMARY KEY CLUSTERED
(
	[RO_FK_REGION] ASC,
	[RO_NAME] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[WQ_VIEW_TRANSACTION]    Script Date: 09/12/2013 12:50:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[WQ_VIEW_TRANSACTION]
AS
SELECT     dbo.WQ_TRANSACTION.TR_FK_REGION, dbo.WQ_TRANSACTION.TR_NAME, dbo.WQ_TRANSACTION.TR_PROGRAM AS PR_NAME, dbo.WQ_REGION.RE_NAME,
                      dbo.WQ_TRANSACTION.TR_TWASIZE
FROM         dbo.WQ_REGION INNER JOIN
                      dbo.WQ_TRANSACTION ON dbo.WQ_REGION.ID = dbo.WQ_TRANSACTION.TR_FK_REGION
GO
/****** Object:  View [dbo].[WQ_VIEW_TERMINALSERVER]    Script Date: 09/12/2013 12:50:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[WQ_VIEW_TERMINALSERVER]
AS
SELECT     dbo.WQ_REGION.RE_NAME AS region_name, dbo.WQ_TS.TS_CODEPAGE
FROM         dbo.WQ_REGION INNER JOIN
                      dbo.WQ_TS ON dbo.WQ_REGION.ID = dbo.WQ_TS.TS_FK_REGION
GO
/****** Object:  View [dbo].[WQ_VIEW_TD_QUEUE]    Script Date: 09/12/2013 12:50:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[WQ_VIEW_TD_QUEUE]
AS
SELECT     dbo.WQ_REGION.RE_NAME, dbo.WQ_TD_QUEUE.TD_MSMQ_HOST, dbo.WQ_TD_QUEUE.TD_NAME, dbo.WQ_TD_QUEUE.TD_ENABLED
FROM         dbo.WQ_REGION INNER JOIN
                      dbo.WQ_TD_QUEUE ON dbo.WQ_REGION.ID = dbo.WQ_TD_QUEUE.TD_FK_REGION
GO
/****** Object:  View [dbo].[WQ_VIEW_SESSION]    Script Date: 09/12/2013 12:50:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[WQ_VIEW_SESSION]
AS
SELECT     SE_COMMAREA, SE_USER_INPUT, ID, SE_TRANSACTION AS TR_NAME
FROM         dbo.WQ_SESSION
GO
/****** Object:  View [dbo].[WQ_VIEW_REGION]    Script Date: 09/12/2013 12:50:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[WQ_VIEW_REGION]
AS
SELECT     dbo.WQ_REGION.RE_NAME, dbo.WQ_FORWARD_DESTINATION.FD_HOSTID, dbo.WQ_FORWARD_DESTINATION.FD_HOSTNAME,
                      dbo.WQ_FORWARD_DESTINATION.FD_PORT, dbo.WQ_REGION.RE_APPLICATION_CONNECTION_STRING, dbo.WQ_REGION.RE_CWASIZE,
                      dbo.WQ_REGION.RE_QUEUE_CONNECTION_STRING, dbo.WQ_REGION.RE_CODEPAGE, dbo.WQ_REGION.RE_PARALLEL_DESTINATION
FROM         dbo.WQ_FORWARD_DESTINATION INNER JOIN
                      dbo.WQ_REGION ON dbo.WQ_FORWARD_DESTINATION.ID = dbo.WQ_REGION.RE_PARALLEL_DESTINATION
GO
/****** Object:  View [dbo].[WQ_VIEW_PROGRAMS_PATH]    Script Date: 09/12/2013 12:50:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[WQ_VIEW_PROGRAMS_PATH]
AS
SELECT     dbo.WQ_PROGRAMS_PATH.ID, dbo.WQ_REGION.RE_NAME, dbo.WQ_PROGRAMS_PATH.PP_PATH
FROM         dbo.WQ_REGION INNER JOIN
                      dbo.WQ_PROGRAMS_PATH ON dbo.WQ_REGION.ID = dbo.WQ_PROGRAMS_PATH.PP_FK_REGION
GO
/****** Object:  View [dbo].[WQ_VIEW_MAPS_PATH]    Script Date: 09/12/2013 12:50:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[WQ_VIEW_MAPS_PATH]
AS
SELECT     dbo.WQ_MAPS_PATH.ID, dbo.WQ_MAPS_PATH.MP_PATH, dbo.WQ_REGION.RE_NAME
FROM         dbo.WQ_MAPS_PATH INNER JOIN
                      dbo.WQ_REGION ON dbo.WQ_MAPS_PATH.MP_FK_REGION = dbo.WQ_REGION.ID
GO
/****** Object:  View [dbo].[WQ_VIEW_QIXMS_TRANSACTION]    Script Date: 09/12/2013 12:50:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[WQ_VIEW_QIXMS_TRANSACTION]
AS
SELECT     dbo.WQ_QIXMS_TRANSACTION.TRI_NAME, dbo.WQ_QIXMS_TRANSACTION.TRI_PROGRAM, dbo.WQ_QIXMS_TRANSACTION.TRI_CONVERSATIONAL,
                      dbo.WQ_REGION.RE_NAME
FROM         dbo.WQ_QIXMS_TRANSACTION INNER JOIN
                      dbo.WQ_REGION ON dbo.WQ_QIXMS_TRANSACTION.TRI_FK_REGION = dbo.WQ_REGION.ID
GO
/****** Object:  View [dbo].[WQ_VIEW_FORWARD_TRANSACTION]    Script Date: 09/12/2013 12:50:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[WQ_VIEW_FORWARD_TRANSACTION]
AS
SELECT     dbo.WQ_REGION.RE_NAME, dbo.WQ_FORWARD_TRANSACTION.FT_TRANSACTION_ID, dbo.WQ_FORWARD_TRANSACTION.FT_DESTINATION,
                      dbo.WQ_FORWARD_TRANSACTION.FT_REMOTE_TRANSACTION
FROM         dbo.WQ_FORWARD_TRANSACTION INNER JOIN
                      dbo.WQ_REGION ON dbo.WQ_FORWARD_TRANSACTION.FT_FK_REGION = dbo.WQ_REGION.ID
GO
/****** Object:  View [dbo].[WQ_VIEW_FORWARD_DESTINATION]    Script Date: 09/12/2013 12:50:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[WQ_VIEW_FORWARD_DESTINATION]
AS
SELECT     dbo.WQ_FORWARD_DESTINATION.FD_PORT, dbo.WQ_FORWARD_DESTINATION.FD_HOSTNAME, dbo.WQ_REGION.RE_NAME,
                      dbo.WQ_FORWARD_DESTINATION.FD_HOSTID
FROM         dbo.WQ_FORWARD_DESTINATION INNER JOIN
                      dbo.WQ_REGION ON dbo.WQ_FORWARD_DESTINATION.FD_FK_REGION = dbo.WQ_REGION.ID
GO
/****** Object:  StoredProcedure [dbo].[UPDATE_TRANSACTION_IN_SESSION]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UPDATE_TRANSACTION_IN_SESSION] @session_id uniqueidentifier, @transaction_name varchar(4)
AS
BEGIN
	UPDATE WQ_SESSION SET SE_TRANSACTION = @transaction_name WHERE ID = @session_id
END
GO
/****** Object:  StoredProcedure [dbo].[UPDATE_COMMAREA]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UPDATE_COMMAREA] @session_id uniqueidentifier, @commarea varbinary(MAX)
AS
BEGIN
	UPDATE WQ_SESSION SET SE_COMMAREA = @commarea WHERE ID = @session_id
END
GO
/****** Object:  StoredProcedure [dbo].[SET_TSQUEUES_CONNECTION_STRING]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SET_TSQUEUES_CONNECTION_STRING] @region_name varchar(50), @connection_string varchar(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.WQ_REGION SET RE_QUEUE_CONNECTION_STRING = @connection_string WHERE ID = dbo.GET_REGION_ID(@region_name)
END
GO
/****** Object:  StoredProcedure [dbo].[SET_PARALLEL_DESTINATION]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SET_PARALLEL_DESTINATION]  @region_name varchar(50), @host_id varchar(50)
AS
BEGIN
	declare @region_id int;
	set @region_id = -1;
	declare @destination_id int;
	set @destination_id = -1;

	select @region_id = id from WQ_REGION where RE_NAME = @region_name;

	if @region_id > 0
	begin
		SELECT @destination_id = ID FROM WQ_FORWARD_DESTINATION WHERE FD_FK_REGION = @region_id AND FD_HOSTID=@host_id;
		UPDATE WQ_REGION SET RE_PARALLEL_DESTINATION = @destination_id WHERE ID=@region_id;
	end
END
GO
/****** Object:  StoredProcedure [dbo].[SET_CWASIZE]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SET_CWASIZE] @region_name varchar(50), @cwasize int
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.WQ_REGION SET RE_CWASIZE = @cwasize WHERE ID = dbo.GET_REGION_ID(@region_name)
END
GO
/****** Object:  StoredProcedure [dbo].[SET_SECMGRCFG]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SET_SECMGRCFG] @region_name varchar(50), @secmgrcfg varchar(max)
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.WQ_REGION SET RE_SECMGRCFG = @secmgrcfg WHERE ID = dbo.GET_REGION_ID(@region_name)
END
GO
/****** Object:  StoredProcedure [dbo].[SET_CODEPAGE]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SET_CODEPAGE] @region_name varchar(50), @codepage int
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE WQ_REGION SET RE_CODEPAGE = @codepage WHERE ID = dbo.GET_REGION_ID(@region_name)
END
GO
/****** Object:  StoredProcedure [dbo].[SET_REGION_OPTION]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SET_REGION_OPTION] @region_name varchar(50),@option_name varchar(50),@option_value varchar (max)
AS
BEGIN
	IF (EXISTS(select RO_VALUE FROM WQ_REGION_OPTIONS ro join WQ_REGION r on r.ID = ro.RO_FK_REGION 
				WHERE r.ID = dbo.GET_REGION_ID(@region_name) AND RO_NAME=@option_name))
		UPDATE WQ_REGION_OPTIONS SET RO_VALUE=@option_value
			WHERE RO_FK_REGION=dbo.GET_REGION_ID(@region_name) AND RO_NAME=@option_name
	ELSE
	    INSERT INTO WQ_REGION_OPTIONS (RO_FK_REGION, RO_NAME, RO_VALUE) VALUES (dbo.GET_REGION_ID(@region_name), @option_name, @option_value)
END

GO

/****** Object:  StoredProcedure [dbo].[SET_INITIAL_TRANSACTION]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SET_INITIAL_TRANSACTION] @transaction_name varchar(8), @region_name varchar(50)
AS
BEGIN
	EXECUTE [dbo].[SET_REGION_OPTION] @region_name, 'InitialTransaction', @transaction_name
END
GO
/****** Object:  StoredProcedure [dbo].[SET_APPLICATION_CONNECTION_STRING]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SET_APPLICATION_CONNECTION_STRING] @region_name varchar(50), @connection_string varchar(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.WQ_REGION SET RE_APPLICATION_CONNECTION_STRING = @connection_string WHERE ID = dbo.GET_REGION_ID(@region_name)
END
GO
/****** Object:  StoredProcedure [dbo].[CLEAR_TRANSACTIONS]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CLEAR_TRANSACTIONS] @region_name varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM WQ_TRANSACTION WHERE WQ_TRANSACTION.TR_FK_REGION = dbo.GET_REGION_ID(@region_name)
END
GO
/****** Object:  StoredProcedure [dbo].[CLEAR_QUEUES]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CLEAR_QUEUES] @region_name varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM WQ_TD_QUEUE WHERE TD_FK_REGION = dbo.GET_REGION_ID(@region_name)
END
GO
/****** Object:  StoredProcedure [dbo].[CLEAR_PROGRAMS_PATHS]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CLEAR_PROGRAMS_PATHS] @region_name varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM WQ_PROGRAMS_PATH WHERE WQ_PROGRAMS_PATH.PP_FK_REGION = dbo.GET_REGION_ID(@region_name)
END
GO
/****** Object:  StoredProcedure [dbo].[CLEAR_MAPS_PATHS]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CLEAR_MAPS_PATHS] @region_name varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM WQ_MAPS_PATH WHERE WQ_MAPS_PATH.MP_FK_REGION = dbo.GET_REGION_ID(@region_name)
END
GO
/****** Object:  StoredProcedure [dbo].[CLEAR_QIXMS_TRANSACTIONS]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CLEAR_QIXMS_TRANSACTIONS] @region_name varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM WQ_QIXMS_TRANSACTION WHERE WQ_QIXMS_TRANSACTION.TRI_FK_REGION = dbo.GET_REGION_ID(@region_name)
END
GO
/****** Object:  StoredProcedure [dbo].[CLEAR_FORWARD_TRANSACTIONS]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CLEAR_FORWARD_TRANSACTIONS] @region_name varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM WQ_FORWARD_TRANSACTION WHERE WQ_FORWARD_TRANSACTION.FT_FK_REGION = dbo.GET_REGION_ID(@region_name)
END
GO
/****** Object:  StoredProcedure [dbo].[CLEAR_FORWARD_DESTINATIONS]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CLEAR_FORWARD_DESTINATIONS] @region_name varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM WQ_FORWARD_DESTINATION WHERE WQ_FORWARD_DESTINATION.FD_FK_REGION = dbo.GET_REGION_ID(@region_name)
END
GO
/****** Object:  StoredProcedure [dbo].[ADD_TRANSACTION]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ADD_TRANSACTION] @region_name varchar(50), @transaction_name varchar(4), @program_name varchar(50), @twa_size int
AS
BEGIN
	insert into WQ_TRANSACTION(TR_FK_REGION, TR_NAME, TR_PROGRAM, TR_TWASIZE)
	       values([dbo].[GET_REGION_ID](@region_name), @transaction_name, @program_name, @twa_size)
END
GO
/****** Object:  StoredProcedure [dbo].[ADD_TERMINAL_SERVER]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ADD_TERMINAL_SERVER] @region_name varchar(50), @codepage int
AS
BEGIN
	INSERT INTO WQ_TS(TS_FK_REGION, TS_CODEPAGE) VALUES([dbo].[GET_REGION_ID](@region_name), @codepage)
END
GO
/****** Object:  StoredProcedure [dbo].[ADD_TD_QUEUE]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ADD_TD_QUEUE] @region_name varchar(50), @TD_QUEUE_NAME varchar(50), @MSMQ_HOST varchar(50)
AS
BEGIN
	BEGIN TRY
		INSERT INTO WQ_TD_QUEUE(TD_FK_REGION, TD_NAME, TD_ENABLED, TD_MSMQ_HOST)
			VALUES(dbo.GET_REGION_ID(@region_name), @TD_QUEUE_NAME, 1, @MSMQ_HOST);
	END TRY
	BEGIN CATCH
		RETURN 0
	END CATCH
	RETURN 1
END
GO
/****** Object:  StoredProcedure [dbo].[ADD_SESSION]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ADD_SESSION] @region_name varchar(50), @session_id uniqueidentifier
AS
BEGIN
	INSERT INTO WQ_SESSION(ID, SE_FK_REGION, SE_TRANSACTION) VALUES(@session_id, [dbo].[GET_REGION_ID](@region_name), null)
END
GO
/****** Object:  StoredProcedure [dbo].[ADD_PROGRAMS_PATH]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ADD_PROGRAMS_PATH] @region_name varchar(50), @path text
AS
BEGIN
	INSERT INTO WQ_PROGRAMS_PATH(PP_FK_REGION, PP_PATH)
	       VALUES([dbo].[GET_REGION_ID](@region_name), @path)
END
GO
/****** Object:  StoredProcedure [dbo].[ADD_MAPS_PATH]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ADD_MAPS_PATH] @region_name varchar(50), @path text
AS
BEGIN
	INSERT INTO WQ_MAPS_PATH(MP_FK_REGION, MP_PATH)
	       VALUES([dbo].[GET_REGION_ID](@region_name), @path)
END
GO
/****** Object:  StoredProcedure [dbo].[ADD_QIXMS_TRANSACTION]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ADD_QIXMS_TRANSACTION] @region_name varchar(50), @transaction_name varchar(8), @program_name varchar(50), @conversational bit
AS
BEGIN
	insert into WQ_QIXMS_TRANSACTION(TRI_FK_REGION, TRI_NAME, TRI_PROGRAM, TRI_CONVERSATIONAL)
	       values([dbo].[GET_REGION_ID](@region_name), @transaction_name, @program_name, @conversational)
END

GO

/****** Object:  StoredProcedure [dbo].[ADD_USER_TRANSACTIONS]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ADD_USER_TRANSACTIONS]  @transaction_name varchar(8), @userid varchar(8)
AS
BEGIN
	insert into WQ_USER_TRANSACTIONS(UR_USERID, UR_FK_QIXMS_TRANSACTIONID)
	       values(@userid, [dbo].[GET_QIXMS_TRANSACTION_ID](@transaction_name))
END
GO

/****** Object:  StoredProcedure [dbo].[ADD_TRANSACTION_SECURITY_OPTIONS]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ADD_TRANSACTION_SECURITY_OPTIONS] @transaction_name varchar(8), @isSign bit, @isKnownUser bit, @password varchar(8)
AS
BEGIN
	insert into WQ_TRANSACTION_SECURITY_OPTIONS(TSO_SIGN, TSO_PASSWORD, TSO_KNOWN_USER, TSO_PK_QIXMS_TRANSACTION)
	       values(@isSign, @password, @isKnownUser, [dbo].[GET_QIXMS_TRANSACTION_ID](@transaction_name))
END
GO
/****** Object:  StoredProcedure [dbo].[ADD_FORWARD_TRANSACTION]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ADD_FORWARD_TRANSACTION] @region_name varchar(50), @transaction_id varchar(100), @destination varchar(8000), @remote_transaction varchar(100)
AS
BEGIN
	declare @region_id int;
	set @region_id = -1;

	select @region_id = id from WQ_REGION where RE_NAME = @region_name;

	if @region_id > 1
	begin
		INSERT INTO WQ_FORWARD_TRANSACTION(FT_FK_REGION, FT_TRANSACTION_ID, FT_DESTINATION, FT_REMOTE_TRANSACTION)
		       VALUES(@region_id, @transaction_id, @destination, @remote_transaction);
	end
END
GO
/****** Object:  StoredProcedure [dbo].[ADD_FORWARD_DESTINATION]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ADD_FORWARD_DESTINATION] @region_name varchar(50), @host_id varchar(50), @host_name text, @port int
AS
BEGIN
	declare @region_id int;
	set @region_id = -1;

	select @region_id = id from WQ_REGION where RE_NAME = @region_name;

	if @region_id > 1
	begin
		INSERT INTO WQ_FORWARD_DESTINATION(FD_HOSTID, FD_HOSTNAME, FD_PORT, FD_FK_REGION)
		       VALUES(@host_id, @host_name, @port, @region_id);
	end
END
GO
/****** Object:  StoredProcedure [dbo].[GET_TRANSACTIONS]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GET_TRANSACTIONS] @region_name varchar(50)
as
select TR_NAME, PR_NAME, TR_TWASIZE from WQ_VIEW_TRANSACTION where RE_NAME = @region_name
GO
/****** Object:  StoredProcedure [dbo].[GET_TRANSACTION_IN_SESSION]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GET_TRANSACTION_IN_SESSION] @session_id uniqueidentifier
AS
BEGIN
	SELECT TR_NAME FROM WQ_VIEW_SESSION WHERE ID = @session_id
END
GO
/****** Object:  StoredProcedure [dbo].[GET_COMMAREA]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GET_COMMAREA] @session_id uniqueidentifier
AS
BEGIN
	SELECT SE_COMMAREA FROM WQ_VIEW_SESSION WHERE ID = @session_id
END
GO
/****** Object:  StoredProcedure [dbo].[GET_QUEUES]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GET_QUEUES] @region_name varchar(50)
AS
BEGIN
	SELECT TD_NAME, TD_ENABLED, TD_MSMQ_HOST FROM WQ_VIEW_TD_QUEUE WHERE RE_NAME=@region_name;
END
GO
/****** Object:  StoredProcedure [dbo].[GET_PROGRAMS_PATH]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_PROGRAMS_PATH] @region_name varchar(50)
AS
BEGIN
	SELECT PP_PATH FROM WQ_VIEW_PROGRAMS_PATH WHERE re_name = @region_name ORDER BY ID ASC
END
GO
/****** Object:  StoredProcedure [dbo].[GET_PARALLEL_DESTINATION]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GET_PARALLEL_DESTINATION]  @region_name varchar(50)
AS
BEGIN
	SELECT FD_HOSTID, FD_HOSTNAME, FD_PORT FROM WQ_VIEW_REGION WHERE RE_NAME = @region_name;
END
GO
/****** Object:  StoredProcedure [dbo].[GET_MAPS_PATHS]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_MAPS_PATHS] @region_name varchar(50)
AS
BEGIN
	SELECT MP_PATH FROM WQ_VIEW_MAPS_PATH WHERE re_name = @region_name ORDER BY ID ASC
END
GO
/****** Object:  StoredProcedure [dbo].[GET_QIXMS_TRANSACTIONS]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE procedure [dbo].[GET_QIXMS_TRANSACTIONS] @region_name varchar(50)
as
select TRI_NAME, WQ_VIEW_QIXMS_TRANSACTION.TRI_PROGRAM, TRI_CONVERSATIONAL from WQ_VIEW_QIXMS_TRANSACTION where RE_NAME = @region_name
GO

/****** Object:  StoredProcedure [dbo].[GET_USER_TRANSACTIONS]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE procedure [dbo].[GET_USER_TRANSACTIONS] @transaction_name varchar(8)
as
select UR_USERID from WQ_USER_TRANSACTIONS where UR_FK_QIXMS_TRANSACTIONID = dbo.GET_QIXMS_TRANSACTION_ID(@transaction_name)
GO

/****** Object:  StoredProcedure [dbo].[GET_TRANSACTIONS_SECURITY_OPTIONS]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE procedure [dbo].[GET_TRANSACTIONS_SECURITY_OPTIONS] @transaction_name varchar(8)
as
select TSO_SIGN, TSO_KNOWN_USER, TSO_PASSWORD from WQ_TRANSACTION_SECURITY_OPTIONS where TSO_PK_QIXMS_TRANSACTION = dbo.GET_QIXMS_TRANSACTION_ID(@transaction_name)
GO

/****** Object:  StoredProcedure [dbo].[GET_FORWARD_TRANSACTIONS]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_FORWARD_TRANSACTIONS] @region_name varchar(50)
AS
BEGIN
   select FT_TRANSACTION_ID, FT_DESTINATION, FT_REMOTE_TRANSACTION from WQ_VIEW_FORWARD_TRANSACTION where RE_NAME = @region_name
END
GO
/****** Object:  StoredProcedure [dbo].[GET_FORWARD_DESTINATIONS]    Script Date: 09/12/2013 12:50:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_FORWARD_DESTINATIONS] @region_name varchar(50)
AS
BEGIN
    SELECT FD_HOSTID, FD_HOSTNAME, FD_PORT FROM WQ_VIEW_FORWARD_DESTINATION WHERE RE_NAME = @region_name;
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[IS_ALLOWED_EXECUTE_TRANSACTION] @transaction_name varchar(8), @userid varchar(8)
AS
BEGIN
	IF (EXISTS(select * FROM WQ_TRANSACTION_SECURITY_OPTIONS
            	WHERE TSO_PK_QIXMS_TRANSACTION = dbo.GET_QIXMS_TRANSACTION_ID(@transaction_name) AND TSO_KNOWN_USER = 1)
		 AND
	    NOT EXISTS(select * FROM WQ_USER_TRANSACTIONS WHERE UR_USERID=@userid AND UR_FK_QIXMS_TRANSACTIONID= dbo.GET_QIXMS_TRANSACTION_ID(@transaction_name)))
		SELECT 0
	ELSE
	    SELECT 1
END
GO
/****** Object:  Default [DF_WQ_REGION_RE_CWASIZE]    Script Date: 09/12/2013 12:50:45 ******/
ALTER TABLE [dbo].[WQ_REGION] ADD  CONSTRAINT [DF_WQ_REGION_RE_CWASIZE]  DEFAULT ((512)) FOR [RE_CWASIZE]
GO
/****** Object:  Default [DF_WQ_TRANSACTION_TR_TWASIZE]    Script Date: 09/12/2013 12:50:45 ******/
ALTER TABLE [dbo].[WQ_TRANSACTION] ADD  CONSTRAINT [DF_WQ_TRANSACTION_TR_TWASIZE]  DEFAULT ((0)) FOR [TR_TWASIZE]
GO
/****** Object:  ForeignKey [FK_WQ_FORWARD_DESTINATION_WQ_REGION]    Script Date: 09/12/2013 12:50:45 ******/
ALTER TABLE [dbo].[WQ_FORWARD_DESTINATION]  WITH CHECK ADD  CONSTRAINT [FK_WQ_FORWARD_DESTINATION_WQ_REGION] FOREIGN KEY([FD_FK_REGION])
REFERENCES [dbo].[WQ_REGION] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WQ_FORWARD_DESTINATION] CHECK CONSTRAINT [FK_WQ_FORWARD_DESTINATION_WQ_REGION]
GO
/****** Object:  ForeignKey [FK_WQ_FORWARD_TRANSACTION_WQ_REGION]    Script Date: 09/12/2013 12:50:45 ******/
ALTER TABLE [dbo].[WQ_FORWARD_TRANSACTION]  WITH CHECK ADD  CONSTRAINT [FK_WQ_FORWARD_TRANSACTION_WQ_REGION] FOREIGN KEY([FT_FK_REGION])
REFERENCES [dbo].[WQ_REGION] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WQ_FORWARD_TRANSACTION] CHECK CONSTRAINT [FK_WQ_FORWARD_TRANSACTION_WQ_REGION]
GO
/****** Object:  ForeignKey [FK_WQ_QIXMS_TRANSACTION_WQ_REGION]    Script Date: 09/12/2013 12:50:45 ******/
ALTER TABLE [dbo].[WQ_QIXMS_TRANSACTION]  WITH CHECK ADD  CONSTRAINT [FK_WQ_QIXMS_TRANSACTION_WQ_REGION] FOREIGN KEY([TRI_FK_REGION])
REFERENCES [dbo].[WQ_REGION] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WQ_QIXMS_TRANSACTION] CHECK CONSTRAINT [FK_WQ_QIXMS_TRANSACTION_WQ_REGION]
GO


-- Creating foreign key on [UR_FK_QIXMS_TRANSACTIONID] in table 'WQ_USER_TRANSACTIONS'
ALTER TABLE [dbo].[WQ_USER_TRANSACTIONS]
ADD CONSTRAINT [FK_WQ_QIXMS_TRANSACTIONWQ_USER]
    FOREIGN KEY ([UR_FK_QIXMS_TRANSACTIONID])
    REFERENCES [dbo].[WQ_QIXMS_TRANSACTION]
        ([ID])
    ON DELETE CASCADE ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_WQ_QIXMS_TRANSACTIONWQ_USER'
CREATE INDEX [IX_FK_WQ_QIXMS_TRANSACTIONWQ_USER]
ON [dbo].[WQ_USER_TRANSACTIONS]
    ([UR_FK_QIXMS_TRANSACTIONID]);
GO

-- Creating foreign key on [TSO_PK_QIXMS_TRANSACTION] in table 'WQ_TRANSACTION_SECURITY_OPTIONS'
ALTER TABLE [dbo].[WQ_TRANSACTION_SECURITY_OPTIONS]
ADD CONSTRAINT [FK_WQ_QIXMS_TRANSACTIONWQ_TRANSACTION_SECURITY_OPTIONS]
    FOREIGN KEY ([TSO_PK_QIXMS_TRANSACTION])
    REFERENCES [dbo].[WQ_QIXMS_TRANSACTION]
        ([ID])
    ON DELETE CASCADE ON UPDATE NO ACTION;
GO

/****** Object:  ForeignKey [FK_WQ_MAPS_PATH_WQ_REGION]    Script Date: 09/12/2013 12:50:45 ******/
ALTER TABLE [dbo].[WQ_MAPS_PATH]  WITH CHECK ADD  CONSTRAINT [FK_WQ_MAPS_PATH_WQ_REGION] FOREIGN KEY([MP_FK_REGION])
REFERENCES [dbo].[WQ_REGION] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WQ_MAPS_PATH] CHECK CONSTRAINT [FK_WQ_MAPS_PATH_WQ_REGION]
GO
/****** Object:  ForeignKey [FK_WQ_MODULES_PATHS_WQ_REGION]    Script Date: 09/12/2013 12:50:45 ******/
ALTER TABLE [dbo].[WQ_PROGRAMS_PATH]  WITH CHECK ADD  CONSTRAINT [FK_WQ_MODULES_PATHS_WQ_REGION] FOREIGN KEY([PP_FK_REGION])
REFERENCES [dbo].[WQ_REGION] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WQ_PROGRAMS_PATH] CHECK CONSTRAINT [FK_WQ_MODULES_PATHS_WQ_REGION]
GO
/****** Object:  ForeignKey [FK_WQ_MQ_QUEUE_WQ_REGION]    Script Date: 01/17/2014 16:09:00 ******/
ALTER TABLE [dbo].[WQ_MQ_QUEUE]  WITH CHECK ADD  CONSTRAINT [FK_WQ_MQ_QUEUE_WQ_REGION] FOREIGN KEY([MQ_FK_REGION])
REFERENCES [dbo].[WQ_REGION] ([ID])
GO
ALTER TABLE [dbo].[WQ_MQ_QUEUE] CHECK CONSTRAINT [FK_WQ_MQ_QUEUE_WQ_REGION]
GO
/****** Object:  ForeignKey [FK_WQ_SESSION_WQ_REGION]    Script Date: 09/12/2013 12:50:45 ******/
ALTER TABLE [dbo].[WQ_SESSION]  WITH CHECK ADD  CONSTRAINT [FK_WQ_SESSION_WQ_REGION] FOREIGN KEY([SE_FK_REGION])
REFERENCES [dbo].[WQ_REGION] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WQ_SESSION] CHECK CONSTRAINT [FK_WQ_SESSION_WQ_REGION]
GO
/****** Object:  ForeignKey [FK_WQ_TD_QUEUE_WQ_REGION]    Script Date: 09/12/2013 12:50:45 ******/
ALTER TABLE [dbo].[WQ_TD_QUEUE]  WITH CHECK ADD  CONSTRAINT [FK_WQ_TD_QUEUE_WQ_REGION] FOREIGN KEY([TD_FK_REGION])
REFERENCES [dbo].[WQ_REGION] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WQ_TD_QUEUE] CHECK CONSTRAINT [FK_WQ_TD_QUEUE_WQ_REGION]
GO
/****** Object:  ForeignKey [FK_WQ_TRANSACTION_WQ_REGION]    Script Date: 09/12/2013 12:50:45 ******/
ALTER TABLE [dbo].[WQ_TRANSACTION]  WITH CHECK ADD  CONSTRAINT [FK_WQ_TRANSACTION_WQ_REGION] FOREIGN KEY([TR_FK_REGION])
REFERENCES [dbo].[WQ_REGION] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WQ_TRANSACTION] CHECK CONSTRAINT [FK_WQ_TRANSACTION_WQ_REGION]
GO
/****** Object:  ForeignKey [FK_WQ_TS_WQ_REGION]    Script Date: 09/12/2013 12:50:45 ******/
ALTER TABLE [dbo].[WQ_TS]  WITH CHECK ADD  CONSTRAINT [FK_WQ_TS_WQ_REGION] FOREIGN KEY([TS_FK_REGION])
REFERENCES [dbo].[WQ_REGION] ([ID])
GO
ALTER TABLE [dbo].[WQ_TS] CHECK CONSTRAINT [FK_WQ_TS_WQ_REGION]
GO
/****** Object:  ForeignKey [FK_WQ_REGION_OPTIONS_WQ_REGION]    Script Date: 09/12/2013 12:50:45 ******/
ALTER TABLE [dbo].[WQ_REGION_OPTIONS] WITH CHECK ADD CONSTRAINT [FK_WQ_REGION_OPTIONS_WQ_REGION] FOREIGN KEY ([RO_FK_REGION])
REFERENCES [dbo].[WQ_REGION] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WQ_REGION_OPTIONS] CHECK CONSTRAINT [FK_WQ_REGION_OPTIONS_WQ_REGION]
GO
