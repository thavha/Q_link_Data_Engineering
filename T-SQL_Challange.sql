/******
Author : Thavha Tsiwana
Date    : 27/1/2025
Import CSV files with names that start with daily_fin_*.csv from the folder C:\input\ 
into the tbl_dailyfin table and append data
******/

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'xp_cmdshell', 1;
RECONFIGURE;

DECLARE @FileName NVARCHAR(255);
DECLARE @FilePath NVARCHAR(255) = 'C:\input\';
DECLARE @Command NVARCHAR(MAX);
DECLARE @SQL NVARCHAR(MAX);

IF OBJECT_ID('tempdb..#FileList') IS NOT NULL DROP TABLE #FileList;
CREATE TABLE #FileList (
    FileName NVARCHAR(255)
);

SET @Command = 'DIR ' + @FilePath + 'daily_fin_*.csv /B';
INSERT INTO #FileList (FileName)
EXEC xp_cmdshell @Command;

DELETE FROM #FileList WHERE FileName IS NULL;

DECLARE FileCursor CURSOR FOR SELECT FileName FROM #FileList;
OPEN FileCursor;

FETCH NEXT FROM FileCursor INTO @FileName;

WHILE @@FETCH_STATUS = 0
BEGIN

    SET @SQL = '
        BULK INSERT tbl_dailyfin
        FROM ''' + @FilePath + @FileName + '''
        WITH (
            FIRSTROW = 2, -- Skip header row, if CSV has one
            FIELDTERMINATOR = '','', -- CSV delimiter
            ROWTERMINATOR = ''\n'', -- Row delimiter
            TABLOCK
        );
    ';
    

    EXEC sp_executesql @SQL;

    FETCH NEXT FROM FileCursor INTO @FileName;
END;

CLOSE FileCursor;
DEALLOCATE FileCursor;
DROP TABLE #FileList;

EXEC sp_configure 'xp_cmdshell', 0;
RECONFIGURE;