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

dimension: AREASEFFECTED {
  type: string
  sql: ${TABLE}.AREASEFFECTED ;; }

dimension: DATE {
  type: date
  sql: ${TABLE}.DATE ;; }

dimension: REQBY {
  type: string
  sql: ${TABLE}.REQBY ;; }

dimension: PROJECT_NUM {
  type: string
  sql: ${TABLE}.PROJECT_NUM ;; }

}
