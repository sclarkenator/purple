view: retail_base {

derived_table:
{
  sql: select date, location_name
  from ANALYTICS.UTIL.WAREHOUSE_DATE d
  left join (
    select showroom_name location_name,
    min(trandate) mindate,
    max(trandate) maxdate
    from sales.sales_order
    where location_name is not null
    group by 1
  ) z on z.mindate <= d.date and (z.maxdate>= d.date OR z.maxdate>dateadd(day,-3,current_date))
  where date between '2019-01-01' and current_date;;
}


dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."date" ;;
  }


dimension: location {
    description: "Owned Retail Store Location Name"
    type: string
    sql: ${TABLE}."location_name" ;;
  }

}
