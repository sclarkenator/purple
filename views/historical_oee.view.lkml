#-------------------------------------------------------------------
# Owner - Jonathan Stratton
# Overall Equipement Effectiveness (OEE)
#-------------------------------------------------------------------

view: oee {
  sql_table_name: PRODUCTION.OEE ;;

  dimension: cycle_time {
    hidden: yes
    type: number
    sql: ${TABLE}.CYCLE_TIME  ;; }

  dimension_group: date {
    description: "Recorded Transaction date of the iPad transaction"
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.DATE ;; }

  dimension: ideal_production {
    label: "Ideal Production"
    description: "The quantity of items that would be made at 100% effciency at the stated cycle time"
    hidden: yes
    type: number
    sql: ${TABLE}.IDEAL_PRODUCTION ;; }

  dimension: machine {
    label: "Machine"
    description: "The name of the Machine that created the transaction"
    type: string
    sql: ${TABLE}.MACHINE ;; }

  dimension: operating_time {
    hidden: yes
    type: number
    sql: ${TABLE}.OPERATING_TIME ;; }

  dimension: product_type {
    label: "Product Type"
    description: "The Item that was created by the transaction"
    type: string
    sql: ${TABLE}.PRODUCT_TYPE ;; }

  dimension: reject_scrap {
    hidden:  yes
    type: number
    sql: ${TABLE}.REJECT_SCRAP ;; }

  dimension: scheduled {
    hidden:  yes
    type: number
    sql: ${TABLE}.SCHEDULED ;; }

  dimension: total_available {
    hidden:  yes
    type: number
    sql: ${TABLE}.TOTAL_AVAILABLE ;; }

  dimension: total_production {
    hidden:  yes
    type: number
    sql: ${TABLE}.TOTAL_PRODUCTION ;; }

  dimension: unscheduled_downtime {
    hidden:  yes
    type: number
    sql: ${TABLE}.UNSCHEDULED_DOWNTIME ;; }

  measure: count {
    label: "Count"
    description: "The count of occurences"
    type: count }

  measure: Total_Availble_Time{
    label: "Total Available Time (min)"
    description: "The sum of all time the machine could be available in minutes (This is set at 1440 for nearly all cases)"
    type: sum
    sql: ${TABLE}.TOTAL_AVAILABLE;; }

 measure: Total_Scheduled_Time {
  label: "Total Scheduled Time (min)"
  description: "The sum of all time the machine was planned to be out of operation in minutes"
  type: sum
  sql: ${TABLE}.SCHEDULED;; }

  measure: Total_Operating_Time {
    label: "Total Operating Time (min)"
    description: "The sum of all time the machine was in operation in minutes"
    type: sum
    sql: ${TABLE}.OPERATING_TIME ;; }

  measure: Total_Production_Sum {
    label: "Total Production (units)"
    description: "The sum of the items that were produced by the machine"
    type: sum
    sql: ${TABLE}.TOTAL_PRODUCTION ;; }

  measure: Average_Cycle_Time {
    label: "Average Cycle Time (min)"
    description: "The average of the cycle time stated on the machine"
    type: average
    sql: ${TABLE}.CYCLE_TIME ;; }

  measure: Total_Reject_Scrap{
    label: "Total Reject Scrap (units)"
    description: "The sum of the items that were rejected by the machine"
    type: sum
    sql: ${TABLE}.REJECT_SCRAP ;; }

  measure: Total_unscheduled_downtime {
    label: "Total Unscheduled Downtime (min)"
    description: "The sum of all time the machine was out of operation due to unplanned circumstances in minutes"
    type: sum
    sql: ${TABLE}.UNSCHEDULED_DOWNTIME ;; }


  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${operating_time}, ${total_production}, ${reject_scrap}) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }

}
