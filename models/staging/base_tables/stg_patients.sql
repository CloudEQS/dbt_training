{{
    config(
        tags=['mdl_daily']
    )
}}

with source as (
    select * from {{ source('raw', 'patients') }}
),

deduped as (
    select *,
        row_number() over (
            partition by 
                coalesce(IDENTIFIER_0_VALUE, 'NA'),
                coalesce(NAME_0_FAMILY, 'NA'),
                coalesce(BIRTHDATE, '1900-01-01')
            order by LOAD_DATE desc
        ) as rn
    from source
),

final as (
    select
        /* surrogate key */
        case 
            when IDENTIFIER_0_VALUE is null 
             and NAME_0_FAMILY is null 
             and BIRTHDATE is null
            then cast(row_number() over () as varchar)   
            else {{ dbt_utils.generate_surrogate_key([
                'IDENTIFIER_0_VALUE',
                'NAME_0_FAMILY',
                'BIRTHDATE'
            ]) }}
        end as patient_id

        , NAME_0_FAMILY as last_name
        , NAME_0_GIVEN_0 as first_name
        , GENDER
        , BIRTHDATE
        , TELECOM_0_VALUE as phone

        , ADDRESS_0_CITY as city
        , ADDRESS_0_STATE as state
        , ADDRESS_0_COUNTRY as country

        , cast(current_timestamp as timestamp) as dbt_last_refreshed_timestamp

    from deduped
    where rn = 1
)

select * from final