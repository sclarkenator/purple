view: v_purple_showroom {
  sql_table_name: "RETAIL"."V_PURPLE_SHOWROOM"
    ;;

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${date_created_date}, ${purple_showroom_name}) ;;
    hidden: yes
  }

  dimension: location_name {
    type: string
    view_label: "Owned Retail"
    label: " Location Name"
    description: "Standardized Owned Retail location name. State - Center/Mall Name. Maintained in Netsuite."
    sql: ${TABLE}."LOCATION_NAME" ;;
  }

  dimension: is_outlet {
    view_label: "Owned Retail"
    group_label: "Advanced"
    type: yesno
    label: "Is Outlet"
    sql: lower(${TABLE}.location_name) ilike '%outlet%' ;;
  }

  dimension: address_1 {
    type: string
    group_label: "Address"
    label: "Street Address"
    sql: ${TABLE}."ADDRESS_1" ;;
  }

  dimension: address_2 {
    type: string
    hidden:  yes
    sql: ${TABLE}."ADDRESS_2" ;;
  }

  dimension: birdeye_business_id {
    type: string
    hidden:  yes
    sql: ${TABLE}."BIRDEYE_BUSINESS_ID" ;;
  }

  dimension: city {
    type: string
    group_label: "Address"
    sql: ${TABLE}."CITY" ;;
  }

  dimension_group: date_created {
    type: time
    hidden:  yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."DATE_CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: date_deleted {
    type: time
    hidden:  yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."DATE_DELETED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: is_inactive {
    group_label: "Advanced"
    type: yesno
    view_label: "Owned Retail"
    label: "Location inactive"
    hidden:  yes
    sql: ${TABLE}."IS_INACTIVE"='T' ;;
  }

  dimension_group: last_modified {
    type: time
    hidden:  yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."LAST_MODIFIED_DATE" AS TIMESTAMP_NTZ) ;;
  }

  dimension: parent_id {
    type: string
    hidden:  yes
    sql: ${TABLE}."PARENT_ID" ;;
  }

  dimension: purple_showroom_extid {
    type: string
    hidden:  yes
    sql: ${TABLE}."PURPLE_SHOWROOM_EXTID" ;;
  }

  dimension: purple_showroom_id {
    type: string
    label: "Purple Showroom Number"
    hidden:  yes
    sql: ${TABLE}."PURPLE_SHOWROOM_ID" ;;
  }

  dimension: purple_showroom_name {
    type: string
    label: " Showroom ID"
    sql: ${TABLE}."PURPLE_SHOWROOM_NAME" ;;
  }

  measure: showroom_sqft {
    view_label: "Owned Retail"
    type: sum
    label: " Showroom Square Footage"
    sql: ${TABLE}.square_footage ;;
  }

  dimension: shopify_store_id {
    type: string
    hidden:  yes
    sql: ${TABLE}."SHOPIFY_STORE_ID" ;;
  }

  dimension: state_id {
    type: number
    hidden:  yes
    sql: ${TABLE}."STATE_ID" ;;
  }

  dimension: zip {
    type: zipcode
    group_label: "Address"
    sql: ${TABLE}."ZIP" ;;
  }

  measure: count {
    type: count
    hidden:  yes
    drill_fields: [purple_showroom_name, location_name]
  }
}
