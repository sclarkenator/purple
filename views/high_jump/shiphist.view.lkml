view: shiphist {
  sql_table_name: "HIGHJUMP"."SHIPHIST"
    ;;

  dimension: all_picked {
    type: yesno
    sql: ${TABLE}."ALL_PICKED" ;;
  }

  dimension: all_repkd {
    type: yesno
    sql: ${TABLE}."ALL_REPKD" ;;
  }

  dimension: alloc_1 {
    type: yesno
    sql: ${TABLE}."ALLOC_1" ;;
  }

  dimension: alloc_2 {
    type: yesno
    sql: ${TABLE}."ALLOC_2" ;;
  }

  dimension: alloc_opts {
    type: string
    sql: ${TABLE}."ALLOC_OPTS" ;;
  }

  dimension: assembly {
    type: yesno
    sql: ${TABLE}."ASSEMBLY" ;;
  }

  dimension: bill_address {
    type: string
    sql: ${TABLE}."BILL_ADDRESS" ;;
  }

  dimension: bill_city {
    type: string
    sql: ${TABLE}."BILL_CITY" ;;
  }

  dimension: bill_cntry {
    type: string
    sql: ${TABLE}."BILL_CNTRY" ;;
  }

  dimension: bill_name {
    type: string
    sql: ${TABLE}."BILL_NAME" ;;
  }

  dimension: bill_prov {
    type: string
    sql: ${TABLE}."BILL_PROV" ;;
  }

  dimension: bill_zip {
    type: string
    sql: ${TABLE}."BILL_ZIP" ;;
  }

  dimension: binlabel {
    type: string
    sql: ${TABLE}."BINLABEL" ;;
  }

  dimension_group: cancelled {
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
    sql: ${TABLE}."CANCELLED" ;;
  }

  dimension: channel_id {
    type: number
    sql: ${TABLE}."CHANNEL_ID" ;;
  }

  dimension: cost_ship {
    type: number
    sql: ${TABLE}."COST_SHIP" ;;
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
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: cust_ltype {
    type: string
    sql: ${TABLE}."CUST_LTYPE" ;;
  }

  dimension: cust_po {
    type: string
    sql: ${TABLE}."CUST_PO" ;;
  }

  dimension: customer_id {
    type: number
    sql: ${TABLE}."CUSTOMER_ID" ;;
  }

  dimension: due_in {
    type: number
    sql: ${TABLE}."DUE_IN" ;;
  }

  dimension: end_of_line {
    type: number
    sql: ${TABLE}."END_OF_LINE" ;;
  }

  dimension: err_msg {
    type: string
    sql: ${TABLE}."ERR_MSG" ;;
  }

  dimension: fill_rate {
    type: number
    sql: ${TABLE}."FILL_RATE" ;;
  }

  dimension: first_pick {
    type: string
    sql: ${TABLE}."FIRST_PICK" ;;
  }

  dimension: fulfilled_status {
    type: string
    sql: ${TABLE}."FULFILLED_STATUS" ;;
  }

  dimension: handle {
    type: string
    sql: ${TABLE}."HANDLE" ;;
  }

  dimension: held_short {
    type: yesno
    sql: ${TABLE}."HELD_SHORT" ;;
  }

  dimension: instructions {
    type: string
    sql: ${TABLE}."INSTRUCTIONS" ;;
  }

  dimension: inv_amount {
    type: number
    sql: ${TABLE}."INV_AMOUNT" ;;
  }

  dimension: is_nuked {
    type: yesno
    sql: ${TABLE}."IS_NUKED" ;;
  }

  dimension: is_print2 {
    type: yesno
    sql: ${TABLE}."IS_PRINT2" ;;
  }

  dimension: is_print3 {
    type: yesno
    sql: ${TABLE}."IS_PRINT3" ;;
  }

  dimension: is_print4 {
    type: yesno
    sql: ${TABLE}."IS_PRINT4" ;;
  }

  dimension: is_printed {
    type: yesno
    sql: ${TABLE}."IS_PRINTED" ;;
  }

  dimension: is_shipped {
    type: yesno
    sql: ${TABLE}."IS_SHIPPED" ;;
  }

  dimension: is_started {
    type: yesno
    sql: ${TABLE}."IS_STARTED" ;;
  }

  dimension: lb_customer {
    type: yesno
    sql: ${TABLE}."LB_CUSTOMER" ;;
  }

  dimension: lb_dispn {
    type: number
    sql: ${TABLE}."LB_DISPN" ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}."LOCATION" ;;
  }

  dimension: master_bol {
    type: string
    sql: ${TABLE}."MASTER_BOL" ;;
  }

  dimension: mfg_finished_good_desc {
    type: string
    sql: ${TABLE}."MFG_FINISHED_GOOD_DESC" ;;
  }

  dimension: mfg_planner_id {
    type: string
    sql: ${TABLE}."MFG_PLANNER_ID" ;;
  }

  dimension_group: modified {
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
    sql: CAST(${TABLE}."MODIFIED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: n_allocl {
    type: number
    sql: ${TABLE}."N_ALLOCL" ;;
  }

  dimension: n_cube {
    type: number
    sql: ${TABLE}."N_CUBE" ;;
  }

  dimension: n_lines {
    type: number
    sql: ${TABLE}."N_LINES" ;;
  }

  dimension: n_units {
    type: number
    sql: ${TABLE}."N_UNITS" ;;
  }

  dimension: ok_bo {
    type: yesno
    sql: ${TABLE}."OK_BO" ;;
  }

  dimension: ord_group {
    type: string
    sql: ${TABLE}."ORD_GROUP" ;;
  }

  dimension: order_num {
    type: string
    sql: ${TABLE}."ORDER_NUM" ;;
  }

  dimension_group: ordered {
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
    sql: ${TABLE}."ORDERED" ;;
  }

  dimension: pack_hold {
    type: yesno
    sql: ${TABLE}."PACK_HOLD" ;;
  }

  dimension: packlane {
    type: number
    sql: ${TABLE}."PACKLANE" ;;
  }

  dimension: ph_row_id {
    type: string
    sql: ${TABLE}."PH_ROW_ID" ;;
  }

  dimension: pickup_num {
    type: string
    sql: ${TABLE}."PICKUP_NUM" ;;
  }

  dimension: priority {
    type: number
    sql: ${TABLE}."PRIORITY" ;;
  }

  dimension: qtytobuild {
    type: number
    sql: ${TABLE}."QTYTOBUILD" ;;
  }

  dimension_group: requested {
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
    sql: ${TABLE}."REQUESTED" ;;
  }

  dimension_group: required {
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
    sql: ${TABLE}."REQUIRED" ;;
  }

  dimension: residential {
    type: yesno
    sql: ${TABLE}."RESIDENTIAL" ;;
  }

  dimension: row_id {
    type: string
    sql: ${TABLE}."ROW_ID" ;;
  }

  dimension: satisfaction {
    type: number
    sql: ${TABLE}."SATISFACTION" ;;
  }

  dimension: ship_address {
    type: string
    sql: ${TABLE}."SHIP_ADDRESS" ;;
  }

  dimension: ship_attn {
    type: string
    sql: ${TABLE}."SHIP_ATTN" ;;
  }

  dimension: ship_city {
    type: string
    sql: ${TABLE}."SHIP_CITY" ;;
  }

  dimension: ship_cntry {
    type: string
    sql: ${TABLE}."SHIP_CNTRY" ;;
  }

  dimension: ship_compl {
    type: yesno
    sql: ${TABLE}."SHIP_COMPL" ;;
  }

  dimension: ship_crtns {
    type: number
    sql: ${TABLE}."SHIP_CRTNS" ;;
  }

  dimension: ship_cube {
    type: number
    sql: ${TABLE}."SHIP_CUBE" ;;
  }

  dimension: ship_name {
    type: string
    sql: ${TABLE}."SHIP_NAME" ;;
  }

  dimension: ship_num {
    type: string
    sql: ${TABLE}."SHIP_NUM" ;;
  }

  dimension: ship_pay {
    type: string
    sql: ${TABLE}."SHIP_PAY" ;;
  }

  dimension: ship_prov {
    type: string
    sql: ${TABLE}."SHIP_PROV" ;;
  }

  dimension: ship_servc {
    type: string
    sql: ${TABLE}."SHIP_SERVC" ;;
  }

  dimension: ship_telno {
    type: string
    sql: ${TABLE}."SHIP_TELNO" ;;
  }

  dimension: ship_via {
    type: string
    sql: ${TABLE}."SHIP_VIA" ;;
  }

  dimension: ship_wght {
    type: number
    sql: ${TABLE}."SHIP_WGHT" ;;
  }

  dimension: ship_zip {
    type: string
    sql: ${TABLE}."SHIP_ZIP" ;;
  }

  dimension_group: shipped {
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
    sql: CAST(${TABLE}."SHIPPED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: shp_option {
    type: string
    sql: ${TABLE}."SHP_OPTION" ;;
  }

  dimension: shpr_city {
    type: string
    sql: ${TABLE}."SHPR_CITY" ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}."SOURCE" ;;
  }

  dimension: stage_loc {
    type: string
    sql: ${TABLE}."STAGE_LOC" ;;
  }

  dimension: store_num {
    type: string
    sql: ${TABLE}."STORE_NUM" ;;
  }

  dimension: surprise {
    type: number
    sql: ${TABLE}."SURPRISE" ;;
  }

  dimension: t48 {
    type: number
    sql: ${TABLE}."T48" ;;
  }

  dimension: tkt_type {
    type: string
    sql: ${TABLE}."TKT_TYPE" ;;
  }

  dimension: to_warehouse {
    type: string
    sql: ${TABLE}."TO_WAREHOUSE" ;;
  }

  dimension: transaction_id {
    type: number
    sql: ${TABLE}."TRANSACTION_ID" ;;
  }

  dimension: transaction_number {
    type: string
    sql: ${TABLE}."TRANSACTION_NUMBER" ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}."TRANSACTION_TYPE" ;;
  }

  dimension_group: uploaded {
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
    sql: CAST(${TABLE}."UPLOADED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: value_fill {
    type: number
    sql: ${TABLE}."VALUE_FILL" ;;
  }

  dimension: value_gros {
    type: number
    sql: ${TABLE}."VALUE_GROS" ;;
  }

  dimension: wave {
    type: number
    sql: ${TABLE}."WAVE" ;;
  }

  dimension: weight_kg {
    type: number
    sql: ${TABLE}."WEIGHT_KG" ;;
  }

}
