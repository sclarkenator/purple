view: pilot_daily {
  derived_table: { sql:
    select nvl(s.order_id, s2.order_id) as order_id
    , p.*
from shipping.pilot_daily p
left join sales.sales_order s on s.related_tranid = '#' || p.CONSIGNEE_REF
left join sales.sales_order s2 on p.SHIPPER_REF::string = s2.tranid::string ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension: appointment {
    type: string
    sql: ${TABLE}."APPOINTMENT" ;;
  }

  dimension: appointment_date {
    type: date
    sql: case when ${TABLE}."APPOINTMENT" = 'NULL' then null else left(${TABLE}."APPOINTMENT",10)::date end ;;
  }

  dimension: consignee_city {
    type: string
    sql: ${TABLE}."CONSIGNEE_CITY" ;;
  }

  dimension: consignee_ref {
    type: string
    sql: ${TABLE}."CONSIGNEE_REF" ;;
  }

  dimension_group: entry {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."ENTRY" ;;
  }

  dimension_group: pickup {
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
    sql: ${TABLE}."PICKUP" ;;
  }

  dimension: pieces {
    type: number
    sql: ${TABLE}."PIECES" ;;
  }

  dimension: pilot_shipment_id {
    type: number
    sql: ${TABLE}."PILOT_SHIPMENT_ID" ;;
  }

  dimension_group: pod {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."POD" ;;
  }

  dimension: shipper_city {
    type: string
    sql: ${TABLE}."SHIPPER_CITY" ;;
  }

  dimension: shipper_ref {
    type: string
    sql: ${TABLE}."SHIPPER_REF" ;;
  }

  dimension: signature {
    type: string
    sql: ${TABLE}."SIGNATURE" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension_group: status_ts {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."STATUS_TS" ;;
  }

  dimension: total_charges {
    type: number
    sql: ${TABLE}."TOTAL_CHARGES" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
