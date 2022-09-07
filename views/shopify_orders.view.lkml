#view: etail_orders {
view: shopify_orders {
  #sql_table_name: ANALYTICS_STAGE.SHOPIFY_US_FT."ORDER" ;;
  derived_table: {
    sql:
--      WITH LINES AS (
--        SELECT
--          ORDER_ID,
--          SUM(PRODUCT_DISCOUNT * ORDERED_QTY)+SUM(CART_DISCOUNT) AS TOTAL_DISCOUNT //Does not include shipping discounts
--        FROM analytics.commerce_tools.ct_order_line
--        GROUP BY ORDER_ID
--      ), ct AS (
--        SELECT
--            o.ORDER_ID AS ID,
--            o.CUSTOMER_ID AS USER_ID,
--            convert_timezone('America/Denver',o.CREATED) AS CREATED_AT,
--            o.GROSS_AMT AS SUBTOTAL_PRICE,
--            o.TOTAL_GROSS AS TOTAL_PRICE,
--            o.ORDER_NUMBER AS NAME,
--            l.TOTAL_DISCOUNT AS TOTAL_DISCOUNTS,
--            o.TOTAL_TAX AS TOTAL_TAX,
--            o.SESSION_ID AS CHECKOUT_TOKEN,
--            'paid' as FINANCIAL_STATUS
--        FROM analytics.commerce_tools.ct_order o
--        INNER JOIN LINES l ON o.ORDER_ID = l.ORDER_ID
--      )

      select
        'Shopify US' AS SRC, ID::varchar(100) AS ID,USER_ID::varchar(100) AS USER_ID,convert_timezone('America/Denver',CREATED_AT) as CREATED_AT,SUBTOTAL_PRICE,TOTAL_PRICE,NAME,TOTAL_DISCOUNTS,TOTAL_TAX,CHECKOUT_TOKEN,FINANCIAL_STATUS
      from analytics_stage.shopify_us_ft."ORDER"
      where created_at < current_date
      UNION
      select
        'Shopify CA' AS SRC, ID::varchar(100) AS ID,USER_ID::varchar(100) AS USER_ID,convert_timezone('America/Denver',CREATED_AT) as CREATED_AT,SUBTOTAL_PRICE,TOTAL_PRICE,NAME,TOTAL_DISCOUNTS,TOTAL_TAX,CHECKOUT_TOKEN,FINANCIAL_STATUS
      from analytics_stage.shopify_ca_ft."ORDER"
      where created_at < current_date
      UNION
      select
        'Shopify Outlet' AS SRC, ID::varchar(100) AS ID,USER_ID::varchar(100) AS USER_ID,convert_timezone('America/Denver',CREATED_AT) as CREATED_AT,SUBTOTAL_PRICE,TOTAL_PRICE,NAME,TOTAL_DISCOUNTS,TOTAL_TAX,CHECKOUT_TOKEN,FINANCIAL_STATUS
      from analytics_stage.shopify_outlet."ORDER"
      where created_at < current_date
      UNION
      select 'Shopify_API' AS SRC, ID::varchar(100) AS ID, USER_ID::varchar(100) AS USER_ID,created as created_at,subtotal_price,subtotal_price TOTAL_PRICE, NAME,0 TOTAL_DISCOUNTS,0 TOTAL_TAX,CHECKOUT_TOKEN,'NA' FINANCIAL_STATUS
      from analytics.sales.v_shopify_subtotal
      where created_at >= current_date
--      UNION
--      select 'Commerce Tools' AS SRC, ID::varchar(100) AS ID,USER_ID::varchar(100) AS USER_ID,convert_timezone('America/Denver',CREATED_AT) as CREATED_AT,SUBTOTAL_PRICE,TOTAL_PRICE,NAME,TOTAL_DISCOUNTS,TOTAL_TAX,CHECKOUT_TOKEN,FINANCIAL_STATUS
--      from ct

;;
#     sql:
#       select
#         ID,USER_ID,CREATED_AT,SUBTOTAL_PRICE,TOTAL_PRICE,NAME,TOTAL_DISCOUNTS,TOTAL_TAX,CHECKOUT_TOKEN
#       from analytics_stage.shopify_us_ft."ORDER"
#       UNION
#       select
#         ID,USER_ID,CREATED_AT,SUBTOTAL_PRICE,TOTAL_PRICE,NAME,TOTAL_DISCOUNTS,TOTAL_TAX,CHECKOUT_TOKEN
#       from analytics_stage.shopify_ca_ft."ORDER"
#       UNION
#       select
#         ID,USER_ID,CREATED_AT,SUBTOTAL_PRICE,TOTAL_PRICE,NAME,TOTAL_DISCOUNTS,TOTAL_TAX,CHECKOUT_TOKEN
#       from analytics_stage.shopify_outlet."ORDER"
#     ;;
  }

  dimension: financial_status {
    label: "Status"
    description: "Status codes of paid/refunded"
    type: string
    sql: ${TABLE}.financial_status ;;
  }

  dimension: id {
    primary_key: yes
    label: "Shopify Order"
    hidden:  yes
    type: string
    sql: ${TABLE}.id ;;
  }

  measure: discounts {
    label: "Total Discounts"
    description: "All discounts given in Shopify"
    type: sum
    sql: ${TABLE}.total_discounts ;;
  }

  measure: total_tax {
    label: "Total Tax Amount"
    description: "All discounts given in Shopify"
    type: sum
    sql: ${TABLE}.total_tax ;;
  }

  measure: count {
    label: "Order Count"
    description: "How many unique orders were placed?"
    type: count
  }

  measure: gross_sales {
    label: "Gross Sales"
    description: "Gross product sales in Shopify"
    value_format: "$#,##0"
    type: sum
    sql: ${TABLE}.subtotal_price ;;
  }

  measure: tax_dif {
    label: "Taxes Difference ($)"
    description: "Positive Value Difference between Shopify and Netsuite Taxes"
    type: sum
    sql: case when ${TABLE}.total_tax > ${sales_order.tax_amt} then ${TABLE}.total_tax - ${sales_order.tax_amt}
      else ${sales_order.tax_amt} - ${TABLE}.total_tax end ;;
  }

  measure: last_sync_date {
    group_label: " Sync"
    type: date
    label: "Sync date"
    description: "Date table was last refreshed"
    sql: max(${created_raw}) ;;}

  measure: last_sync_time {
    group_label: " Sync"
    type: date_time_of_day
    label: "Sync time"
    description: "Date table was last refreshed"
    convert_tz: yes
    sql: max(${created_raw}) ;;}

  dimension: order_ref {
    description: "Netsuite Reference ID"
    label: "Related_tranid"
    hidden:  yes
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: checkout_token {
    description: "checkout token linking shopify to heap, hotjar"
    label: "Checkout Token"
    hidden:  yes
    type: string
    sql: ${TABLE}.checkout_token ;;
  }

  dimension: call_in_order_Flag {
    view_label: "Sales Order"
    #group_label: " Advanced"
    label: "     * Is Call center order"
    description: "Draft orders created by call center agents. Source: looker.calculation"
    type: yesno
    sql: ${TABLE}.user_id is not null and ${sales_order.showroom} = 'FALSE' ;;
  }

  dimension: scr {
    hidden: yes
    type: string
    sql: ${TABLE}.scr ;;
  }

  dimension: tax_match {
    label: "Taxes Match"
    hidden: no
    description: "Taxes between Shopify and Netsuite Match"
    type: yesno
    sql: ${TABLE}.total_tax = ${sales_order.tax_amt} ;;
  }

  dimension: user_id {
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: created  {
    type: time
    timeframes: [
      date,
      day_of_week,
      day_of_year,
      day_of_month,
      month_num,
      hour,
      hour_of_day,
      week_of_year,
      day_of_week_index,
      minute15,
      week,
      month,
      quarter,
      year,
      raw
    ]
    convert_tz: yes
    datatype: timestamp
    sql: ${TABLE}.created_at ;;
  }
}
