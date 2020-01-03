view: change_mgmt {
  sql_table_name: engineering.eng.change_mgmt ;;

  dimension: CH_ID {
    type: string
    sql: ${TABLE}.CH_ID ;; }

  dimension: CHANGETYPE {
    type: string
    sql: ${TABLE}.CHANGETYPE ;; }

  dimension: DESCRIPTION {
    type: string
    sql: ${TABLE}.DESCRIPTION ;; }

  dimension: DATE {
    type: date
    sql: ${TABLE}.DATE ;; }

  dimension: REQBY {
    type: string
    sql: ${TABLE}.REQBY ;; }

  dimension: PROJECT_NUM {
    type: string
    sql: ${TABLE}.PROJECT_NUM ;; }

  dimension: WF_ID {
    type: string
    sql: ${TABLE}.WF_ID ;; }

  dimension: FIXED_ASSET {
    type: string
    sql: ${TABLE}.FIXED_ASSET ;; }

  measure: COUNT_OF_REQUEST{
    label: "Request Count"
    description: "A Total Count of Requests"
    type: sum
    sql: case when ${CHANGETYPE} = 'Request' then 1 else 0 end ;;}

  measure: COUNT_OF_REVISED{
    label: "Revised Count"
    description: "A Total Count of Revised"
    type: sum
    sql: case when ${CHANGETYPE} = 'Revised' then 1 else 0 end ;;}

}
