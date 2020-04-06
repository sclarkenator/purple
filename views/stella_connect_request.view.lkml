view: stella_connect_request {
   sql_table_name: analytics.customer_care.stella_connect_request ;;

   dimension: request_id {
     description: "Unique ID for each survey request"
     type: string
     sql: ${TABLE}.request_id ;;
    primary_key: yes
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
    hidden: yes
    description: "Duplicate of FCR?"
    type: string
    sql: ${TABLE}.ADDITIONAL_QUESTION_RESPONSE ;;
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
    description: "Average Net Promoter Score"
    type: average
    sql: ${stella_connect_request.NPS_RESPONSE} ;;
  }

  measure: STAR_RATING_RESPONSE_avg {
    description: "Average Star Rating out of 5"
    type: average
    sql: ${stella_connect_request.STAR_RATING_RESPONSE} ;;
  }
}