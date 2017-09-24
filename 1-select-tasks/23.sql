CREATE DATABASE [FormulaCalc]
;

USE [FormulaCalc]
;

CREATE TABLE [Formula]
(	
	[FormulaId] INT NOT NULL IDENTITY(1,1)
	, [Code] NVARCHAR(20) NOT NULL DEFAULT('')
	, [Description] NVARCHAR(120) NOT NULL DEFAULT('')
	, [FormulaPurpose] TINYINT NOT NULL DEFAULT(1)
	, [FormulaType] TINYINT NOT NULL DEFAULT(1)
	, [HasSubExpression] BIT NOT NULL DEFAULT(0)
	, [SubExpressionCount] TINYINT NOT NULL DEFAULT(0)
	, [EditableExpression] NVARCHAR(MAX) NOT NULL DEFAULT('')
	, [EvalExpression] NVARCHAR(MAX) NOT NULL DEFAULT('')
	, [ActivationDate] DATE NOT NULL
	, [Notes] NVARCHAR(MAX) NOT NULL DEFAULT('')
	, [IsActive] BIT NOT NULL DEFAULT(1)
	, [CreatedBy] INT NOT NULL DEFAULT(0)
	, [ModifiedBy] INT NOT NULL DEFAULT(0)
	, [DateCreated] DATETIME2(7) NOT NULL DEFAULT(getdate())
	, [DateModified] DATETIME2(7) NOT NULL DEFAULT(getdate())
	, [Ts] TIMESTAMP NOT NULL
	, CONSTRAINT [PK_Formula_Id] PRIMARY KEY([FormulaId])
	, CONSTRAINT [IDX_Formula_Code_U_N] UNIQUE([Code]) 
)
;

CREATE TABLE [FormulaSubExpression]
(
	[FormulaSubExpressionId] INT NOT NULL IDENTITY(1,1)
	, [FormulaId] INT NOT NULL
	, [Description] NVARCHAR(80) NOT NULL DEFAULT('')
	, [SubExprIndex] TINYINT NOT NULL DEFAULT(0)
	, [EditableSubExpression] NVARCHAR(2000) NOT NULL DEFAULT('')
	, [EvalSubExpression] NVARCHAR(2000) NOT NULL DEFAULT('')
	, [CreatedBy] INT NOT NULL DEFAULT(0)
	, [ModifiedBy] INT NOT NULL DEFAULT(0)
	, [DateCreated] DATETIME2(7) NOT NULL DEFAULT(getdate())
	, [DateModified] DATETIME2(7) NOT NULL DEFAULT(getdate())
	, [Ts] TIMESTAMP NOT NULL
	, CONSTRAINT [FK_FormulaSubExpression_FormulaId_Formula_Id] FOREIGN KEY([FormulaId]) REFERENCES [Formula]([FormulaId])
	, CONSTRAINT [PK_FormulaSubExpression_Id] PRIMARY KEY([FormulaSubExpressionId])
)
;

CREATE TABLE [FormulaVariableSet]
(	
	[FormulaVariableSetId] INT NOT NULL IDENTITY(1,1)
	, [FormulaId] INT NOT NULL
	, [Code] NVARCHAR(50) NOT NULL DEFAULT('')
	, [Description] NVARCHAR(80) NOT NULL DEFAULT('')
	, [CanoncialDataType] TINYINT NOT NULL DEFAULT(1)
	, [EvalScope] TINYINT NOT NULL DEFAULT(1)
	, [ConstantValue] NVARCHAR(2000) NOT NULL DEFAULT('')
	, [ResolutionType] TINYINT NOT NULL DEFAULT(1)
	, [SqlExpr] NVARCHAR(4000) NOT NULL DEFAULT('')
	, [EvalExpr] NVARCHAR(4000) NOT NULL DEFAULT('')
	, [ParamsNumberSqlExpr] TINYINT NOT NULL DEFAULT(0)
	, [ParamsNumberEvalExpr] TINYINT NOT NULL DEFAULT(0)
	, [IsActive] BIT NOT NULL DEFAULT(1)
	, [CreatedBy] INT NOT NULL DEFAULT(0)
	, [ModifiedBy] INT NOT NULL DEFAULT(0)
	, [DateCreated] DATETIME2(7) NOT NULL DEFAULT(getdate())
	, [DateModified] DATETIME2(7) NOT NULL DEFAULT(getdate())
	, [Ts] TIMESTAMP NOT NULL
	, CONSTRAINT [PK_FormulaVariableSet_Id] PRIMARY KEY([FormulaVariableSetId])
	, CONSTRAINT [IDX_FormulaVariavleSet_Code_U_N] UNIQUE([Code]) 
)
;

CREATE TABLE [FormulaVariable]
(
	[FormulaVariableId] INT NOT NULL IDENTITY(1,1)
	, [FormulaId] INT NOT NULL
	, [FormulaVariableSetId] INT NOT NULL
	, [DefaultValue] NVARCHAR(2000) NOT NULL DEFAULT('')
	, [MinValue] NVARCHAR(50) NOT NULL DEFAULT(0)
	, [MaxValue] VARCHAR(50) NOT NULL DEFAULT(0)
	, [TimePeriod] TINYINT NOT NULL DEFAULT(0)
	, [PeriodStartDate] DATE NOT NULL
	, [PeriodEndDate] DATE NOT NULL
	, [CurrencyCode] NCHAR(3)
	, [CreatedBy] INT NOT NULL DEFAULT(0)
	, [ModifiedBy] INT NOT NULL DEFAULT(0)
	, [DateCreated] DATETIME2(7) NOT NULL DEFAULT(getdate())
	, [DateModified] DATETIME2(7) NOT NULL DEFAULT(getdate()) 
	, [TS] TIMESTAMP NOT NULL
	, CONSTRAINT [FK_FormulaVariable_Formula] FOREIGN KEY([FormulaId]) REFERENCES [Formula]([FormulaId])
	, CONSTRAINT [FK_FormulaVariable_FormulaVariableSet] FOREIGN KEY([FormulaVariableSetId]) REFERENCES [FormulaVariableSet]([FormulaVariableSetId])
	, CONSTRAINT [PK_FormulaVariable_Id] PRIMARY KEY([FormulaVariableId])
	, CONSTRAINT [IDX_FormulaVariable_FormulaID_FormulaVariableSetId_U_N] UNIQUE ([FormulaId], [FormulaVariableSetId])
)
;

CREATE TABLE [FormulaVariableParam]
(
	[FormulaVariableParamId] INT NOT NULL IDENTITY(1,1)
	, [FormulaVariableId] INT NOT NULL
	, [ParamName] NVARCHAR(120) NOT NULL DEFAULT('')
	, [DefaultValue] NVARCHAR(4000) NOT NULL DEFAULT('')
	, [CanoncialDataType] TINYINT NOT NULL DEFAULT(1)
	, [IsOverridenRuntime] BIT NOT NULL DEFAULT(0)
	, [CreatedBy] INT NOT NULL DEFAULT(0)
	, [ModifiedBy] INT NOT NULL DEFAULT(0)
	, [DateCreated] DATETIME2(7) NOT NULL DEFAULT(getdate())
	, [DateModified] DATETIME2(7) NOT NULL DEFAULT(getdate()) 
	, [TS] TIMESTAMP NOT NULL
	, CONSTRAINT [FK_FormulaVariableParam_FormulaVariableId_FormulaVariable_Id] FOREIGN KEY([FormulaVariableId]) REFERENCES [FormulaVariable]([FormulaVariableId])
	, CONSTRAINT [PK_FormulaVariableParam_Id] PRIMARY KEY([FormulaVariableParamId])
)
;

CREATE TABLE [FormulaHistory]
(
	[FormulaHistoryId] INT NOT NULL IDENTITY(1,1)
	, [FormulaId] INT NOT NULL
	, [Code] NVARCHAR(20) NOT NULL
	, [Description] NVARCHAR(80) NOT NULL DEFAULT('')
	, [FormulaPurpose] TINYINT NOT NULL DEFAULT(1)
	, [FormulaType] TINYINT NOT NULL DEFAULT(1)
	, [HasSubExpression] BIT NOT NULL DEFAULT(0)
	, [SubExpressionCount] TINYINT NOT NULL DEFAULT(0)
	, [EditableExpression] NVARCHAR(MAX) NOT NULL DEFAULT('')
	, [EvalExpression] NVARCHAR(MAX) NOT NULL DEFAULT('')
	, [ActivationDate] DATE NOT NULL
	, [Notes] NVARCHAR(MAX) NOT NULL DEFAULT('')
	, [StartValidDate] DATE NOT NULL
	, [EndValidDate] DATE NOT NULL
	, [IsActive] BIT NOT NULL DEFAULT(1)
	, [CrudAction] TINYINT NOT NULL DEFAULT(1)
	, [CreatedBy] INT NOT NULL DEFAULT(0)
	, [ModifiedBy] INT NOT NULL DEFAULT(0)
	, [DateCreated] DATETIME2(7) NOT NULL DEFAULT(getdate())
	, [DateModified] DATETIME2(7) NOT NULL DEFAULT(getdate()) 
	, [TS] TIMESTAMP NOT NULL
	, CONSTRAINT [PK_FormulaHistory_Id] PRIMARY KEY ([FormulaHistoryId])
	, INDEX [IDX_FormulaHistory_FormulaId_N_N] ([FormulaId])
)
;

CREATE TABLE [FormulaSubExpressionHistory]
(
	[FormulaSubExpressionHistoryId] INT NOT NULL IDENTITY(1,1)
	, [FormulaHistoryId] INT NOT NULL
	, [FormulaSubExpressionId] INT NOT NULL
	, [Description] NVARCHAR(80) NOT NULL DEFAULT('')
	, [EditableSubExpression] NVARCHAR(2000) NOT NULL DEFAULT('')
	, [EvalSubExpression] NVARCHAR(2000) NOT NULL DEFAULT('')
	, [SubExprIndex] TINYINT NOT NULL DEFAULT(0)
	, [CrudAction] TINYINT NOT NULL DEFAULT(1)
	, [CreatedBy] INT NOT NULL DEFAULT(0)
	, [ModifiedBy] INT NOT NULL DEFAULT(0)
	, [DateCreated] DATETIME2(7) NOT NULL DEFAULT(getdate())
	, [DateModified] DATETIME2(7) NOT NULL DEFAULT(getdate()) 
	, [TS] TIMESTAMP NOT NULL
	, CONSTRAINT [FK_FormulaExpressionHistory_FormulaHaistoryId_FormulaHistory_Id] FOREIGN KEY ([FormulaHistoryId]) REFERENCES [FormulaHistory]([FormulaHistoryId])
	, CONSTRAINT [PK_FormulaSubExpressionHistory_Id] PRIMARY KEY ([FormulaSubExpressionHistoryId])
	, INDEX [IDX_FormulaSubExpressionHistory_FormulaSubExpressionId_N_N] ([FormulaSubExpressionId])
)
;

CREATE TABLE [FormulaVariableSetHistory]
(	
	[FormulaVariableSetHistoryId] INT NOT NULL IDENTITY(1,1)
	, [FormulaVariableSetId] INT NOT NULL
	, [Code] NVARCHAR(50) NOT NULL DEFAULT('')
	, [Description] NVARCHAR(80) NOT NULL DEFAULT('')
	, [CanoncialDataType] TINYINT NOT NULL DEFAULT(1)
	, [EvalScope] TINYINT NOT NULL DEFAULT(1)
	, [ConstantValue] NVARCHAR(2000) NOT NULL DEFAULT('')
	, [ResolutionType] TINYINT NOT NULL DEFAULT(1)
	, [SqlExpr] NVARCHAR(4000) NOT NULL DEFAULT('')
	, [EvalExpr] NVARCHAR(4000) NOT NULL DEFAULT('')
	, [ParamsNumberSqlExpr] TINYINT NOT NULL DEFAULT(0)
	, [ParamsNumberEvalExpr] TINYINT NOT NULL DEFAULT(0)
	, [StartValidDate] DATE NOT NULL
	, [EndValidDate] DATE NOT NULL
	, [IsActive] BIT NOT NULL DEFAULT(1)
	, [CrudAction] TINYINT NOT NULL DEFAULT(1)
	, [CreatedBy] INT NOT NULL DEFAULT(0)
	, [ModifiedBy] INT NOT NULL DEFAULT(0)
	, [DateCreated] DATETIME2(7) NOT NULL DEFAULT(getdate())
	, [DateModified] DATETIME2(7) NOT NULL DEFAULT(getdate())
	, [Ts] TIMESTAMP NOT NULL
	, CONSTRAINT [PK_FormulaVariableSetHistory_Id] PRIMARY KEY([FormulaVariableSetHistoryId])
	, INDEX [IDX_FormulaVariableSetHistory_FormulaVariableSetId_N_N] ([FormulaVariableSetId])
)
;

CREATE TABLE [FormulaVariableHistory]
(
	[FormulaVariableHistoryId] INT NOT NULL IDENTITY(1,1)
	, [FormulaHistoryId] INT NOT NULL
	, [FormulaVariableSetHistoryId] INT NOT NULL
	, [FormulaVariable] INT NOT NULL
	, [FormulaVariableSetId] INT NOT NULL
	, [DefaultValue] NVARCHAR(2000) NOT NULL DEFAULT('')
	, [MinValue] NVARCHAR(50) NOT NULL DEFAULT(0)
	, [MaxValue] VARCHAR(50) NOT NULL DEFAULT(0)
	, [TimePeriod] TINYINT NOT NULL DEFAULT(0)
	, [PeriodStartDate] DATE NOT NULL
	, [PeriodEndDate] DATE NOT NULL
	, [CurrencyCode] NCHAR(3)
	, [CrudAction] TINYINT NOT NULL DEFAULT(1)
	, [CreatedBy] INT NOT NULL DEFAULT(0)
	, [ModifiedBy] INT NOT NULL DEFAULT(0)
	, [DateCreated] DATETIME2(7) NOT NULL DEFAULT(getdate())
	, [DateModified] DATETIME2(7) NOT NULL DEFAULT(getdate()) 
	, [TS] TIMESTAMP NOT NULL
	, CONSTRAINT [FK_FormulaVariableHistory_FormulaHistoryId_FormulaHistory_Id] FOREIGN KEY([FormulaHistoryId]) REFERENCES [FormulaHistory]([FormulaHistoryId])
	, CONSTRAINT [FK_FormulaVariableHistory_FormulaVariableSetHistoryId_FormulaVariableSetHistory_Id] FOREIGN KEY([FormulaVariableSetHistoryId]) REFERENCES [FormulaVariableSetHistory]([FormulaVariableSetHistoryId])
	, INDEX [IDX_FormulaVariableHistory_FormulaVariableId_N_N] ([FormulaVariable])
	, INDEX [IDX_FormulaVariableHistory_FormulaVariableSetId_N_N] ([FormulaVariableSetId])
	, CONSTRAINT [PK_FormulaVariableHistory_Id] PRIMARY KEY([FormulaVariableHistoryId])
)
;

CREATE TABLE [FormulaVariableParamHistory]
(
	[FormulaVariableParamHistoryId] INT NOT NULL IDENTITY(1,1)
	, [FormulaVariableHistoryId] INT NOT NULL
	, [FormulaVariableParamId] INT NOT NULL
	, [ParamName] NVARCHAR(120) NOT NULL DEFAULT('')
	, [FormulaVariableId] INT NOT NULL
	, [DefaultValue] NVARCHAR(4000) NOT NULL DEFAULT('')
	, [CreatedBy] INT NOT NULL DEFAULT(0)
	, [CanoncialDataType] TINYINT NOT NULL DEFAULT(1)
	, [IsOverridenRuntime] BIT NOT NULL DEFAULT(0)
	, [ModifiedBy] INT NOT NULL DEFAULT(0)
	, [CrudAction] TINYINT NOT NULL DEFAULT(1)
	, [DateCreated] DATETIME2(7) NOT NULL DEFAULT(getdate())
	, [DateModified] DATETIME2(7) NOT NULL DEFAULT(getdate()) 
	, [TS] TIMESTAMP NOT NULL
	, CONSTRAINT [FK_FormulaVariableParamHistory_FormulaVariableHistoryId_FormulaVariableHistory_Id] FOREIGN KEY([FormulaVariableHistoryId]) REFERENCES [FormulaVariableHistory]([FormulaVariableHistoryId])
	, CONSTRAINT [PK_FormulaVariableParamHistory_Id] PRIMARY KEY([FormulaVariableParamHistoryId])
	, INDEX [IDX_FormulaVariableParamHistory_FormulaVariableParamId_N_N] ([FormulaVariableParamId])
	, INDEX [IDX_FormulaVariableParamHistory_FormulaVariableId_N_N] ([FormulaVariableId])
)
;

CREATE TABLE [Finance.UnitOfAccount]
(
	[Finance.UnitOfAccount] INT NOT NULL IDENTITY(1,1)
	, [Code] NVARCHAR(20) NOT NULL
	, [Name] NVARCHAR(120) NOT NULL DEFAULT('')
	, [CountryCode] NCHAR(3) NOT NULL
	, [ValidDate] DATE NOT NULL
	, [NumValue] DECIMAL(18,5) NOT NULL DEFAULT(0.00)
	, [CreatedBy] INT NOT NULL DEFAULT(0)
	, [ModifiedBy] INT NOT NULL DEFAULT(0)
	, [DateCreated] DATETIME2(7) NOT NULL DEFAULT(getdate())
	, [DateModified] DATETIME2(7) NOT NULL DEFAULT(getdate()) 
	, [TS] TIMESTAMP NOT NULL
	, CONSTRAINT [PK_UnitOfAccount_Id] PRIMARY KEY ([Finance.UnitOfAccount])
)
;