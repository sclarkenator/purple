view: unbounce_lead {
  sql_table_name: "MARKETING"."UNBOUNCE_LEAD"
    ;;

  dimension: PK {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${page_name}||'-'||${url}||'-'||${variant}||'-'||${first_name}||'-'||${last_name}||'-'||${phone_number}||'-'||${email_join}||'-'||${current_address}||'-'||${city}||'-'||${state}||'-'||${zip_code}||'-'||${country}||'-'||${frame_size}||'-'||${bases_purchased}||'-'||${purchased_from}||'-'||${estimated_date_of_purchase} ;;
  }

  dimension: city {
    description: "Customer City. Source:unbounce.unbounce_lead"
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: country {
    description: "Customer Country. Source:unbounce.unbounce_lead"
    type: string
    map_layer_name: countries
    sql: ${TABLE}."COUNTRY" ;;
  }

  dimension_group: created {
    description: "Creation of the Lead. Source:unbounce.unbounce_lead"
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

  dimension: current_address {
    description: "Customer Address. Source:unbounce.unbounce_lead"
    type: string
    sql: ${TABLE}."CURRENT_ADDRESS" ;;
    required_access_grants:[can_view_pii]
  }

  dimension: email_join {
    hidden: yes
    description: "If you need to join on email then use this dimension"
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }
  dimension: email {
    description: "Customer Email Address on the Netsuite customer record. Source:unbounce.unbounce_lead"
    type: string
    sql:
      CASE
        WHEN '{{ _user_attributes['can_view_pii'] }}' = 'yes' THEN ${TABLE}.email
        ELSE '**********' || '@' || SPLIT_PART(${TABLE}.email, '@', 2)
      END
    ;;
    required_access_grants:[can_view_pii]
  }

  dimension: estimated_date_of_purchase {
    description: "Unbouced estimated date the customer made a purchase. Source:unbounce.unbounce_lead"
    type: string
    sql: ${TABLE}."ESTIMATED_DATE_OF_PURCHASE" ;;
  }

  dimension: first_name {
    description: "Customers First name. Source:unbounce.unbounce_lead"
    type: string
    sql: ${TABLE}."FIRST_NAME" ;;
    required_access_grants:[can_view_pii]
  }

  dimension: frame_size {
    description: "Source:unbounce.unbounce_lead"
    type: string
    sql: ${TABLE}."FRAME_SIZE" ;;
  }

  dimension: last_name {
    description: "Customer last name. Source:unbounce.unbounce_lead"
    type: string
    sql: ${TABLE}."LAST_NAME" ;;
  }

  dimension: page_name {
    description: "Source:unbounce.unbounce_lead"
    type: string
    sql: ${TABLE}."PAGE_NAME" ;;
  }

  dimension: phone_number {
    description: "Customer phone number. Source:unbounce.unbounce_lead"
    type: string
    sql: ${TABLE}."PHONE_NUMBER" ;;
    required_access_grants:[can_view_pii]
  }

  dimension: purchased_from {
    description: "Source:unbounce.unbounce_lead"
    type: string
    sql: ${TABLE}."PURCHASED_FROM" ;;
  }

  dimension: bases_purchased {
    hidden: yes
    type: string
    sql: ${TABLE}."QUANTITY_OF_BASES_PURCHASED" ;;
  }

  dimension: state {
    description: "Customer State. Source:unbounce.unbounce_lead"
    type: string
    sql: ${TABLE}."STATE" ;;
  }

  dimension: url {
    description: "Source:unbounce.unbounce_lead"
    type: string
    sql: ${TABLE}."URL" ;;
  }

  dimension: variant {
    description: "Source:unbounce.unbounce_lead"
    type: string
    sql: ${TABLE}."VARIANT" ;;
  }

  dimension: zip_code {
    description: "Customer zipcode. Source:unbounce.unbounce_lead"
    type: zipcode
    sql: ${TABLE}."ZIP_CODE" ;;
  }

  measure: count {
    type: count
    drill_fields: [last_name, first_name, page_name]
  }

  measure: quantity_of_bases_purchased {
    group_item_label: "Bases Purchased (Units)"
    description: "Quantity of bases purchased. Source:unbounce.unbounce_lead"
    type: sum
    sql: replace(${TABLE}."QUANTITY_OF_BASES_PURCHASED",'+','') ;;
  }
}
