view: shawn_ryan_view {

  derived_table: {
    sql:
select  to_number(extract(month from a.date)) as MONTH,
        to_number(extract(year from a.date)) as YEAR,
        CASE
            when trim(lower(a.ad_name)) like '%calps%' then 'AGENCY_WITHIN'
            else 'PURPLE'
        END as PARTNER,
        trim(upper(a.campaign_name)) as CAMPAIGN_NAME,
        sum(coalesce(spend,0)) as SPEND
from analytics.marketing.adspend a
where a.platform = 'FACEBOOK'
    and to_date(a.date) >= '2019-04-01'
    and to_date(a.date) < current_date
group by 1,2,3,4
order by 1;; }

dimension: month {
  description: "Month as integer number"
  type: number
  #type: date_fiscal_month_num
  sql: ${TABLE}.month;;
}

dimension: year {
  description: "year as integer number"
  type: number
  #type: date_fiscal_year
  sql: ${TABLE}.year;;
}

dimension: partner {
  type: string
  sql: ${TABLE}.partner;;
}

dimension: campaign_name {
  type: string
  sql: ${TABLE}.campaign_name;;
}

measure: spend {
  type: number
  value_format: "$0.00"
  sql: ${TABLE}.campaign_name;;
}

dimension: primary_key{
  primary_key: yes
  hidden:  yes
  type: string
  sql: CONCAT(${TABLE}.spend, ${TABLE}.campaign_name, ${TABLE}.partner) ;;
  #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
}


}
