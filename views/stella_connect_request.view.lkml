view: stella_connect_request {
   sql_table_name: analytics.customer_care.stella_connect_request ;;

   dimension: request_id {
     description: "Unique ID for each survey request"
     type: string
     sql: ${TABLE}.request_id ;;
    primary_key: yes
   }

  dimension_group: sent  {
    type: time
    description: "Date the Evaluation Request was sent to the customer"
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: yes
    datatype: timestamp
    sql: ${TABLE}.sent ;;
  }

  dimension_group: received  {
    type: time
    description: "Date the Evaluation Request was received from the customer"
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: yes
    datatype: timestamp
    sql: ${TABLE}.RECIEVED ;;
  }

  dimension: email {
    description: "Customer email address"
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: employee_id {
    description: "ID number for Purple employee evaluated"
    type: string
    sql: ${TABLE}.employee_id ;;
  }

  dimension: channel {
    description: "Chat / Phone / Email conversation"
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: comments {
    description: "Customer comments about employee"
    type: string
    sql: ${TABLE}.comments ;;
  }

  dimension: AREAS_FOR_IMPROVEMENT {
    description: "Areas the customer said that employee could improve"
    type: string
    sql: ${TABLE}.AREAS_FOR_IMPROVEMENT ;;
  }

  dimension: AREAS_OF_EXCELLENCE_SELECTED {
    description: "Areas the customer said that employee was excellent"
    type: string
    sql: ${TABLE}.AREAS_OF_EXCELLENCE_SELECTED ;;
  }

  dimension: ADDITIONAL_QUESTION_RESPONSE {
    hidden: no
    label: "FCR"
    description: "Did the employee resolve your question in the first call?"
    type: yesno
    sql: ${TABLE}.ADDITIONAL_QUESTION_RESPONSE ilike 'Yes';;
  }

  dimension: ADDITIONAL_QUESTION_COMMENTS {
    hidden: yes
    description: "Duplicate of FCR?"
    type: string
    sql: ${TABLE}.ADDITIONAL_QUESTION_COMMENTS ;;
  }

  dimension: STAR_RATING_RESPONSE {
    description: "Star Rating out of 5 given by customer"
    type: number
    sql: ${TABLE}.STAR_RATING_RESPONSE ;;
  }

  dimension: FCR_RESPONSE {
    hidden: yes
    label: ""
    description: "First Call Resolution response"
    type: string
    sql: ${TABLE}.FCR_RESPONSE ;;
  }

  dimension: FCR_COMMENT {
    description: "First Call Resolution comment"
    type: string
    sql: ${TABLE}.FCR_COMMENT ;;
  }

  dimension: NPS_RESPONSE {
    description: "Net Promoter Score"
    type: number
    sql: ${TABLE}.NPS_RESPONSE ;;
  }

  dimension: NPS_COMMENT {
    description: "Net Promoter Score comment"
    type: string
    sql: ${TABLE}.NPS_COMMENT ;;
  }

  measure: NPS_RESPONSE_avg {
    description: "Average Net Promoter Score. isn't working yet for some reason"
    type: average
    hidden: yes
    sql: ${stella_connect_request.NPS_RESPONSE} ;;
  }

  measure: STAR_RATING_RESPONSE_avg {
    description: "Average Star Rating out of 5"
    type: average
    value_format: "0.00"
    hidden: no
    sql: case when ${stella_connect_request.STAR_RATING_RESPONSE}>=0 then ${stella_connect_request.STAR_RATING_RESPONSE} end ;;
  }

  measure: FCR_rate {
    hidden: no
    description: "In Testing: Calcuates FCR rate. isn't working for some reason"
    type: percent_of_total
    value_format: "0.0%"
    sql: (sum(${ADDITIONAL_QUESTION_RESPONSE} ilike 'yes')/sum(${ADDITIONAL_QUESTION_RESPONSE})  ;;
  }

  measure: count {
    description: "Distinct Count of Request ID (rows)"
    type: count_distinct
    sql: ${request_id} ;;}

}
