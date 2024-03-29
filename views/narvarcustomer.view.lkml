view: narvarcustomer {
  derived_table: {sql:
   Select a.order_id narvar_id,a.tracking_id,a.status,a.created,a.star_rating,a.customer_comment
,b.tracking_numbers, b.order_id,b.item_id
,c.customer_id,c.system, c.trandate
,d.firstname,d.lastname,d.billaddress,d.line1,d.state,d.city,d.zipcode
,b.carrier
,e.fips
,e.county

from analytics.customer_care.narvar_customer_feedback a
left join analytics.sales.fulfillment b on a.tracking_id = b.tracking_numbers
left join analytics.sales.sales_order c on c.order_id = b.order_id
left join analytics_stage.ns.customers d on d.customer_id = c.customer_id
left join analytics.marketing.fips e on d.zipcode = e.zip
where b.order_id is not null ;;
}
  dimension: carrier{
    type: string
    sql: ${TABLE}.carrier ;;
}
  dimension_group: created{
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.created ;;
    }

    dimension: Comment{
      type: string
      sql: ${TABLE}.customer_comment ;;
  }
  dimension: fips{
    type: string
    map_layer_name: us_counties_fips
    sql: ${TABLE}.fips ;;
    }
  dimension: county{
    type: string
    map_layer_name: us_counties_fips
    sql: ${TABLE}.county;;
  }
dimension: status{
  type: string
  sql: ${TABLE}.status ;;
}
  dimension: firstname{
    type: string
    sql: ${TABLE}.firstname ;;
}
  dimension: lastname{
    type: string
    sql: ${TABLE}.lastname ;;
}
  dimension: line1{
    type: string
    sql: ${TABLE}.line1 ;;
}
  dimension: state{
    type: string
    map_layer_name: us_states
    sql: ${TABLE}.state ;;
}
  dimension: city{
    type: string
    sql: ${TABLE}.city ;;
}
  dimension: zipcode{
    type: string
    map_layer_name: us_zipcode_tabulation_areas
    sql: right('00000'||left(${TABLE}.zipcode,5),5) ;;
}
  dimension: stars{
    type: string
    sql: ${TABLE}.star_rating ;;
}
  measure: avg_stars{
    type: average
   value_format: "0.0"
   sql: ${TABLE}.star_rating ;;
  }
  measure: count{
    type: count
  }

}
