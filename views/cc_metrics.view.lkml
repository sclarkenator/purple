# The name of this view in Looker is "Cc Metrics"
view: cc_metrics {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PROD"."CC_METRICS"
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Activities" in Explore.

  dimension: activities {
    type: number
    sql: ${TABLE}."ACTIVITIES" ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_activities {
    type: sum
    sql: ${activities} ;;
  }

  measure: average_activities {
    type: average
    sql: ${activities} ;;
  }

  dimension: agent {
    type: string
    sql: ${TABLE}."AGENT" ;;
  }

  dimension: agent_email {
    type: string
    sql: ${TABLE}."AGENT_EMAIL" ;;
  }

  dimension: gross_sales {
    type: number
    sql: ${TABLE}."GROSS_SALES" ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: merged {
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
    sql: ${TABLE}."MERGED" ;;
  }

  dimension: metric_type {
    type: string
    sql: ${TABLE}."METRIC_TYPE" ;;
  }

  dimension: source_clean {
    type: string
    sql: ${TABLE}."SOURCE_CLEAN" ;;
  }

  dimension: team {
    type: string
    sql: ${TABLE}."TEAM" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
