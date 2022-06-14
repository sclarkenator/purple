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

  measure: expected {
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}."EXPECTED" ;;
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
    value_format: "#,##0"
    description: "Matches raw quantity field from RF Logs - means something different for different actions."
    hidden: yes
    sql: ${TABLE}."QUANTITY" ;;
  }

  measure: quantity_counted {
    type: sum
    value_format: "#,##0"
    sql: case when action in ('CYCL-CPL','CYCL-OK') then ${TABLE}."QUANTITY"
              when action = 'CYCL-ADJ' then ${TABLE}."EXPECTED"+ (${TABLE}."Q_SCALER"*${TABLE}."QUANTITY")
              else 0 end;;
  }

  measure: amount_counted {
    type: sum
    value_format: "$#,##0"
    sql: (case when action in ('CYCL-CPL','CYCL-OK') then ${TABLE}."QUANTITY"
              when action = 'CYCL-ADJ' then ${TABLE}."EXPECTED"+ (${TABLE}."Q_SCALER"*${TABLE}."QUANTITY")
              else 0 end) * ${standard_cost_direct_materials.dm_standard_cost} ;;
  }

  measure: adjustment_quantity{
    type: sum
    value_format: "#,##0"
    sql: (case when action = 'CYCL-ADJ' then ${TABLE}."Q_SCALER"*${TABLE}."QUANTITY"
      else 0 end) ;;
  }

  measure: adjustment_amount {
    type: sum
    value_format: "$#,##0"
    sql: (case when action = 'CYCL-ADJ' then ${TABLE}."Q_SCALER"*${TABLE}."QUANTITY"
              else 0 end) * ${standard_cost_direct_materials.dm_standard_cost} ;;
  }

  measure: bin_label_count {
    type: count
    hidden: yes
    sql: ${TABLE}."BIN_LABEL" ;;
  }

  measure: adjustment_count {
    type: count
    filters: [action: "CYCL-ADJ"]
    sql: ${TABLE}."BIN_LABEL";;
  }

  measure: distinct_bin_count {
    type: count_distinct
    sql: ${TABLE}."BIN_LABEL";;
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
