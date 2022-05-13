view: rf_log {
  sql_table_name: "HIGHJUMP"."RF_LOG"
    ;;

  dimension: row_id {
    type: string
    hidden: yes
    primary_key: yes
    sql: ${TABLE}."ROW_ID" ;;
  }

  dimension: action {
    type: string
    sql: ${TABLE}."ACTION" ;;
  }

  dimension: bin_label {
    type: string
    sql: ${TABLE}."BIN_LABEL" ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: license_plate {
    type: string
    sql: ${TABLE}."LICENSE_PLATE" ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}."LOCATION" ;;
  }

  dimension: note_1 {
    type: string
    sql: ${TABLE}."NOTE_1" ;;
  }

  dimension: note_2 {
    type: string
    sql: ${TABLE}."NOTE_2" ;;
  }

  dimension: pack_slip {
    type: string
    sql: ${TABLE}."PACK_SLIP" ;;
  }

  dimension: po_number {
    type: string
    sql: ${TABLE}."PO_NUMBER" ;;
  }

  dimension: q_scaler {
    type: number
    sql: ${TABLE}."Q_SCALER" ;;
  }


  dimension: quantity_dim {
    type: number
    sql: ${TABLE}."QUANTITY" ;;
  }

  measure: quantity {
    type: sum
    sql: ${TABLE}."QUANTITY" ;;
  }


  dimension: sku {
    type: string
    sql: ${TABLE}."SKU" ;;
  }

  dimension: tot_label {
    type: string
    sql: ${TABLE}."TOT_LABEL" ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}."USER_ID" ;;
  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: []
  }
}
