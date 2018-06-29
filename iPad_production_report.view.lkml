view: production_report {

  derived_table: {
    sql:  select timestamp,
                  CASE machine WHEN 'Glue Roller 3' THEN 'Core Station 1' ELSE machine END as machine,
                  product,
                  CASE WHEN machine like 'IMM%' THEN CASE WHEN product like '%Pillow%' THEN 'Pillow' ELSE 'Cushion' END ELSE product END as category,
                  total as "total",
                  regrind + scrap as "regrind_scrap"
          from (
                  SELECT m.name as machine,
                          p.name as product,
                          pl.timestamp,
                          count(*) AS total,
                          SUM(CASE WHEN s.name = 'Regrind' THEN 1 ELSE 0 END) AS regrind,
                          SUM(CASE WHEN s.name = 'Scrap' THEN 1 ELSE 0 END) AS scrap
                  FROM production_log pl
                    JOIN machines m ON pl.machines_id = m.id
                    JOIN statuses s ON pl.status_id = s.status_id
                    JOIN products p on pl.products_id = p.id
                  where timestamp >= '2018-06-24'
                  GROUP BY m.name
                          ,p.name
                          ,pl.timestamp
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
    sql: ${TABLE}.timestamp ;;
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
    sql: ${TABLE}.total ;;
  }

  measure: regrind_scrap {
    type:  sum
    sql: ${TABLE}.regrind_scrap ;;
  }

}
