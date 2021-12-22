view: beds_per_door {
  derived_table: {
    sql: WITH w_partner_details AS
      (
                  SELECT
                      (TO_CHAR(DATE_TRUNC('week', sa.date), 'YYYY-MM-DD')) AS dynamic_week
                      ,wa.short_name as wholesale_parent_account_name
                      ,COALESCE(SUM(CASE WHEN TO_CHAR(sa."DATE" , 'DY') = 'Sun' THEN COALESCE(sa.total_stores_to_date,0) ELSE NULL END), 0) AS total_stores
                      ,COALESCE(SUM(sa.sales_mattress_quantity), 0) AS mattress_qty_ordered
                  FROM
                      datagrid.prod.summary_analytics AS sa
                      LEFT JOIN datagrid.prod.wholesale_account as wa ON sa.account = wa.licensee
                  WHERE
                      sa.channel = 'Wholesale'
                      AND sa.date >= DATE_TRUNC('week', CURRENT_DATE()) - 455
                  GROUP BY 1, 2
                  HAVING total_stores > 0)
      ,first_store_dates AS
      (
                  SELECT
                      wholesale_parent_account_name
                      ,min(dynamic_week) as first_store_date
                  FROM
                      w_partner_details
                  GROUP BY 1)
      ,trailing_average AS
      (
                  SELECT
                      w.dynamic_week
                      ,w.wholesale_parent_account_name
                      ,DATEDIFF('day', f.first_store_date, DATE_TRUNC('week', CURRENT_DATE())) AS days_open
                      ,w.total_stores
                      ,w.mattress_qty_ordered
                      ,AVG(w.mattress_qty_ordered / w.total_stores) OVER
                          (PARTITION BY w.wholesale_parent_account_name
                           ORDER BY w.dynamic_week ASC
                           ROWS BETWEEN 13 PRECEDING AND CURRENT ROW)::decimal(6,2) AS trailing_13w_avg
                      ,(CASE WHEN days_open <= 120 THEN 'Opened within 120 Days' ELSE 'Opened > 120 Days Ago' END) AS parent_first_store_age
                  FROM
                      w_partner_details w
                      LEFT JOIN first_store_dates f on f.wholesale_parent_account_name = w.wholesale_parent_account_name)
      SELECT
          dynamic_week
          ,wholesale_parent_account_name
          ,days_open
          ,total_stores
          ,mattress_qty_ordered
          ,trailing_13w_avg
          ,parent_first_store_age
          ,GET(
              ARRAY_AGG(trailing_13w_avg)
              WITHIN GROUP (ORDER BY dynamic_week ASC)
              OVER (PARTITION BY wholesale_parent_account_name)
              ,0)::decimal(6,2) AS current_trailing_13w_avg
          ,((current_trailing_13w_avg::integer / 2)::integer * 2) AS peer_bucket
      FROM
          trailing_average
       ;;
  }

######################################################################################
## MEASURES
######################################################################################

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: total_stores {
    type: number
    sql: ${TABLE}."TOTAL_STORES" ;;
  }

  measure: mattress_qty_ordered {
    type: number
    sql: ${TABLE}."MATTRESS_QTY_ORDERED" ;;
  }

  measure: trailing_13_w_avg {
    type: number
    sql: ${TABLE}."TRAILING_13W_AVG" ;;
  }

  measure: days_open {
    type: number
    sql: ${TABLE}."DAYS_OPEN" ;;
  }

######################################################################################
## DIMENSIONS
######################################################################################

  dimension: dynamic_week {
    type: string
    sql: ${TABLE}."DYNAMIC_WEEK" ;;
  }

  dimension: wholesale_parent_account_name {
    type: string
    sql: ${TABLE}."WHOLESALE_PARENT_ACCOUNT_NAME" ;;
  }

  dimension: parent_first_store_age {
    hidden: yes
    type: string
    sql: ${TABLE}."PARENT_FIRST_STORE_AGE" ;;
  }

  dimension: current_trailing_13_w_avg {
    type: number
    sql: ${TABLE}."CURRENT_TRAILING_13W_AVG" ;;
  }

  dimension: peer_bucket {
    type: number
    sql: ${TABLE}."PEER_BUCKET" ;;
  }

  set: detail {
    fields: [
      dynamic_week,
      wholesale_parent_account_name,
      days_open,
      total_stores,
      mattress_qty_ordered,
      trailing_13_w_avg,
      parent_first_store_age,
      current_trailing_13_w_avg,
      peer_bucket
    ]
  }
}
