view: workorder_reconciliation {
  sql_table_name: PRODUCTION.WORKORDER_RECONCILIATION ;;

  measure: amt_required_for_one {
    type: sum
    sql: ${TABLE}."AMT_REQUIRED_FOR_ONE" ;;
  }

  dimension: assembly_build_id {
    type: string
    link: { label: "NetSuite" url: "https://system.na2.netsuite.com/app/accounting/transactions/build.nl?id={{ workorder_reconciliation.assembly_build_id._value }}"  }
    sql: ${TABLE}."ASSEMBLY_BUILD_ID" ;;
  }

  measure: build_quantity {
    type: sum
    sql: ${TABLE}."BUILD_QUANTITY" ;;
  }

  dimension: component {
    type: string
    link: { label: "NetSuite" url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ workorder_reconciliation.component_item_id._value }}" }
    sql: ${TABLE}."COMPONENT" ;;
  }

  dimension: component_item_id {
    type: string
    link: { label: "NetSuite" url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ workorder_reconciliation.component_item_id._value }}" }
    sql: ${TABLE}."COMPONENT_ITEM_ID" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      hour,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."CREATED" ;;
  }

  measure: expected_amt {
    type: sum
    sql: ${TABLE}."EXPECTED_AMT" ;;
  }

  dimension_group: insert_ts {
    hidden: yes
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
    sql: ${TABLE}."INSERT_TS" ;;
  }

  measure: ordered_amt {
    type: sum
    sql: ${TABLE}."ORDERED_AMT" ;;
  }

  dimension: part {
    label: "Part Name"
    link: { label: "NetSuite" url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ workorder_reconciliation.part_item_id._value }}" }
    type: string
    sql: ${TABLE}."PART" ;;
  }

  dimension: part_item_id {
    label: "Part Internal ID"
    type: string
    link: { label: "NetSuite" url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ workorder_reconciliation.part_item_id._value }}" }
    sql: ${TABLE}."PART_ITEM_ID" ;;
  }

  dimension: part_sku {
    type: string
    link: { label: "NetSuite" url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ workorder_reconciliation.part_item_id._value }}" }
    sql: ${TABLE}."PART_SKU" ;;
  }

  dimension: tranid {
    label: "Document Number"
    type: string
    link: { label: "NetSuite" url: "https://system.na2.netsuite.com/app/accounting/transactions/build.nl?id={{ workorder_reconciliation.assembly_build_id._value }}"  }
    sql: ${TABLE}."TRANID" ;;
  }

  dimension_group: update_ts {
    hidden: yes
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
    sql: ${TABLE}."UPDATE_TS" ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
