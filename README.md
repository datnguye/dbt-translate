# dbt-translate
![dbt](https://img.shields.io/badge/dbt-packages-FF694B?logo=dbt&logoColor=FF694B)

✨ Helps to convert **Numbers** to **Words** ✨

<add demo>

Currently supporting:

![dwh](https://img.shields.io/badge/DB-Snowflake-9cf?logo=snowflake&logoColor=white)
![dwh](https://img.shields.io/badge/DB-MSSQL-9cf?logo=microsoftsqlserver&logoColor=white)


![language](https://img.shields.io/badge/language-English(en)-FFCE3E?labelColor=14354C&logo=sql&logoColor=white)

## Installation
```bash
# packages.yml
packages:
  - package: datnguye/dbt-translate
    version: [">=0.1.0", "<1.0.0"]
```

#### Register the common schema where holding the built-in stored procedure:
```yaml
# dbt_project.yml
vars:
  num2words_schema: common_schema # by default it takes `target.schema
```

#### Add on-run-start hook to deploy SPROCs
```yaml
# dbt_project.yml / Add your conidition to hook as you go
on-run-start:
  - >
    {{ dbt_translate.compile_money_to_words() }}
```

## Usage
```sql
# model_something.sql
with test as (
    select 2000 as amount
    union all 
    select 9999 as amount
)
select  amount
        ,{{ dbt_translate.money_to_words('amount', 'en') }} as amount_in_word
from    test
/*
amount  amount_in_word
------  ---------------------------------------
2000    two thousand
9999    nine thousand nine hundred ninety-nine
*/
```

## Contributing ✨
If you've ever wanted to contribute to this tool, and a great cause, feel free to create your Pull Request 💖

Check [CONTRIBUTING.md](https://github.com/datnguye/dbt-translate/blob/main/CONTRIBUTING.md) for more details!