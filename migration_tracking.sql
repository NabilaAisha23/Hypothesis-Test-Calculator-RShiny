with get_pijar as (
    select
        fsh.prequal_submission_date,
        fsh.registration_date,
        fsh.qualified_date,
        dl.loan_system_id,
        db.borrower_name,
        db.borrower_email,
        db.borrower_phone_number,
        dl.loan_requested_limit,
        dl.loan_limit
    from {{ ref('fact_referred') }} as fr
    left join {{ ref('fact_stage_histories') }} as fsh on fr.loan_key = fsh.loan_key
    left join {{ ref('dim_borrower') }} as db on fsh.borrower_key = db.borrower_key
    left join {{ ref('dim_loan') }} as dl on fsh.loan_key = dl.loan_key
    where
        referral_code in ('INFINID-GROUP', 'INFINID-GROUP2')
        and dl.loan_system_id is not null
),

get_infinid as (
    select
        fst.prequal_submission_date,
        fst.registration_date,
        fst.qualified_date,
        bdl.loan_heloc_id,
        bdb.borrower_email,
        bdb.borrower_phone_number,
        bdl.loan_requested_limit,
        bdl.loan_limit
    from {{ ref('int_bq_fact_stage_histories') }} as fst
    left join {{ ref('int_bq_dim_loan') }} as bdl on fst.loan_key = bdl.loan_key
    left join {{ ref('int_bq_dim_borrower') }} as bdb on fst.borrower_key = bdb.borrower_key
),

join_ip as (
    select
        gp.loan_system_id as loan_id_pijar,
        gi.loan_heloc_id as loan_id_infinid,
        gi.registration_date as registration_date_infinid,
        gi.prequal_submission_date as prequal_submission_date_infinid,
        gi.qualified_date as qualified_date_infinid,
        gp.registration_date as registration_date_pijar,
        gp.prequal_submission_date as prequal_submission_date_pijar,
        gp.qualified_date as qualified_date_pijar,
        gp.borrower_name,
        gp.borrower_email,
        gp.borrower_phone_number,
        gp.loan_requested_limit as loan_requested_amount_pijar,
        gp.loan_limit as loan_limit_pijar,
        gi.loan_requested_limit as loan_requested_amount_infinid,
        gi.loan_limit as loan_limit_infinid,
        row_number() over (partition by gp.borrower_name, gp.loan_system_id order by gi.prequal_submission_date desc) as rn
    from get_pijar as gp
    left join get_infinid as gi on gp.borrower_email = gi.borrower_email or gp.borrower_phone_number = gi.borrower_phone_number
)

select
    loan_id_pijar,
    loan_id_infinid,
    registration_date_infinid,
    prequal_submission_date_infinid,
    qualified_date_infinid,
    registration_date_pijar,
    prequal_submission_date_pijar,
    qualified_date_pijar,
    borrower_name,
    borrower_email,
    borrower_phone_number,
    loan_requested_amount_pijar,
    loan_limit_pijar,
    loan_requested_amount_infinid,
    loan_limit_infinid
from
    join_ip
where rn = 1
