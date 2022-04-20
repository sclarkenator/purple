# The name of this view in Looker is "Slt Safety Details"
view: slt_safety_details {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PRODUCTION"."SLT_SAFETY_DETAILS"
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Cause" in Explore.

  dimension: cause {
    type: string
    sql: ${TABLE}."CAUSE" ;;
  }

  dimension: dept {
    type: string
    sql: ${TABLE}."DEPT" ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: incident {
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
    sql: ${TABLE}."INCIDENT_DATE" ;;
  }

  dimension: incident_type {
    type: string
    sql: ${TABLE}."INCIDENT_TYPE" ;;
  }

  dimension: shift {
    type: string
    sql: ${TABLE}."SHIFT" ;;
  }

  dimension: site {
    type: string
    sql: ${TABLE}."SITE" ;;
  }

  dimension: treatment {
    type: string
    sql: ${TABLE}."TREATMENT" ;;
  }

  dimension: incident_group{
    type:  string
    sql: iff(treatment is null,'Near Miss',treatment);;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
