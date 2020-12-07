view: shopify_users {
  derived_table: {
    sql:
    select id, user_id
    from analytics_stage.shopify_us_ft."ORDER"
    where user_id is not null
    union all
    select id, user_id
    from analytics_stage.shopify_ca_ft."ORDER"
    where user_id is not null
    union all
    select id, user_id
    from analytics_stage.shopify_outlet."ORDER"
    where user_id is not null
  ;;
  }
  dimension: id {
    type: string
    hidden: yes
    sql: ${TABLE}.id ;;
  }
  dimension: user_id {
    type: string
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

}
