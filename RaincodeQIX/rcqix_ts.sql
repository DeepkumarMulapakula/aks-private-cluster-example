CREATE DATABASE [QixTSQueues]
GO
USE [QixTSQueues]
GO
/****** Object:  Table [dbo].[TS_QUEUE]    Script Date: 07/23/2013 11:00:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TS_QUEUE](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TS_NAME] [varchar](8) NOT NULL,
	[TS_NEXT_ITEM] [int] NOT NULL DEFAULT 1,
 CONSTRAINT [PK_TS_QUEUE] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_TS_QUEUE] UNIQUE NONCLUSTERED
(
	[TS_NAME] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TS_ITEMS]    Script Date: 07/23/2013 11:00:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TS_ITEMS](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TS_FK_QUEUE] [int] NOT NULL,
	[TS_DATA] [varbinary](max) NULL,
 CONSTRAINT [PK_TS_ITEMS] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[func_TSQUEUE_EXISTS]    Script Date: 07/23/2013 11:00:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[func_TSQUEUE_EXISTS]
(
	@queue_name varchar(8)
)
RETURNS bit
AS
BEGIN
	IF EXISTS(SELECT * FROM TS_QUEUE WHERE TS_NAME = @queue_name)
	BEGIN
		RETURN 1
	END
	ELSE
	BEGIN
		RETURN 0
	END

	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[TSQUEUE_EXISTS]    Script Date: 07/23/2013 11:00:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TSQUEUE_EXISTS] @queue_name varchar(8)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT dbo.func_TSQUEUE_EXISTS(@queue_name)
END
GO
/****** Object:  UserDefinedFunction [dbo].[func_GET_QUEUE_ID]    Script Date: 07/23/2013 11:00:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[func_GET_QUEUE_ID]
(
	@queue_name varchar(8)
)
RETURNS int
AS
BEGIN
	DECLARE @queue_id int
	SELECT @queue_id = ID FROM TS_QUEUE WHERE TS_QUEUE.TS_NAME = @queue_name;
	RETURN @queue_id

END
GO
/****** Object:  StoredProcedure [dbo].[REWRITE_ITEM]    Script Date: 07/23/2013 11:00:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[REWRITE_ITEM] @queue_name varchar(8), @item int, @data varbinary(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	/*UPDATE TS_ITEMS SET TS_DATA = @data WHERE TS_FK_QUEUE = dbo.func_GET_QUEUE_ID(@queue_name) AND TS_ITEMNR = @item*/
	update TS_ITEMS set
	TS_DATA = @data where ID = (
		select ID from (select ID, TS_DATA, ROW_NUMBER() over(order by ID) as row from dbo.[TS_ITEMS] WHERE TS_FK_QUEUE=dbo.func_GET_QUEUE_ID(@queue_name)) b where row = @item
	)
END
GO
/****** Object:  StoredProcedure [dbo].[READ_ITEM]    Script Date: 07/23/2013 11:00:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[READ_ITEM] @queue_name varchar(8), @item int
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY


   SELECT TS_DATA, row FROM (
     SELECT
       ROW_NUMBER() OVER (ORDER BY ID ASC) AS row, TS_DATA
     FROM TS_ITEMS
     WHERE TS_FK_QUEUE=dbo.func_GET_QUEUE_ID(@queue_name)
   ) AS dummy
   WHERE row = @item

END TRY
	BEGIN CATCH
		RETURN ERROR_MESSAGE()
	END CATCH
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[READ_NEXT] @queue_name varchar(8)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY

		DECLARE @qid INTEGER;
		DECLARE @item INTEGER;
      DECLARE @data VARBINARY(MAX);
      DECLARE @row INTEGER;

      SET @qid = dbo.func_GET_QUEUE_ID(@queue_name);
		SELECT @item = TS_NEXT_ITEM FROM TS_QUEUE WHERE ID = @qid;

      SELECT @data = TS_DATA, @row = row FROM (
		  SELECT
			ROW_NUMBER() OVER (ORDER BY ID ASC) AS row, TS_DATA
		  FROM TS_ITEMS
		  WHERE TS_FK_QUEUE=@qid
		) AS dummy
		WHERE row = @item
      IF @data IS NOT NULL
      BEGIN
         UPDATE TS_QUEUE SET TS_NEXT_ITEM = @item + 1 WHERE ID = @qid;
      END
      IF @data IS NOT NULL SELECT @data;
END TRY
	BEGIN CATCH
		RETURN ERROR_MESSAGE()
	END CATCH
END

/****** Object:  StoredProcedure [dbo].[NUMITEMS]    Script Date: 07/23/2013 11:00:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[NUMITEMS] @queue_name varchar(8)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT COUNT(*) FROM TS_ITEMS WHERE TS_FK_QUEUE=dbo.func_GET_QUEUE_ID(@queue_name)
END
GO
/****** Object:  StoredProcedure [dbo].[DELETE_TS]    Script Date: 07/23/2013 11:00:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DELETE_TS] @queue_name varchar(8)
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE FROM TS_QUEUE WHERE ID = dbo.func_GET_QUEUE_ID(@queue_name)
END
GO
/****** Object:  StoredProcedure [dbo].[CREATE_TSQUEUE]    Script Date: 07/23/2013 11:00:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CREATE_TSQUEUE] @queue_name varchar(8)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF dbo.func_TSQUEUE_EXISTS(@queue_name) = 0
    BEGIN
		INSERT INTO TS_QUEUE(TS_NAME) VALUES(@queue_name)
		RETURN 1;
    END
    RETURN 0;
END
GO
/****** Object:  StoredProcedure [dbo].[WRITE_ITEM]    Script Date: 07/23/2013 11:00:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[WRITE_ITEM] @queue_name varchar(8) , @data varbinary(MAX)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		DECLARE @count int
		IF dbo.func_TSQUEUE_EXISTS(@queue_name) = 0
		BEGIN
			EXEC dbo.CREATE_TSQUEUE @queue_name
		END

		INSERT INTO TS_ITEMS(TS_FK_QUEUE, TS_DATA) VALUES(dbo.func_GET_QUEUE_ID(@queue_name), @data)
	END TRY
	BEGIN CATCH
		RETURN -1
	END CATCH
	RETURN 1
END
GO
/****** Object:  ForeignKey [FK_TS_ITEMS_TS_QUEUE]    Script Date: 07/23/2013 11:00:31 ******/
ALTER TABLE [dbo].[TS_ITEMS]  WITH CHECK ADD  CONSTRAINT [FK_TS_ITEMS_TS_QUEUE] FOREIGN KEY([TS_FK_QUEUE])
REFERENCES [dbo].[TS_QUEUE] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TS_ITEMS] CHECK CONSTRAINT [FK_TS_ITEMS_TS_QUEUE]
GO

/****** Object:  Index [IDX_TS_FK_QUEUE]    Script Date: 21-05-2014 17:00:32 ******/
CREATE NONCLUSTERED INDEX [IDX_TS_FK_QUEUE] ON [dbo].[TS_ITEMS]
(
	[TS_FK_QUEUE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
