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

    dimension: used_promo {
      label: "     * Used Promo Code"
      view_label: "Sales Order"
      type: yesno
      sql: ${TABLE}.promo is not null;;
    }

    dimension: promo {
      group_label: " Advanced"
      #description: "Full Promo Code in Shopify"
      #hidden:  yes
      view_label: "Sales Order"
      label: "Full Promo Code Used (shopify)"
      type: string
      sql: ${TABLE}.promo ;;
    }

  dimension: promo_bucket {
    #group_label: " Advanced"
    description: "Promo Code Used in Shopify, bucketed (removed unique key)"
    #hidden:  yes
    view_label: "Sales Order"
    label: "Promo Code (bucket)"
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
