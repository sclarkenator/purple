view: production_report {

  derived_table: {
    sql:  select created,
                  CASE machine WHEN 'Glue Roller 3' THEN 'Core Station 1' ELSE machine END as machine,
                  product,
                  CASE WHEN machine like 'IMM%' THEN CASE WHEN product like '%Pillow%' THEN 'Pillow' ELSE 'Cushion' END ELSE product END as category,
                  total,
                  reason_code,
                  reason_text,
                  regrind,
                  scrap,
                  regrind + scrap as regrind_scrap
          from (
                  SELECT m.machine_name as machine,
                          p.product_name as product,
                          pl.created,
                          pl.reason_code,
                          pl.reason_text,
                          count(*) AS total,
                          SUM(CASE WHEN pl.status_id = 3 THEN 1 ELSE 0 END) AS regrind,
                          SUM(CASE WHEN pl.status_id = 2 THEN 1 ELSE 0 END) AS scrap
                  FROM analytics_stage.ipad_stg.production_log pl
                    JOIN analytics_stage.ipad_stg.machine m ON pl.machine_id = m.machine_id
                    JOIN analytics_stage.ipad_stg.product p on pl.product_id = p.product_id
                  GROUP BY m.machine_name
                          ,p.product_name
                          ,pl.created
                          ,pl.reason_code
                          ,pl.reason_text
                )t
          ;;
  }

  dimension_group: timestamp {
    type: time
    timeframes: [
      raw,
      hour,
      hour_of_day,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: yes
    datatype: timestamp
    sql: ${TABLE}.created ;;
  }

  dimension: day_night_shift {
    type: string
    label: "Day or Night Shift"
    sql: case when date_part('hour', ${TABLE}.created) between 7 and 18 then 'DAY' else 'NIGHT' end ;;
  }

  dimension: shift {
    type: string
    sql:             case when DATE_PART('hour', ${TABLE}.created) between 7 and 18 and Dayname(${TABLE}.created) in ('Mon', 'Tue', 'Wed') then 'M-W Day'
                    when DATE_PART('hour', ${TABLE}.created) between 7 and 18 and Dayname(${TABLE}.created) in ('Thu', 'Fri', 'Sat') then 'Th-Sa Day'
                    when ((DATE_PART('hour', ${TABLE}.created) > 18 and Dayname(${TABLE}.created) in ('Mon', 'Tue', 'Wed'))
                      or (DATE_PART('hour', ${TABLE}.created) < 7 and Dayname(${TABLE}.created) in ('Tue', 'Wed', 'Thu'))) then 'M-W Night'
                    when ((DATE_PART('hour', ${TABLE}.created) > 18 and Dayname(${TABLE}.created) in ('Thu', 'Fri', 'Sat'))
                      or (DATE_PART('hour', ${TABLE}.created) < 7 and Dayname(${TABLE}.created) in ('Fri', 'Sat', 'Sun'))) then 'Th-Sa Night'
                    else 'Sunday' end ;;
  }

  dimension: machine {
    type: string
    sql: ${TABLE}.machine ;;
  }

  dimension: product {
    type: string
    sql: ${TABLE}.product ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: reason_code {
    type: string
    sql: ${TABLE}.reason_code ;;
  }

  dimension: reason_text {
    type: string
    sql: ${TABLE}.reason_text ;;
  }

  measure: total {
    type:  sum
    sql: ${TABLE}.total;;
  }

  measure: regrind_scrap {
    type:  sum
    sql: ${TABLE}.regrind_scrap ;;
  }

  measure: scrap {
    type:  sum
    sql: ${TABLE}.scrap ;;
  }

  measure: regrind {
    type:  sum
    sql: ${TABLE}.regrind ;;
 }

  measure: finished {
    type: number
    sql:  ${total} - ${regrind_scrap} ;;
  }
}
