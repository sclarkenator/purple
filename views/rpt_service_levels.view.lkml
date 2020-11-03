view: rpt_service_levels {
  sql_table_name: ANALYTICS.CUSTOMER_CARE.RPT_SERVICE_LEVELS
    ;;

dimension: PK {
  hidden: yes
  type: string
  sql: ${TABLE}."CREATED"||${TABLE}."CAMPAIGN_NAME" ;;
}
  dimension: abandons {
    description: "Source: incontact.rpt_service_levels"
    type: string
    sql: ${TABLE}."ABANDONS" ;;
  }

  dimension: avg_inqueue {
    description: "Source: incontact.rpt_service_levels"
    type: number
    sql: ${TABLE}."AVG_INQUEUE" ;;
  }

  dimension: campaign_name {
    description: "Source: incontact.rpt_service_levels"
    type: string
    sql: ${TABLE}."CAMPAIGN_NAME" ;;
  }

  dimension_group: created {
    description: "Source: incontact.rpt_service_levels"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."CREATED" ;;
  }

  measure: count_handled {
    description: "Source: incontact.rpt_service_levels"
    type: sum
    sql: ${TABLE}."HANDLED" ;;
  }

  dimension: pct_callback_requests {
    description: "Source: incontact.rpt_service_levels"
    type: string
    sql: ${TABLE}."PCT_CALLBACK_REQUESTS" ;;
  }

  measure: pct_handled {
    description: "Source: incontact.rpt_service_levels"
    type: string
    sql: ${TABLE}."PCT_HANDLED" ;;
  }

  dimension: queued {
    description: "Source: incontact.rpt_service_levels"
    type: number
    sql: ${TABLE}."QUEUED" ;;
  }

  measure: service_level {
    description: "Source: incontact.rpt_service_levels"
    value_format: "0#.##%"
    type: average
    sql: replace(${TABLE}."SERVICE_LEVEL",'%','')/100 ;;
    }

  measure: count {
    type: count
    drill_fields: [campaign_name]
  }
}
