view: agent_draft_orders {
  derived_table: {
    sql:  select
        ID,USER_ID,CREATED_AT,SUBTOTAL_PRICE,TOTAL_PRICE,NAME,TOTAL_DISCOUNTS,TOTAL_TAX
      from analytics_stage.shopify_us_ft."ORDER"
      UNION
      select
        ID,USER_ID,CREATED_AT,SUBTOTAL_PRICE,TOTAL_PRICE,NAME,TOTAL_DISCOUNTS,TOTAL_TAX
      from analytics_stage.shopify_ca_ft."ORDER"
      UNION
      select
        ID,USER_ID,CREATED_AT,SUBTOTAL_PRICE,TOTAL_PRICE,NAME,TOTAL_DISCOUNTS,TOTAL_TAX
      from analytics_stage.shopify_outlet."ORDER";;

    }

    measure: count {
      type: count
    }

    dimension: id {
      label: "Shopify Order ID"
      type: number
      primary_key: yes
      sql: ${TABLE}."ID" ;;
    }

    dimension: user_id {
      type: number
      # hidden: yes
      sql: ${TABLE}."USER_ID" ;;
    }

    dimension: name {
      type: string
      label: "Shopify Reference ID"
      sql: ${TABLE}."NAME" ;;
    }

    dimension_group: created_at {
      type: time
      timeframes: [raw,
        date,
        week,
        month,
        quarter,
        year]
      sql: ${TABLE}."CREATED_AT" ;;
    }

    dimension: subtotal_price {
      type: number
      sql: ${TABLE}."SUBTOTAL_PRICE" ;;
    }

    dimension: total_discounts {
      type: number
      sql: ${TABLE}."TOTAL_DISCOUNTS" ;;
    }

    dimension: total_price {
      type: number
      sql: ${TABLE}."TOTAL_PRICE" ;;
    }
    dimension: total_tax {
      type: number
      sql: ${TABLE}."TOTAL_TAX" ;;
    }
  }
