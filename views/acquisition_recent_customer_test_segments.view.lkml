view: acquisition_recent_customer_test_segments {
  sql_table_name: "CSV_UPLOADS"."ACQUISITION_RECENT_CUSTOMER_TEST_SEGMENTS"
    ;;

  dimension: customer_email {
    type: string
    sql: ${TABLE}."CUSTOMER_EMAIL" ;;
    hidden: yes
    primary_key: yes
  }

  dimension: segment {
    type: string
    group_label: " Advanced"
    label: "Acquisition Test Segment"
    description: "Segments for acquisition recent customers June 2020. Analytics split the
    emails into A and B segments. Source: analytics.aquisitions_recent_customer_test_segments"
    sql: ${TABLE}."SEGMENT" ;;
  }

  measure: count {
    type: count
    drill_fields: []
    hidden: yes
  }

  dimension: test_purchase {
    group_label: " Advanced"
    label: "     * Acquisition Test"
    description: "The customer is in the A/B test. Source: looker.calculation"
    type: yesno
    sql: ${TABLE}."CUSTOMER_EMAIL" is not NULL ;;
  }
}
