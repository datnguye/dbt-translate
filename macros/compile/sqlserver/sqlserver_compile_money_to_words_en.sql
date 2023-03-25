{% macro sqlserver__compile_money_to_words_en() %}

--======================================================
-- Usage:  Lib: MoneyToWords in English
-- Notes:  It DOES NOT support negative number.
--      Please concat 'negative word' into the result in that case
-- History:
-- Date      Author    Description
-- 2020-09-16  NV      Intial
-- 2020-12-07  DN      Fix odd number
--======================================================
CREATE OR ALTER FUNCTION {{var('num2words_schema', target.schema)}}.MoneyToWords_EN(@Number DECIMAL(17,2))
RETURNS NVARCHAR(MAX)
AS
BEGIN
  SET @Number = ABS(@Number)
  DECLARE @vResult NVARCHAR(MAX) = ''

  -- pre-data
  DECLARE @tDict    TABLE (Num INT NOT NULL, Nam NVARCHAR(255) NOT NULL)
  INSERT
  INTO  @tDict (Num, Nam)
  VALUES  (1,'one'),(2,'two'),(3,'three'),(4,'four'),(5,'five'),(6,'six'),(7,'seven'),(8,'eight'),(9,'nine'),
          (10,'ten'),(11,'eleven'),(12,'twelve'),(13,'thirteen'),(14,'fourteen'),(15,'fifteen'),(16,'sixteen'),(17,'seventeen'),(18,'eighteen'),(19,'nineteen'),
          (20,'twenty'),(30,'thirty'),(40,'fourty'),(50,'fifty'),(60,'sixty'),(70,'seventy'),(80,'eighty'),(90,'ninety')

  DECLARE @ZeroWord       NVARCHAR(10) = 'zero'
  DECLARE @DotWord        NVARCHAR(10) = 'point'
  DECLARE @AndWord        NVARCHAR(10) = 'and'
  DECLARE @HundredWord    NVARCHAR(10) = 'hundred'
  DECLARE @ThousandWord   NVARCHAR(10) = 'thousand'
  DECLARE @MillionWord    NVARCHAR(10) = 'million'
  DECLARE @BillionWord    NVARCHAR(10) = 'billion'
  DECLARE @TrillionWord   NVARCHAR(10) = 'trillion'

  -- decimal number
  DECLARE @vDecimalNum INT = (@Number - FLOOR(@Number)) * 100
  DECLARE @vLoop SMALLINT = CONVERT(SMALLINT, SQL_VARIANT_PROPERTY(@Number, 'Scale'))
  DECLARE @vSubDecimalResult  NVARCHAR(MAX) = N''
  IF @vDecimalNum > 0
  BEGIN
    WHILE @vLoop > 0
    BEGIN
      IF @vDecimalNum % 10 = 0
        SET @vSubDecimalResult = FORMATMESSAGE('%s %s', @ZeroWord, @vSubDecimalResult)
      ELSE
        SELECT  @vSubDecimalResult = FORMATMESSAGE('%s %s', Nam, @vSubDecimalResult)
        FROM  @tDict
        WHERE  Num = @vDecimalNum%10

      SET @vDecimalNum = FLOOR(@vDecimalNum/10)
      SET @vLoop = @vLoop - 1
    END
  END

  -- main number
  SET @Number = FLOOR(@Number)
  IF @Number = 0
    SET @vResult = @ZeroWord
  ELSE
  BEGIN
    DECLARE @vSubResult  NVARCHAR(MAX) = ''
    DECLARE @v000Num DECIMAL(15,0) = 0
    DECLARE @v00Num DECIMAL(15,0) = 0
    DECLARE @v0Num DECIMAL(15,0) = 0
    DECLARE @vIndex SMALLINT = 0

    WHILE @Number > 0
    BEGIN
      -- from right to left: take first 000
      SET @v000Num = @Number % 1000
      SET @v00Num = @v000Num % 100
      SET @v0Num = @v00Num % 10
      IF @v000Num = 0
      BEGIN
        SET @vSubResult = ''
      END
      ELSE
      BEGIN
        --00
        IF @v00Num < 20
        BEGIN
          -- less than 20
          SELECT @vSubResult = Nam FROM @tDict WHERE Num = @v00Num
          IF @v00Num < 10 AND @v00Num > 0 AND (@v000Num > 99 OR FLOOR(@Number / 1000) > 0)--e.g 1 001: 1000 AND 1; or 201 000: (200 AND 1) 000
            SET @vSubResult = FORMATMESSAGE('%s %s', @AndWord, @vSubResult)
        END
        ELSE
        BEGIN
          -- greater than or equal 20
          SELECT @vSubResult = Nam FROM @tDict WHERE Num = @v0Num
          SET @v00Num = FLOOR(@v00Num/10)*10
          SELECT @vSubResult = FORMATMESSAGE('%s-%s', Nam, @vSubResult) FROM @tDict WHERE Num = @v00Num
        END

        --000
        IF @v000Num > 99
          SELECT @vSubResult = FORMATMESSAGE('%s %s %s', Nam, @HundredWord, @vSubResult) FROM @tDict WHERE Num = CONVERT(INT,@v000Num / 100)
      END

      --000xxx
      IF @vSubResult <> ''
      BEGIN

        SET @vSubResult = FORMATMESSAGE('%s %s', @vSubResult, CASE
                                    WHEN @vIndex=1 THEN @ThousandWord
                                    WHEN @vIndex=2 THEN @MillionWord
                                    WHEN @vIndex=3 THEN @BillionWord
                                    WHEN @vIndex=4 THEN @TrillionWord
                                    WHEN @vIndex>3 AND @vIndex%3=2 THEN @MillionWord + ' ' + TRIM(REPLICATE(@BillionWord + ' ',@vIndex%3))
                                    WHEN @vIndex>3 AND @vIndex%3=0 THEN TRIM(REPLICATE(@BillionWord + ' ',@vIndex%3))
                                    ELSE ''
                                  END)

        SET @vResult = FORMATMESSAGE('%s %s', @vSubResult, @vResult)
      END

      -- next 000 (to left)
      SET @vIndex = @vIndex + 1
      SET @Number = FLOOR(@Number / 1000)
    END
  END

  SET @vResult = FORMATMESSAGE('%s %s', TRIM(@vResult), COALESCE(@DotWord + ' ' + NULLIF(@vSubDecimalResult,''), ''))
  SET @vResult = REPLACE(@vResult, '  ', ' ')

  -- result
    RETURN @vResult
END

{% endmacro %}