{% macro default__compile_money_to_words_en() %}
{#-- Due to the ROUND issue within Snowflake e.g. 999 999 999 999 999.99 will become 1 000 000 000 000 000
  --> Split the number into 2 params: money (without decimal) & the value with decimal only
      e.g.  money = 999 999 999 999 999
            scale_value = 0.99  #}
create or replace function {{var('num2words_schema', target.schema)}}.MoneyToWords_EN (money double, scale_value double)
returns varchar
language javascript
strict
as
$$
  let vResult = '';

  let tDict = {
    1:'one',2:'two',3:'three',4:'four',5:'five',6:'six',7:'seven',8:'eight',9:'nine',
    10:'ten',11:'eleven',12:'twelve',13:'thirteen',14:'fourteen',15:'fifteen',16:'sixteen',17:'seventeen',18:'eighteen',19:'nineteen',
    20:'twenty',30:'thirty',40:'fourty',50:'fifty',60:'sixty',70:'seventy',80:'eighty',90:'ninety'
  };

  let ZeroWord = 'zero'
  let DotWord = 'point'
  let AndWord = 'and'
  let HundredWord = 'hundred'
  let ThousandWord = 'thousand'
  let MillionWord = 'million'
  let BillionWord = 'billion'
  let TrillionWord = 'trillion'

  //--decimal number
  let vDecimalNum = Math.round((SCALE_VALUE - Math.floor(SCALE_VALUE)) * 100);
  let vLoop = 2;
  let vSubDecimalResult = ''
  if (vDecimalNum > 0) {
    while (vLoop > 0) {
      if (vDecimalNum % 10 == 0){
        vSubDecimalResult = ZeroWord + ' ' + vSubDecimalResult
      }
      else {
        vSubDecimalResult = (tDict[vDecimalNum%10]) + ' ' + vSubDecimalResult
      }

      vDecimalNum = Math.floor(vDecimalNum/10)
      vLoop = vLoop - 1
    }
  }

  //--main number
  let Number = Math.abs(MONEY);
  if (Number == 0){
    vResult = ZeroWord
  }
  else{
    let vSubResult = ''
    let v000Num = 0
    let v00Num = 0
    let v0Num = 0
    let vIndex = 0

    while (Number > 0){
      //-- from right to left: take first 000
      v000Num = Number % 1000
      v00Num = v000Num % 100
      v0Num = v00Num % 10
      if (v000Num == 0){
        vSubResult = ''
      }
      else{
        //--00
        if (v00Num < 20){
          //-- less than 20
          vSubResult = tDict[v00Num]
          if (v00Num < 10 && v00Num > 0 && (v000Num > 99 || Math.floor(Number / 1000) > 0)){//--e.g 1 001: 1000 AND 1; or 201 000: (200 AND 1) 000
            vSubResult = AndWord + ' ' + vSubResult
          }
        }
        else {
          //-- greater than or equal 20
          vSubResult = tDict[v0Num]
          v00Num = Math.round(Math.floor(v00Num/10)*10)
          vSubResult = tDict[v00Num] + (
            vSubResult != undefined ? '-' + vSubResult : ''
          )
        }

        //--000
        if (v000Num > 99){
          vSubResult = tDict[Math.round(Math.floor(v000Num / 100))] + ' ' + HundredWord + (vSubResult != undefined ? ' ' + vSubResult : '')
        }
      }

      //--000xxx
      if (vSubResult != '' && vSubResult != undefined){
        vSubResult = vSubResult + ' '
                    + (vIndex == 1 ? ThousandWord : (
                        vIndex == 2 ? MillionWord : (
                        vIndex == 3 ? BillionWord : (
                        vIndex == 4 ? TrillionWord : (
                        vIndex > 3 && vIndex%3 == 2 ? MillionWord + ' ' + (BillionWord + ' ').repeat(vIndex%3).trim() : (
                        vIndex > 3 && vIndex%3 == 0 ? (BillionWord + ' ').repeat(vIndex%3).trim() : ''
                      ))))))

        vResult = vSubResult + ' ' + vResult
      }

      //-- next 000 (to left)
      vIndex = vIndex + 1
      Number = Math.round(Math.floor(Number / 1000))
    }
  }

  vResult = vResult.trim() + ' ' + (
    vSubDecimalResult != '' ? DotWord + ' ' + vSubDecimalResult : ''
  )
  return vResult.trim();
$$

{% endmacro %}