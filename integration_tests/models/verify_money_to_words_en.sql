with data as (
  select  3201001.25 as input
          ,'three million two hundred and one thousand and one point two five' as expected
  union all
  select  123456789.56 as input
          ,'one hundred twenty-three million four hundred fifty-six thousand seven hundred eighty-nine point five six' as expected
  union all
  select  123000789.56 as input
          ,'one hundred twenty-three million seven hundred eighty-nine point five six' as expected
  union all
  select  123010789.56 as input
          ,'one hundred twenty-three million ten thousand seven hundred eighty-nine point five six' as expected
  union all
  select  123004789.56 as input
          ,'one hundred twenty-three million and four thousand seven hundred eighty-nine point five six' as expected
  union all
  select  123904789.56 as input
          ,'one hundred twenty-three million nine hundred and four thousand seven hundred eighty-nine point five six' as expected
  union all
  select  205.56 as input
          ,'two hundred and five point five six' as expected
  union all
  select  45.1 as input
          ,'fourty-five point one zero' as expected
  union all
  select  45.09 as input
          ,'fourty-five point zero nine' as expected
  union all
  select  0.09 as input
          ,'zero point zero nine' as expected
  union all
  select  1234567896789.02 as input
          ,'one trillion two hundred thirty-four billion five hundred sixty-seven million eight hundred ninety-six thousand seven hundred eighty-nine point zero two' as expected
  union all
  select  1234567896789.52 as input
          ,'one trillion two hundred thirty-four billion five hundred sixty-seven million eight hundred ninety-six thousand seven hundred eighty-nine point five two' as expected
  union all
  select  123234567896789.02 as input
          ,'one hundred twenty-three trillion two hundred thirty-four billion five hundred sixty-seven million eight hundred ninety-six thousand seven hundred eighty-nine point zero two' as expected
  union all
  select  999999999999999.99 as input
          ,'nine hundred ninety-nine trillion nine hundred ninety-nine billion nine hundred ninety-nine million nine hundred ninety-nine thousand nine hundred ninety-nine point nine nine' as expected
  union all
  select  100000000000000 as input
          ,'one hundred trillion' as expected
)

select  {{ dbt_translate.money_to_words('input', 'en') }} as actual,
        *
from    data