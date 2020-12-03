view: retail_base {

derived_table:
{
  sql: select date, showroom_name
  from ANALYTICS.UTIL.WAREHOUSE_DATE d
  left join (
    select showroom_name,
    min(trandate) mindate,
    max(trandate) maxdate
    from sales.sales_order
    where showroom_name is not null
    group by 1
  ) z on z.mindate <= d.date and (z.maxdate>= d.date OR z.maxdate>dateadd(day,-3,current_date))
  where date between '2019-01-01' and current_date;;
}

  dimension: PK {
    primary_key: yes
    type: string
    hidden: yes
    sql: ${date_date}||-||${store_id} ;;
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
    sql: ${TABLE}.date ;;
  }

dimension: store_id{
    description: "Owned Retail Store Location Name"
    hidden: yes
    label: "Location ID"
    type: string
    sql: ${TABLE}.showroom_name ;;
  }


}
