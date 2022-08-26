# # The name of this view in Looker is "V Site Feedback"
# view: v_site_feedback {
#   sql_table_name: "MARKETING"."V_SITE_FEEDBACK" ;;

#   dimension: answer {
#     type: string
#     sql: ${TABLE}."ANSWER" ;;
#   }

#   dimension: email {
#     type: string
#     sql: ${TABLE}."EMAIL" ;;
#   }

#   dimension: name {
#     type: string
#     sql: ${TABLE}."NAME" ;;
#   }

#   measure: rating {
#     label: "Site rating"
#     description: "Scale of 1 to 5, 5 being high"
#     type: average
#     sql: ${TABLE}."RATING" ;;
#   }

#   dimension: response_id {
#     hidden: yes
#     type: string
#     sql: ${TABLE}."RESPONSE_ID" ;;
#   }

#   dimension: qm_replay_url {
#     type: string
#     sql: ${TABLE}.qm_replay_url;;
#   }

#   dimension_group: start {
#     type: time
#     timeframes: [
#       time,
#       date,
#       hour,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     sql: CAST(${TABLE}.start_date AS TIMESTAMP_NTZ) ;;
#   }
# }
