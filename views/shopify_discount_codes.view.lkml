view: shopify_discount_codes {
  derived_table: {
    sql:
    select s.id::varchar(100) as etail_order_id
        , s.name as etail_order_name
        , d.code as promo
      from analytics_stage.shopify_us_ft."ORDER" s
        left join analytics_stage.shopify_us_ft.order_discount_code d on d.order_id = s.id
      where d.code is not null
      UNION ALL
      select
        co.order_id as etail_order_id,
        co.order_number as etail_order_name,
        c.coupon_code as promo
     from analytics.commerce_tools.ct_order_line_discount c
      left join analytics.commerce_tools.ct_order_line as col on col.order_line_id = c.order_line_id
      left join ANALYTICS.COMMERCE_TOOLS.CT_ORDER co on col.order_id=co.order_id


    ;;
  }


    dimension: shopify_order_id {
      hidden:  yes
      type: string
      sql: ${TABLE}.shopify_order_id ;;
      primary_key: yes
    }

    dimension: etail_order_name {
      hidden:  yes
      type: string
      sql: ${TABLE}.etail_order_name ;;
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

  dimension: sheer_id {
    view_label: "Sales Order"
    group_label: " Advanced"
    label: "SheerID Promo Code"
    description: "Promo Code Used in Shopify, bucketed (removed unique key). Source:shopify. shopify_discount_code"
    hidden:  yes
    type: string
    sql: case when split_part(${TABLE}.promo,'-',1) = 'MD' then 'Military'
              when split_part(${TABLE}.promo,'-',1) = 'FR' then 'First Responder'
              when split_part(${TABLE}.promo,'-',1) = 'MED' then 'Healthcare'
              when split_part(${TABLE}.promo,'-',1) = 'STU' then 'Student'
              when split_part(${TABLE}.promo,'-',1) = 'TEA' then 'Teacher'
              when split_part(${TABLE}.promo,'-',1) = 'TRU' then 'Trucker'
              end ;;
  }

  dimension: promo_2 {
    hidden:  yes
    label: "Promo - email test"
    type: string
    sql: left(${TABLE}.promo,6) ;;
  }

  }
