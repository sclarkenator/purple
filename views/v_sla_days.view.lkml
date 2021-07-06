view: v_sla_days {
  sql_table_name: "SHIPPING"."V_SLA_DAYS"
    ;;

  dimension: sla_date {
    type: date
    hidden: yes
    convert_tz: no
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: description {
    hidden: yes
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.item_id||'-'||${TABLE}.sla_date ;;
  }

  dimension: item_id {
    hidden: yes
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: sla {
    description: "Wordy description of sla range"
    hidden: yes
    type: string
    sql: ${TABLE}."SLA" ;;
  }

  dimension: sla_days {
    label: "SLA days"
    group_label: " Advanced"
    description: "Expected SLA days, based on what was stated on site at time of order"
    type: number
    sql: ${TABLE}."SLA_DAYS" ;;
  }

}
