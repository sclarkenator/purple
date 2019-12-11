view: state_tax_reconciliation {
   derived_table: {
     sql: select distinct so.created
    , so.order_id
    , so.related_tranid
    , so.customer_id netsuite_internal_customer_id
    , c.name netsuite_customer_id
    , so.gross_amt netsuite_gross_amt
    , so.tax_amt netsuite_tax_amt
    , spf.subtotal_price shopify_gross_amt
    , spf.total_tax shopify_tax_amt
    --, spf.shipping_address_city
    --, spf.shipping_address_province_code
    --, spf.shipping_address_zip
    , sol.city
    , sol.state
    , sol.zip
    --, case when lower(sol.city) = lower(spf.shipping_address_city) then 'city_match' else 'city_different' end city_check
    , so.gross_amt - spf.subtotal_price as gross_difference
    , so.tax_amt - spf.total_tax as tax_difference
    , so.payment_method
from sales_order so
    join "ANALYTICS_STAGE"."SHOPIFY_US_FT"."ORDER" spf on spf.name = so.related_tranid
    left join sales_order_line sol on sol.order_id = so.order_id and sol.system = so.system
    left join analytics_stage.netsuite.customers c on c.customer_id = so.customer_id
where so.created >= '2018-01-01'
having tax_difference > 0
order by so.created desc
       ;;
   }

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.order_id||'-'||NVL(${TABLE}.zip,'-') ;;
  }

  dimension_group: created {
    label: "Order"
    description:  "Time and date order was placed"
    hidden: yes
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.Created) ;; }

  dimension: order_id {
    label: "Order ID"
    hidden: yes
    html: <a href = "https://system.na2.netsuite.com/app/accounting/transactions/salesord.nl?id={{value}}&whence=" target="_blank"> {{value}} </a> ;;
    description: "This is Netsuite's internal ID. This will be a hyperlink to the sales order in Netsuite."
    type: number
    sql: ${TABLE}.ORDER_ID ;; }

  dimension: related_tranid {
    hidden: yes
    label: "Related Transaction ID"
    description: "Netsuite's internal related transaction id"
    type: string
    sql: ${TABLE}.RELATED_TRANID ;; }

  dimension: netsuite_customer_id {
    label: "Netsuite Customer ID"
    hidden: yes
    type: number
    sql: ${TABLE}.netsuite_customer_id ;; }

  dimension: netsuite_internal_customer_id {
    label: "Netsuite Internal Customer ID"
    hidden: yes
    html: <a href = "https://system.na2.netsuite.com/app/common/entity/custjob.nl?id={{value}}"> {{value}} </a> ;;
    description: "This is Netsuite's internal Customer ID. This will be a hyperlink to the customer record in Netsuite."
    type: number
    sql: ${TABLE}.netsuite_internal_customer_id ;; }

  measure: netsuite_gross_amt {
    type: sum
    hidden: yes
    description: "Value of sale in Netsuite"
    value_format: "$#,##0.00"
    sql: ${TABLE}.netsuite_gross_amt ;; }

  measure: netsuite_tax_amt {
    type: sum
    hidden: yes
    description: "Value of tax in Netsuite"
    value_format: "$#,##0.00"
    sql: ${TABLE}.netsuite_tax_amt ;; }

  measure: shopify_gross_amt {
    type: sum
    hidden: yes
    description: "Value of sale in Shopify"
    value_format: "$#,##0.00"
    sql: ${TABLE}.shopify_gross_amt ;; }

    measure: shopify_tax_amt {
    type: sum
    hidden: yes
    description: "Value of tax in Shopify"
    value_format: "$#,##0.00"
    sql: ${TABLE}.shopify_tax_amt ;; }

  measure: gross_amt_difference {
    description: "Netsuite Gross Amt - Shopify Gross Amt"
    type: sum
    hidden: yes
    value_format: "$#,##0.00"
    sql: ${TABLE}.netsuite_gross_amt - ${TABLE}.shopify_gross_amt   ;;
  }

  measure: tax_amt_difference {
    description: "Netsuite Tax Amt - Shopify Tax Amt"
    type: sum
    hidden: yes
    value_format: "$#,##0.00"
    sql: ${TABLE}.netsuite_tax_amt - ${TABLE}.shopify_tax_amt   ;;
  }

  dimension: city {
    label: "City"
    group_label: "Customer Address"
    view_label: "Customer"
    hidden: yes
    type: string
    sql: ${TABLE}.CITY ;; }


  dimension: state {
    label: "State from Customer"
    #group_label: "Customer Address"
    #view_label: "Customer"
    type: string
    hidden: yes
    sql: ${TABLE}.state ;; }

  dimension: zip {
    view_label: "Customer"
    group_label: "Customer Address"
    hidden: yes
    type: zipcode
    map_layer_name: us_zipcode_tabulation_areas
    sql: substr(${TABLE}.ZIP,1,5) ;; }


 }
