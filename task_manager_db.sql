-- Создание базы данных
CREATE DATABASE TaskManagerDB;
GO

USE TaskManagerDB;
GO

-- Таблица задач
CREATE TABLE Tasks (
    TaskID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(500),
    IsCompleted BIT DEFAULT 0,
    CreatedAt DATETIME2 DEFAULT GETDATE()
);
GO

-- Тестовые данные
INSERT INTO Tasks (Title, Description, IsCompleted)
VALUES 
    (N'Изучить Delphi REST', N'Разобраться с DataSnap', 0),
    (N'Настроить IIS', N'Развернуть сервер на локальной машине', 1);
GO
