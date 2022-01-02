view: customer_journey {
  sql_table_name: MARKETING.EMAIL.V_CUSTOMER_JOURNEY
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
    sql: ${TABLE}."HASMATTRESS" = 'Y' ;;
  }

  dimension: has_Base {
    type:  yesno
    label: "Has purchased a base"
    sql: ${TABLE}."HASBASE" = 'Y' ;;
  }

  dimension: has_Headboard {
    type:  yesno
    label: "Has purchased a headboard"
    sql: ${TABLE}."HASHEADBOARD" = 'Y' ;;
  }

  dimension: has_Pet {
    type:  yesno
    label: "Has purchased a pet product"
    sql: ${TABLE}."HASPET" = 'Y' ;;
  }

  dimension: has_Pillow {
    type:  yesno
    label: "Has purchased a pillow"
    sql: ${TABLE}."HASPILLOW" = 'Y' ;;
  }

  dimension: has_Protector {
    type:  yesno
    label: "Has purchased a Protector"
    sql: ${TABLE}."HASPROTECTOR" = 'Y' ;;
  }

  dimension: has_Seating {
    type:  yesno
    label: "Has purchased a seating product"
    sql: ${TABLE}."HASSEATING" = 'Y' ;;
  }

  dimension: has_Sheets {
    type:  yesno
    label: "Has purchased sheets"
    sql: ${TABLE}."HASSHEETS" = 'Y' ;;
  }

  dimension: has_Wearable {
    type:  yesno
    label: "Has purchased a wearable product"
    sql: ${TABLE}."HASWEARABLE" = 'Y' ;;
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
