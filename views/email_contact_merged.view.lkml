view: email_contact_merged {
  derived_table: {
    sql:
      select y.*
      from (
        select z.*
            , row_number () over (partition by email order by created) as rn
        from (
          select 'FKL' as source, import_date::date as created, email, zipcode, gender, null as target_strategy
          from analytics_stage.marketing_stage.fkl_contact
          union
          select 'Fluent' as source, created::date, email, null as zipcode, null as gender, targeting_strategy
          from analytics_stage.marketing_stage.fluent_contact
          union
          select 'MyMove' as source, created::date, email, postal_code as zipcode, null as gender, null as target_strategy
          from analytics.marketing.mymove_contact
        ) z
      ) y
      where rn = 1
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
    type: string
    primary_key: yes
    sql:  ${TABLE}.email ;;
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

  measure: count {
    type: count_distinct
    sql: ${email} ;;
  }

}
