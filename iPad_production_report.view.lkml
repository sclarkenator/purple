view: production_report {

  derived_table: {
    sql:  select created,
                  CASE machine WHEN 'Glue Roller 3' THEN 'Core Station 1' ELSE machine END as machine,
                  product,
                  CASE WHEN machine like 'IMM%' THEN CASE WHEN product like '%Pillow%' THEN 'Pillow' ELSE 'Cushion' END ELSE product END as category,
                  total,
                  regrind + scrap as "regrind_scrap"
          from (
                  SELECT m.machine_name as machine,
                          p.product_name as product,
                          pl.created,
                          count(*) AS total,
                          SUM(CASE WHEN pl.status_id = 3 THEN 1 ELSE 0 END) AS regrind,
                          SUM(CASE WHEN pl.status_id = 2 THEN 1 ELSE 0 END) AS scrap
                  FROM analytics_stage.ipad_stg.production_log pl
                    JOIN analytics_stage.ipad_stg.machine m ON pl.machine_id = m.machine_id
                    JOIN analytics_stage.ipad_stg.product p on pl.product_id = p.product_id
                  GROUP BY m.machine_name
                          ,p.product_name
                          ,pl.created
                )t
          ;;
  }

  dimension_group: timestamp {
    type: time
    timeframes: [
      raw,
      hour,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: yes
    datatype: timestamp
    sql: ${TABLE}.created ;;
  }

  dimension: shift {
    type: string
    sql: case when ${timestamp_hour} between 07:00 and 19:00 then 'DAY' else 'NIGHT' end ;;
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

  measure: total {
    type:  sum
    sql: ${TABLE}.total;;
  }

  measure: regrind_scrap {
    type:  sum
    sql: ${TABLE}.regrind_scrap ;;
  }

  measure: finished {
    type: number
    sql:  ${total} - ${regrind_scrap} ;;
  }
}
