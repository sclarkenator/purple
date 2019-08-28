view: shopify_discount_codes {
  derived_table: {
  sql:
    select o.id as shopify_order_id
        , o.name as shopify_order_name
        , d.code as promo
    from analytics_stage.shopify_us_ft."ORDER" o
    left join analytics_stage.shopify_us_ft.order_discount_code d on d.order_id = o.id
    where d.code is not null
  ;; }

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

    dimension: promo {
      #hidden:  yes
      label: "Promo (shopify)"
      type: string
      sql: ${TABLE}.promo ;;
    }

  dimension: promo_2 {
    #hidden:  yes
    label: "Promo - email test"
    type: string
    sql: left(${TABLE}.promo,6) ;;
  }

  }
