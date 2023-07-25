IF NOT EXISTS(SELECT 1 FROM sys.databases WHERE name = 'IMSql_Config')
CREATE DATABASE [IMSql_Config]
GO

--- Using IMSql_Config
USE [IMSql_Config];
GO

--- Sql Server Settings
ALTER DATABASE [IMSql_Config]
	SET ENABLE_BROKER WITH ROLLBACK IMMEDIATE;
GO
ALTER DATABASE [IMSql_Config]
	SET NEW_BROKER WITH ROLLBACK IMMEDIATE;
GO
IF NOT EXISTS (SELECT 1 FROM sys.service_message_types WHERE name = 'BeginSession')
CREATE MESSAGE TYPE BeginSession
	VALIDATION = NONE
GO
IF NOT EXISTS (SELECT 1 FROM sys.service_message_types WHERE name = 'EndSession')
CREATE MESSAGE TYPE EndSession
	VALIDATION = NONE
GO
IF NOT EXISTS (SELECT 1 FROM sys.service_message_types WHERE name = 'AllocateTerminal')
CREATE MESSAGE TYPE AllocateTerminal
	VALIDATION = NONE
GO
IF NOT EXISTS (SELECT 1 FROM sys.service_message_types WHERE name = 'TerminalAllocated')
CREATE MESSAGE TYPE TerminalAllocated
	VALIDATION = NONE
GO
IF NOT EXISTS (SELECT 1 FROM sys.service_message_types WHERE name = 'FormatScreen')
CREATE MESSAGE TYPE FormatScreen
	VALIDATION = NONE
GO
IF NOT EXISTS (SELECT 1 FROM sys.service_message_types WHERE name = 'CommandMessage')
CREATE MESSAGE TYPE CommandMessage
	VALIDATION = NONE
GO
IF NOT EXISTS (SELECT 1 FROM sys.service_message_types WHERE name = 'InputMessage')
CREATE MESSAGE TYPE InputMessage
	VALIDATION = NONE
GO
IF NOT EXISTS (SELECT 1 FROM sys.service_message_types WHERE name = 'ErrorMessage')
CREATE MESSAGE TYPE ErrorMessage
	VALIDATION = NONE
GO
IF NOT EXISTS (SELECT 1 FROM sys.service_message_types WHERE name = 'SignRequest')
CREATE MESSAGE TYPE SignRequest
	VALIDATION = NONE
GO
-- ServiceContract TerminalServiceContract
CREATE CONTRACT [TerminalServiceContract] (
		BeginSession SENT BY INITIATOR,
		EndSession SENT BY ANY,
		AllocateTerminal SENT BY ANY,
		TerminalAllocated SENT BY ANY,
		FormatScreen SENT BY ANY,
		CommandMessage SENT BY ANY,
		InputMessage SENT BY ANY,
		ErrorMessage SENT BY ANY,
		SignRequest SENT BY ANY
	)
GO

CREATE QUEUE [TerminalServer] WITH STATUS = ON
GO
-- Service TerminalService
CREATE SERVICE [TerminalService] ON QUEUE [TerminalServer]
GO
ALTER SERVICE [TerminalService](
		ADD CONTRACT [TerminalServiceContract]
	)
GO

IF NOT EXISTS (SELECT 1 FROM sys.service_message_types WHERE name = 'OutputMessage')
CREATE MESSAGE TYPE OutputMessage
	VALIDATION = NONE
GO
-- ServiceContract ProcessingServiceContract
CREATE CONTRACT [ProcessingServiceContract] (
		InputMessage SENT BY INITIATOR,
		OutputMessage SENT BY TARGET,
		ErrorMessage SENT BY TARGET
	)
GO

CREATE QUEUE [ProcessingServer] WITH STATUS = ON
GO
-- Service ProcessingService
CREATE SERVICE [ProcessingService] ON QUEUE [ProcessingServer]
GO
ALTER SERVICE [ProcessingService](
		ADD CONTRACT [ProcessingServiceContract],
		ADD CONTRACT [TerminalServiceContract]
	)
GO

-- Start of Stored Proc rc_get_message
CREATE PROCEDURE [rc_get_message]
@LTERM char(8) = NULL,
    @REGION char(8) = NULL,
    @DEST char(8) OUT,
    @MOD char(8) OUT,
    @DATA varbinary(8000) OUT,
    @SRC char(8) OUT,
    @ISOUTPUT bit OUT    AS    
DECLARE @records TABLE
(
  [UID] uniqueidentifier,
  [DEST] char(8),
  [SRC] char(8),
  [MOD] char(8),
  [DATA] varbinary(8000),
  [IsOutput] bit
);

WITH T(UID, State, Data, DestCode, SrcCode, ModName, IsOutput) AS
(   
	SELECT TOP(1) qmsg.[UID], 
	qmsg.[State], qmsg.[Data], 
	qmsg.[DestCode], 
	qmsg.[SrcCode], 
	qmsg.[ModName], 
	qmsg.[IsOutput]
	FROM [dbo].[rc_ims_queues] qmsg  WITH(UPDLOCK, READPAST)
	WHERE qmsg.[State] = 0 AND 
	((@LTERM IS NOT NULL AND @LTERM = qmsg.DestCode)
	 OR (@LTERM IS NULL))
)

UPDATE TOP(1) T SET [State] = 1
OUTPUT inserted.[UID],  inserted.[DestCode],  inserted.[SrcCode], inserted.[ModName], inserted.[Data], inserted.[IsOutput] INTO @records

--UPDATE TOP(1) [dbo].[rc_ims_queues] SET [State] = 1
--OUTPUT inserted.[UID], inserted.DestCode, inserted.SrcCode, inserted.[Data] INTO @records
--FROM [dbo].[rc_ims_queues] msg WITH (UPDLOCK,READPAST)
--WHERE  msg.[State] = 0 and (  @REGION = msg.DestCode or msg.DestCode IN ('BMP1','BMP2','BMP3'))

IF NOT EXISTS (SELECT UID FROM @records)
BEGIN
RETURN(0)
END
ELSE
BEGIN
SELECT TOP(1) @DEST = msg.[DEST], @DATA = msg.[Data], @SRC = msg.[SRC], @MOD = msg.[MOD], @ISOUTPUT = msg.IsOutput FROM @records msg
RETURN(1)
END
-- End of rc_get_message
GO
-- Start of Stored Proc rc_send_message
CREATE PROCEDURE [rc_send_message]
@SRC char(8),
    @DEST char(8),
    @MOD char(8),
    @DATA varbinary(8000) OUT    AS    
    INSERT [dbo]. [rc_ims_queues] ([DestCode],[SrcCode],[Data],[ModName], [IsOutput]) 
	    VALUES (@DEST, @SRC, @DATA, @MOD, 1)
    RETURN(0)
-- End of rc_send_message
GO
-- Sql Server Settings
ALTER DATABASE [IMSql_Config]
    SET NEW_BROKER WITH ROLLBACK IMMEDIATE;
GO
