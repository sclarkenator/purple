view: rpt_agent_stats {
  sql_table_name: CUSTOMER_CARE.RPT_AGENT_STATS ;;

  dimension: pk {
    type: string
    hidden: yes
    primary_key: yes
    sql: ${TABLE}."AGENT" || ${TABLE}."REPORTED" ;;
  }

  dimension: agent {
    type: string
    sql: ${TABLE}."AGENT" ;;
  }

  dimension: avg_acw_dim {
    type: number
    hidden: yes
    sql: ${TABLE}."AVG_ACW" ;;
  }

  dimension: avg_handle_dim {
    type: number
    hidden: yes
    sql: ${TABLE}."AVG_HANDLE" ;;
  }

  dimension: avg_hold_dim {
    type: number
    hidden: yes
    sql: ${TABLE}."AVG_HOLD" ;;
  }

  dimension: avg_talk_dim {
    type: number
    hidden: yes
    sql: ${TABLE}."AVG_TALK" ;;
  }

  dimension: handled_dim {
    type: number
    hidden: yes
    sql: ${TABLE}."HANDLED" ;;
  }

  dimension: transferred_dim {
    type: number
    hidden: yes
    sql: ${TABLE}."TRANSFERRED" ;;
  }

  dimension: unavailable_dim {
    type: number
    hidden: yes
    sql: ${TABLE}."UNAVAILABLE" ;;
  }

  measure: avg_acw {
    type: sum
    sql: ${TABLE}."AVG_ACW" ;;
  }

  measure: avg_handle {
    type: sum
    sql: ${TABLE}."AVG_HANDLE" ;;
  }

  measure: avg_hold {
    type: sum
    sql: ${TABLE}."AVG_HOLD" ;;
  }

  measure: avg_talk {
    type: sum
    sql: ${TABLE}."AVG_TALK" ;;
  }

  measure: handled {
    type: sum
    sql: ${TABLE}."HANDLED" ;;
  }

  measure: transferred {
    type: sum
    sql: ${TABLE}."TRANSFERRED" ;;
  }

  measure: unavailable {
    type: sum
    sql: ${TABLE}."UNAVAILABLE" ;;
  }

  dimension_group: insert_ts {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."INSERT_TS" ;;
  }

  dimension_group: reported {
    type: time
    description: "The date the interaction happened. Limited to just days because the data is coming in as averages and we don't want to sum or average the averages across time"
    timeframes: [
      raw,
      date ##,
      ##week,
      ##month,
      ##quarter,
      ##year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."REPORTED" ;;
  }



  measure: count {
    type: count
    drill_fields: []
  }
}
