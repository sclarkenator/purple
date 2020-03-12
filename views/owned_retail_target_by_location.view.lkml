view: owned_retail_target_by_location {
sql_table_name: ANALYTICS.CSV_UPLOADS.RETAIL_STORE_TARGETS ;;

  dimension: store_id {
    label: "Retail store ID"
    description: "Store ID"
    type: string
    sql: ${TABLE}.store_id ;;
    hidden: no
}


dimension: store_name{
  label: "Store Name"
  description: "Manually grouped from store ID"
  type: string
  sql: case when ${store_id} = 'CA-01' then 'San Diego'
  when ${store_id} = 'CA-02' then 'Santa Clara'
  when ${store_id} = 'CA-03' then 'Santa Monica'
  when ${store_id} = 'WA-01' then 'Seattle'
  when ${store_id} in ('FO-01','FO_01') then 'Salt Lake'
  when ${store_id} = 'UT-01' then 'Showroom'
  else ${store_id} end;;}

  dimension: start_date{
    hidden: no
    type: date
    sql: ${TABLE}.start_date ;;
}

  dimension: end_date {
    hidden: no
    type: date
    sql: ${TABLE}.end_date ;;
}

  measure: target {
    label: " Target ($)"
    description: "Target amount for owned retail"
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}.target ;;
  }

}
