SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PaymentStatus]
    (
      [StatusId] BIGINT NOT NULL IDENTITY(1,1)
    , [Description] NVARCHAR(255) NOT NULL
    , CONSTRAINT PK_PaymentStatus PRIMARY KEY CLUSTERED ([StatusId])
    )

SET ANSI_PADDING OFF

GO

SET IDENTITY_INSERT dbo.PaymentStatus ON;

INSERT  INTO dbo.PaymentStatus
        ( [StatusId], [Description] )
VALUES  ( 0, 'Incomplete or invalid' )
,       ( 1, 'Cancelled by client' )
,       ( 2, 'Authorization refused' )
,       ( 4, 'Order stored' )
,       ( 5, 'Authorized' )
,       ( 6, 'Authorized and cancelled' )
,       ( 7, 'Payment deleted' )
,       ( 8, 'Refund' )
,       ( 9, 'Payment requested' )
,       ( 41, 'Waiting client payment' )
,       ( 51, 'Authorization waiting' )
,       ( 52, 'Authorization not known' )
,       ( 55, 'Stand-by' )
,       ( 59, 'Authoriz. to get manually' )
,       ( 61, 'Author. deletion waiting' )
,       ( 62, 'Author. deletion uncertain' )
,       ( 63, 'Author. deletion refused' )
,       ( 64, 'Authorized and cancelled' )
,       ( 71, 'Payment deletion pending' )
,       ( 72, 'Payment deletion uncertain' )
,       ( 73, 'Payment deletion refused' )
,       ( 74, 'Payment deleted' )
,       ( 75, 'Deletion processed by merchant' )
,       ( 81, 'Refund pending' )
,       ( 82, 'Refund uncertain' )
,       ( 83, 'Refund refused' )
,       ( 84, 'Payment declined by the acquirer' )
,       ( 85, 'Refund processed by merchant' )
,       ( 91, 'Payment processing' )
,       ( 92, 'Payment uncertain' )
,       ( 93, 'Payment refused' )
,       ( 94, 'Refund declined by the acquirer' )
,       ( 95, 'Payment processed by merchant' )
,       ( 99, 'Being processed' )
;

SET IDENTITY_INSERT dbo.PaymentStatus OFF;

GO

CREATE TABLE [dbo].[Transmission]
    (
      [TRANSMISSION_Id] BIGINT NOT NULL
    , [LEVEL] NVARCHAR(255) NULL
    , [DESCRIP] NVARCHAR(255) NULL
    , CONSTRAINT PK_Transmission PRIMARY KEY CLUSTERED ([TRANSMISSION_Id])
    )

GO

CREATE TABLE [dbo].[Payments]
    (
      [ID] BIGINT NULL
    , [REF] NVARCHAR(255) NULL
    , [ORDER] DATETIME NULL
    , [STATUS] BIGINT NULL
    , [LIB] NVARCHAR(255) NULL
    , [ACCEPT] NVARCHAR(255) NULL
    , [PAYDATE] DATETIME NULL
    , [CIE] NVARCHAR(255) NULL
    , [NAME] NVARCHAR(255) NULL
    , [COUNTRY] NVARCHAR(255) NULL
    , [TOTAL] NUMERIC(18, 2) NULL
    , [CUR] NVARCHAR(255) NULL
    , [SHIP] NUMERIC(18, 2) NULL
    , [TAX] NUMERIC(18, 2) NULL
    , [METHOD] NVARCHAR(255) NULL
    , [BRAND] NVARCHAR(255) NULL
    , [CARD] NVARCHAR(255) NULL
    , [STRUCT] NVARCHAR(255) NULL
    , [TRANSMISSION_ID] BIGINT NULL 
    , CONSTRAINT FK_Payments_PaymentStatusId FOREIGN KEY ([STATUS]) REFERENCES dbo.PaymentStatus ([StatusId])
    , CONSTRAINT FK_Payments_TransmissionId FOREIGN KEY ([TRANSMISSION_ID]) REFERENCES dbo.Transmission ([TRANSMISSION_Id])
    )

GO
