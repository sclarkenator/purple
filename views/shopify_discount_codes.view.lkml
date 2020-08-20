view: shopify_discount_codes {
  derived_table: {
    sql:
      select o.id::varchar(100) as etail_order_id
        , o.name as etail_order_name
        , d.code as promo
      from analytics_stage.shopify_us_ft."ORDER" o
        left join analytics_stage.shopify_us_ft.order_discount_code d on d.order_id = o.id
      where d.code is not null
      UNION ALL
      select
        o.order_id as etail_order_id,
        o.order_number as etail_order_name,
        d.discount_code_name as promo
      from analytics.commerce_tools.ct_order_discount_code o
        left join analytics.commerce_tools.ct_discount_code d on o.discount_code_id = d.discount_code_id
    ;;
  }

    dimension: shopify_order_id {
      hidden:  yes
      type: string
      sql: ${TABLE}.shopify_order_id ;;
      primary_key: yes
    }

    dimension: shopify_order_name {
      hidden:  yes
      type: string
      sql: ${TABLE}.shopify_order_name ;;
    }

    dimension: used_promo {
      view_label: "Sales Order"
      label: "     * Used Promo Code"
      description: "Source: shopify.shopify_discount_code"
      type: yesno
      sql: ${TABLE}.promo is not null;;
    }

    dimension: promo {
      group_label: " Advanced"
      view_label: "Sales Order"
      label: "Full Promo Code Used (shopify)"
      description: "Full Promo Code in Shopify. Source:shopify.shopify_discount_code"
      #hidden:  yes
      type: string
      sql: ${TABLE}.promo ;;
    }

  dimension: promo_bucket {
    view_label: "Sales Order"
    group_label: " Advanced"
    label: " Promo Code (bucket)"
    description: "Promo Code Used in Shopify, bucketed (removed unique key). Source:shopify. shopify_discount_code"
    #hidden:  yes
    type: string
    sql: split_part(${TABLE}.promo,'-',1) ;;
  }

  dimension: promo_2 {
    hidden:  yes
    label: "Promo - email test"
    type: string
    sql: left(${TABLE}.promo,6) ;;
  }

  }
