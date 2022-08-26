# The name of this view in Looker is "V Session Hour Projection"
# view: v_session_hour_projection {
#   sql_table_name: "HEAP"."V_SESSION_HOUR_PROJECTION"  ;;

#   measure: actual_and_projection {
#     type: sum
#     sql: ${TABLE}."ACTUAL_AND_PROJECTION" ;;
#   }

#   dimension: hour {
#     label: "Hour of Day"
#     type: number
#     sql: ${TABLE}."HOUR" ;;
#   }

#   dimension: include_flag {
#     type: number
#     sql: ${TABLE}."INCLUDE_FLAG" ;;
#   }

#   dimension: ly_session {
#     type: number
#     sql: ${TABLE}."LY_SESSION" ;;
#   }

#   # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
#   # measures for this dimension, but you can also add measures of many different aggregates.
#   # Click on the type parameter to see all the options in the Quick Help panel on the right.

#   measure: total_ly_session {
#     type: sum
#     sql: ${ly_session} ;;
#   }

#   measure: average_ly_session {
#     type: average
#     sql: ${ly_session} ;;
#   }

#   dimension: ty_session {
#     type: number
#     sql: ${TABLE}."TY_SESSION" ;;
#   }

#   measure: count {
#     type: count
#     drill_fields: []
#   }
# }
