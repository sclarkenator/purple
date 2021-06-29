view: customer_journey {
  sql_table_name: DATAGRID.MARKETING.V_CUSTOMER_JOURNEY
    ;;

  dimension: email {
    type:  string
    label: "Customer Email"
    hidden:  yes
    sql:${TABLE}."EMAIL" ;;
  }

  dimension: has_Mattress {
    type:  yesno
    label: "Has purchased a mattress"
    sql: ${TABLE}."HAS_MATTRESS" = 'Y' ;;
  }

  dimension: has_Base {
    type:  yesno
    label: "Has purchased a base"
    sql: ${TABLE}."HAS_BASE" = 'Y' ;;
  }

  dimension: has_Headboard {
    type:  yesno
    label: "Has purchased a headboard"
    sql: ${TABLE}."HAS_HEADBOARD" = 'Y' ;;
  }

  dimension: has_Pet {
    type:  yesno
    label: "Has purchased a pet product"
    sql: ${TABLE}."HAS_PET" = 'Y' ;;
  }

  dimension: has_Pillow {
    type:  yesno
    label: "Has purchased a pillow"
    sql: ${TABLE}."HAS_PILLOW" = 'Y' ;;
  }

  dimension: has_Protector {
    type:  yesno
    label: "Has purchased a Protector"
    sql: ${TABLE}."HAS_PROTECTOR" = 'Y' ;;
  }

  dimension: has_Seating {
    type:  yesno
    label: "Has purchased a seating product"
    sql: ${TABLE}."HAS_SEATING" = 'Y' ;;
  }

  dimension: has_Sheets {
    type:  yesno
    label: "Has purchased sheets"
    sql: ${TABLE}."HAS_SHEETS" = 'Y' ;;
  }

  dimension: has_Wearable {
    type:  yesno
    label: "Has purchased a wearable product"
    sql: ${TABLE}."HAS_WEARABLE" = 'Y' ;;
  }

  dimension: share_of_bedroom {
    type:  string
    label: "Share of Bedroom"
    sql: ${TABLE}."SHARE_OF_BEDROOM" ;;
  }

  dimension: total_bedroom_orders {
    type:  number
    label: "Total bedroom orders"
    sql: ${TABLE}."TOTAL_BEDROOM_ORDERS" ;;
  }

  dimension: total_orders {
    type:  number
    hidden:  yes
    label: "Total orders"
    sql: ${TABLE}."TOTAL_ORDERS" ;;
  }

}
