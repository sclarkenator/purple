#-------------------------------------------------------------------
# Owner - Jonathan Stratton
# Netsuite report, exported and saved as a snapshot.
#-------------------------------------------------------------------

view: production_report {
  derived_table: {
    sql:  select created
      , CASE machine WHEN 'Glue Roller 3' THEN 'Core Station 1' ELSE machine END as machine
      , product
      , CASE WHEN machine like 'IMM%' THEN CASE WHEN product like '%Pillow%' THEN 'Pillow' ELSE 'Cushion' END ELSE product END as category
      , total
      , reason_code
      , reason_text
      , regrind
      , scrap
      , regrind + scrap as regrind_scrap
      , CASE WHEN netsuite_location_id = 5 THEN 'Alpine'
        WHEN netsuite_location_id = 41 THEN 'West' END as facility
    from (
      SELECT m.machine_name as machine
        , p.product_name as product
        , pl.created
        , pl.reason_code
        , pl.reason_text
        , count(*) AS total
        , SUM (CASE WHEN pl.status_id = 3 THEN 1 ELSE 0 END) AS regrind
        , SUM (CASE WHEN pl.status_id = 2 THEN 1 ELSE 0 END) AS scrap
        , m.netsuite_location_id
      FROM analytics_stage.ipad_stg.production_log pl
      JOIN analytics_stage.ipad_stg.machine m ON pl.machine_id = m.machine_id
      JOIN analytics_stage.ipad_stg.product p on pl.product_id = p.product_id
      GROUP BY m.machine_name
        , p.product_name
        , pl.created
        , pl.reason_code
        , pl.reason_text
        , m.netsuite_location_id
    ) t ;;}

  dimension_group: timestamp {
    type: time
    timeframes:
    [date,
      day_of_week,
      day_of_month,
      week,
      week_of_year,
      month,
      month_name,
      quarter,
      quarter_of_year,
      year,
      hour]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.created) ;; }

  dimension: day_night_shift {
    label: "Day or Night Shift"
    type: string
    sql: case when date_part('hour', ${TABLE}.created) between 7 and 18 then 'DAY' else 'NIGHT' end ;; }

  dimension: shift {
    label: "Shift"
    type: string
    sql: case when DATE_PART('hour', ${TABLE}.created) between 7 and 18 and Dayname(${TABLE}.created) in ('Mon', 'Tue', 'Wed') then 'M-W Day'
      when DATE_PART('hour', ${TABLE}.created) between 7 and 18 and Dayname(${TABLE}.created) in ('Thu', 'Fri', 'Sat') then 'Th-Sa Day'
      when ((DATE_PART('hour', ${TABLE}.created) > 18 and Dayname(${TABLE}.created) in ('Mon', 'Tue', 'Wed'))
        or (DATE_PART('hour', ${TABLE}.created) < 7 and Dayname(${TABLE}.created) in ('Tue', 'Wed', 'Thu'))) then 'M-W Night'
      when ((DATE_PART('hour', ${TABLE}.created) > 18 and Dayname(${TABLE}.created) in ('Thu', 'Fri', 'Sat'))
        or (DATE_PART('hour', ${TABLE}.created) < 7 and Dayname(${TABLE}.created) in ('Fri', 'Sat', 'Sun'))) then 'Th-Sa Night'
      else 'Sunday' end ;; }

  dimension: machine {
    label: "Machine"
    type: string
    sql: ${TABLE}.machine ;; }

  dimension: product {
    label: "Product"
    type: string
    sql: ${TABLE}.product ;; }

  dimension: category {
    label: "Category"
    type: string
    sql: ${TABLE}.category ;; }

  dimension: reason_code {
    label: "Reason Code"
    type: string
    sql: ${TABLE}.reason_code ;; }

  dimension: reason_text {
    label: "Reason Text"
    type: string
    sql: ${TABLE}.reason_text ;; }

  dimension: facility {
    label: "Facility"
    type: string
    sql: ${TABLE}.facility ;; }

  measure: total {
    label: "Total"
    type:  sum
    sql: ${TABLE}.total;; }

  measure: regrind_scrap {
    label: "Total Regrind Scrap"
    type:  sum
    sql: ${TABLE}.regrind_scrap ;; }

  measure: scrap {
    label: "Total Scrap"
    type:  sum
    sql: ${TABLE}.scrap ;; }

  measure: regrind {
    label: "Total Regrind"
    type:  sum
    sql: ${TABLE}.regrind ;; }

  measure: finished {
    label: "Finished"
    description: "Total - Regrind Scrap"
    type: number
    sql:  ${total} - ${regrind_scrap} ;; }
}
