view: workorder_reconciliation {
  sql_table_name: PRODUCTION.WORKORDER_RECONCILIATION ;;

  measure: amt_required_for_one {
    label: "Component QTY Per (Expected)"
    type: sum
    sql: ${TABLE}."AMT_REQUIRED_FOR_ONE" ;;
  }

  dimension: assembly_build_id {
    type: string
    link: { label: "NetSuite" url: "https://system.na2.netsuite.com/app/accounting/transactions/build.nl?id={{ workorder_reconciliation.assembly_build_id._value }}"  }
    sql: ${TABLE}."ASSEMBLY_BUILD_ID" ;;
  }

  measure: build_quantity {
    label: "FG Build QTY"
    type: sum
    sql: ${TABLE}."BUILD_QUANTITY" ;;
  }

  dimension: component {
    label: "Item Built"
    type: string
    link: { label: "NetSuite" url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ workorder_reconciliation.component_item_id._value }}" }
    sql: ${TABLE}."COMPONENT" ;;
  }

  dimension: component_item_id {
    label: "Built Item ID"
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

  dimension: expected {
    label: "QTY Consumed (Expected)"
    type: number
    sql: ${TABLE}."EXPECTED_AMT" ;;
  }

  measure: expected_amt {
    label: "QTY Consumed (Expected)"
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

  dimension: ordered {
    label: "QTY Consumed (Actual)"
    type: number
    sql: ${TABLE}."ORDERED_AMT" ;;
  }

  measure: ordered_amt {
    label: "QTY Consumed (Actual)"
    type: sum
    sql: ${TABLE}."ORDERED_AMT" ;;
  }

  dimension: part {
    label: "Component Item Name"
    link: { label: "NetSuite" url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ workorder_reconciliation.part_item_id._value }}" }
    type: string
    sql: ${TABLE}."PART" ;;
  }

  dimension: part_item_id {
    label: "Component Item Internal ID"
    type: string
    link: { label: "NetSuite" url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ workorder_reconciliation.part_item_id._value }}" }
    sql: ${TABLE}."PART_ITEM_ID" ;;
  }

  dimension: part_sku {
    label: "Component Item Sku ID"
    type: string
    link: { label: "NetSuite" url: "https://system.na2.netsuite.com/app/common/item/item.nl?id={{ workorder_reconciliation.part_item_id._value }}" }
    sql: ${TABLE}."PART_SKU" ;;
  }

  dimension: tranid {
    label: "Assembly Build Number"
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

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${component_item_id}, ${tranid},${component_item_id}) ;;
    hidden: yes
  }

  measure: order_expected_match {
    label: "Ordered and Expected Amounts Match"
    description: "If they match = 1 if not = 0"
    type: number
    sql: case when round(${expected_amt},1) = round(${ordered_amt},1) then 1 else 0 end ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
