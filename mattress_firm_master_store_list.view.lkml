view: mattress_firm_master_store_list {
  sql_table_name: mattress_firm.master_store_list ;;

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: store_id {
    type: number
    primary_key: yes
    sql: ${TABLE}."STORE_ID" ;;
  }

  dimension: market {
    type: string
    sql: ${TABLE}."MARKET" ;;
  }

  dimension: store_name {
    type: string
    sql: ${TABLE}."STORE_NAME" ;;
  }

  dimension: address {
    type: string
    sql: ${TABLE}."ADDRESS" ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: state_name {
    type: string
    sql: ${TABLE}."STATE_NAME" ;;
  }

  dimension: city_state {
    type: string
    sql: ${TABLE}."CITY" ||', ' ||  ${TABLE}."STATE_NAME";;
  }

  dimension: zip {
    type: string
    sql: ${TABLE}."ZIP" ;;
  }

  dimension: store_phone {
    type: string
    sql: ${TABLE}."STORE_PHONE" ;;
  }

  dimension: number_of_beds {
    type: string
    sql: ${TABLE}."NUMBER_OF_BEDS" ;;
  }

  dimension: bed_type {
    type: string
    sql: ${TABLE}."BED_TYPE" ;;
  }

  dimension: store_notes {
    type: string
    sql: ${TABLE}."STORE_NOTES" ;;
  }

  dimension: store_dm {
    type: string
    sql: ${TABLE}."STORE_DM" ;;
  }

  dimension: store_rvp {
    type: string
    sql: ${TABLE}."STORE_RVP" ;;
  }

  dimension: store_phase {
    type: string
    sql: ${TABLE}."STORE_PHASE" ;;
  }

  dimension: additional_items {
    type: string
    sql: ${TABLE}."ADDITIONAL_ITEMS" ;;
  }

  dimension: open_date {
    type: date
    sql: ${TABLE}."OPEN_DATE" ;;
  }

  dimension: end_date {
    type: date
    sql: ${TABLE}."END_DATE" ;;
  }

  dimension: open_weeks {
    type: number
    sql: case when ${TABLE}."END_DATE" is null then datediff('week' ,${TABLE}."OPEN_DATE", current_date())
         else datediff('week' ,${TABLE}."OPEN_DATE", ${TABLE}."END_DATE") end ;;
  }

  dimension: open_days {
    type: number
    sql: case when ${TABLE}."END_DATE" is null then datediff('day' ,${TABLE}."OPEN_DATE", current_date())
         else datediff('day' ,${TABLE}."OPEN_DATE", ${TABLE}."END_DATE") end  ;;
  }

  dimension: open_months {
    type: number
    sql: case when ${TABLE}."END_DATE" is null then datediff('month' ,${TABLE}."OPEN_DATE", current_date())
         else datediff('month' ,${TABLE}."OPEN_DATE", ${TABLE}."END_DATE") end ;;
  }

  dimension: models {
    type: number
    sql: ${TABLE}."MODELS" ;;
  }

  set: detail {
    fields: [
      store_id,
      market,
      store_name,
      address,
      city,
      state_name,
      zip,
      store_phone,
      number_of_beds,
      bed_type,
      store_notes,
      store_dm,
      store_rvp,
      store_phase,
      additional_items,
      open_date,
      end_date,
      models
    ]
  }
}
