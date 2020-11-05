view: pii_review {
  sql_table_name: ANALYTICS.LEGAL.PII_REVIEW
    ;;


  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: address {
    description: "Source: snowflake.pii_review"
    type: string
    sql: ${TABLE}."ADDRESS" ;;
  }

  dimension: city {
    description: "Source: snowflake.pii_review"
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: email {
    description: "Source: snowflake.pii_review"
    type: string
    sql: ${TABLE}."EMAIL" ;;
    required_access_grants:[can_view_pii]
  }

  dimension: name {
    description: "Source: snowflake.pii_review"
    type: string
    sql: ${TABLE}."NAME" ;;
    required_access_grants:[can_view_pii]
  }

  dimension: phone {
    description: "Source: snowflake.pii_review"
    type: string
    sql: ${TABLE}."PHONE" ;;
    required_access_grants:[can_view_pii]
  }

  dimension: sources {
    description: "This indicates where the email address is found. Source: snowflake.pii_review"
    type: string
    sql: ${TABLE}."SOURCES" ;;
    required_access_grants:[can_view_pii]
  }

  dimension: state {
    description: "Source: snowflake.pii_review"
    type: string
    sql: ${TABLE}."STATE" ;;
  }

  dimension: zip {
    description: "Source: snowflake.pii_review"
    type: zipcode
    sql: ${TABLE}."ZIP" ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [name]
  }
}
