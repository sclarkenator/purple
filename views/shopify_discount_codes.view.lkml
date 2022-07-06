view: shopify_discount_codes {

    sql_table_name: analytics.sales.v_main_sales_shopify_discount_codes ;;

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
    # sql: case when split_part(${TABLE}.promo,'-',1) = 'MD' then 'Military'
    #           when split_part(${TABLE}.promo,'-',1) = 'FR' then 'First Responder'
    #           when split_part(${TABLE}.promo,'-',1) = 'MED' then 'Healthcare'
    #           when split_part(${TABLE}.promo,'-',1) = 'STU' then 'Student'
    #           when split_part(${TABLE}.promo,'-',1) = 'TEA' then 'Teacher'
    #           when split_part(${TABLE}.promo,'-',1) = 'TRU' then 'Trucker'
    #           end ;;
    sql: case when split_part(${TABLE}.promo,'-',1) IN ('MD', 'MIL22') then 'Military'
      when split_part(${TABLE}.promo,'-',1) IN ('FR', 'FR22') then 'First Responder'
      when split_part(${TABLE}.promo,'-',1) IN ('MED', 'MD22') then 'Healthcare'
      when split_part(${TABLE}.promo,'-',1) IN ('STU', 'STU22') then 'Student'
      when split_part(${TABLE}.promo,'-',1) IN ('TEA', 'TEA22') then 'Teacher'
      when split_part(${TABLE}.promo,'-',1) IN ('TRU', 'TR22') then 'Trucker'
      end ;;
  }

  dimension: promo_2 {
    hidden:  yes
    label: "Promo - email test"
    type: string
    sql: left(${TABLE}.promo,6) ;;
  }

  }
