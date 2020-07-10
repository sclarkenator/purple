view: pilot_daily {
  derived_table: { sql:
    select t.*
from (select nvl(s.order_id, s2.order_id) as order_id
    , sol.item_id
    , p.hd_status_created as status_date
    , p.*
    , row_number() over(partition by s.order_id, sol.item_id order by p.hd_status_created::date desc) as rn
    from shipping.pilot_daily p
    left join sales.sales_order s on s.related_tranid = '#' || p.CONSIGNEE_REF
    left join sales.sales_order s2 on p.SHIPPER_REF::string = s2.tranid::string
    left join sales.sales_order_line sol on nvl(s.order_id, s2.order_id) = sol.order_id) as t
    where rn = 1;;
  }

  dimension: order_id {
    hidden: yes
    group_label: "Pilot Info"
    description: "Source:pilot.pilot_daily"
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension: appointment {
    hidden: yes
    group_label: "Pilot Info"
    description: "Source:pilot.pilot_daily"
    type: string
    sql: ${TABLE}."APPOINTMENT" ;;
  }

  dimension: appointment_date {
    group_label: "Pilot Info"
    description: "Pilot Appointment Date. Source:pilot.pilot_daily"
    type: date
    sql: case when ${TABLE}."APPOINTMENT" = 'NULL' then null else left(${TABLE}."APPOINTMENT",10)::date end ;;
  }

  dimension: consignee_city {
    hidden: yes
    group_label: "Pilot Info"
    description: "Source:pilot.pilot_daily"
    type: string
    sql: ${TABLE}."CONSIGNEE_CITY" ;;
  }

  dimension: consignee_ref {
    hidden: yes
    group_label: "Pilot Info"
    description: "Source:pilot.pilot_daily"
    type: string
    sql: ${TABLE}."CONSIGNEE_REF" ;;
  }

  dimension_group: entry {
    hidden: yes
    label: "Pilot Entry Date"
    description: "Source:pilot.pilot_daily"
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
    hidden: yes
    label: "Pilot Pickup Date"
    description: "Source:pilot.pilot_daily"
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
    group_label: "Pilot Info"
    description: "Number of Pieces. Source:pilot.pilot_daily"
    type: number
    sql: ${TABLE}."PIECES" ;;
  }

  dimension: pilot_shipment_id {
    group_label: "Pilot Info"
    description: "Pilot Shipment ID. Source:pilot.pilot_daily"
    type: number
    sql: ${TABLE}."PILOT_SHIPMENT_ID" ;;
  }

  dimension_group: pod {
    hidden: yes
    label: "Pilot POD Date"
    description: "Source:pilot.pilot_daily"
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
    group_label: "Pilot Info"
    description: "Shipper City Name. Source:pilot.pilot_daily"
    type: string
    sql: ${TABLE}."SHIPPER_CITY" ;;
  }

  dimension: shipper_ref {
    group_label: "Pilot Info"
    description: "Shipper Reference ID. Source:pilot.pilot_daily"
    type: string
    sql: ${TABLE}."SHIPPER_REF" ;;
  }

  dimension: signature {
    hidden: yes
    group_label: "Pilot Info"
    description: "Source:pilot.pilot_daily"
    type: string
    sql: ${TABLE}."SIGNATURE" ;;
  }

  dimension: status {
    group_label: "Pilot Info"
    description: "Delivery Status. Source:pilot.pilot_daily"
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension_group: status_ts {
    hidden: yes
    group_label: "Pilot Info"
    description: "Source:pilot.pilot_daily"
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
    group_label: "Pilot Info"
    description: "Total Number of Charges. Source:pilot.pilot_daily"
    type: number
    sql: ${TABLE}."TOTAL_CHARGES" ;;
  }

  dimension: hd_status {
    group_label: "Pilot Info"
    description: "HD Status. Source:pilot.pilot_daily"
    type: string
    sql: ${TABLE}."HD_STATUS" ;;
  }

  dimension_group: hd_status_created {
    label: "Date HD Status Changed"
    description: "Last status change in the Pilot data. Source:pilot.pilot_daily"
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
    sql: ${TABLE}."HD_STATUS_CREATED" ;;
  }

  measure: count {
    group_label: "Pilot Info"
    description: "Source:pilot.pilot_daily"
    type: count
    drill_fields: []
  }
}
