view: ct_session {
  sql_table_name: "SALES"."CT_SESSION"
    ;;

  dimension: session_id {
    hidden: yes
    type: number
    sql: ${TABLE}."SESSION_ID" ;;
  }

  dimension: user_id {
    hidden: yes
    type: number
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: variant {
    view_label: "Sessions"
    label: "CT test variant"
    type: string
    sql: ${TABLE}."VARIANT" ;;
  }

 }
