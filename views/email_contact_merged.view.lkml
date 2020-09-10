view: email_contact_merged {
  derived_table: {
    sql:
      with a as (
        select y.*
        from (
          select z.*
              , row_number () over (partition by email order by created) as rn
          from (
            select 'FKL' as source, import_date::date as created, email, zipcode, gender, null as target_strategy
            from analytics.marketing.find_keep_love
            union
            select 'Fluent' as source, created::date, email, null as zipcode, null as gender, targeting_strategy
            from analytics_stage.marketing_stage.fluent_contact
            union
            select 'MyMove' as source, created::date, email, postal_code as zipcode, null as gender, null as target_strategy
            from analytics.marketing.mymove_contact
            --where created::date >= '2020-03-01'
          ) z
        ) y
        where rn = 1
      ), b as (
          select a.platform,date_trunc(month,date) as month,number_emails,sum(spend),sum(spend)/number_emails as spend
          from analytics.marketing.adspend a
              left join (
                  select source,date_trunc(month,created) as month,count(*) as number_emails
                  from a
                  group by 1,2
              ) c on lower(a.platform) = lower(c.source) and date_trunc(month,a.date) = c.month
          where a.platform in ('MYMOVE','Fluent','FKL')
          group by 1,2,3
      )
      select a.*,b.spend
      from a
          left join b on lower(a.source) = lower(b.platform) and date_trunc(month,a.created) = b.month
    ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    sql:${TABLE}.created ;;
  }
  dimension: email {
    hidden:  no
    label: "Customer Email"
    type: string
    sql: CASE WHEN '{{ _user_attributes['can_view_pii'] }}' = 'yes'
              THEN ${TABLE}.email
              ELSE '**********' || '@' || SPLIT_PART(${TABLE}.email, '@', 2)
            END ;;
  }
  dimension: email_join {
    hidden: yes
    primary_key: yes
    type: string
    sql: ${TABLE}.email ;;
  }
  dimension: source {
    type: string
    sql:  ${TABLE}.source ;;
  }

  dimension: zipcode {
    type: string
    sql:  ${TABLE}.zipcode ;;
  }

  dimension: before {
    label: "Before Netsuite"
    type: yesno
    sql: ${created_date} < nvl(${sales_order.created_date},'2090-01-01') ;;
  }

  dimension: target_strategy {
    type: number
    sql:  ${TABLE}.target_strategy ;;
  }

  measure: spend {
    label: "Adspend"
    description: "Total adspend"
    value_format: "$#,##0"
    type: sum
  }

  measure: count {
    type: count_distinct
    sql: ${email} ;;
  }

  measure: ROAS {
    label: "ROAS"
    description: "Gross Sales / Adspend"
    value_format: "$#,##0.00"
    type: number
    sql: ${sales_order_line_base.total_gross_Amt_non_rounded}/${email_contact_merged.spend} ;;
  }

}
