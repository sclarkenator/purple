view: mymove {
  derived_table: {sql:
    select s.order_id
      , s.system
      , s.created as order_created
      , s.email
      , m.created as mymove_created
      , datediff('day',m.created,s.created) as days_old
    from sales.sales_order s
    left join marketing.mymove_contact m on m.email = s.email and m.created <= s.created
    where m.created is not null ;;
  }

  dimension: key {
    hidden: yes
    primary_key: yes
    type: string
    sql: ${TABLE}.order_id || ${TABLE}.sytem ;;
  }

  dimension: order_id {
    hidden: yes
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension: system {
    hidden: yes
    type: string
    sql: ${TABLE}.system ;;
  }

  dimension: email {
    hidden: yes
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: mymove_created {
    hidden: yes
    type: date_time
    sql: ${TABLE}.mymove_created ;;
  }

  dimension: days_old {
    hidden: yes
    type: number
    sql: ${TABLE}.days_old ;;
  }

  dimension: date_bucket {
    view_label: "Marketing Attribution"
    group_label: "Advanced"
    label: "My Move - Age Bucket"
    description: "Days between create in my move and order (7/30/60/60+)"
    type: string
    sql: case when ${TABLE}.days_old is null then 'NA'
      when ${TABLE}.days_old <= 7 then '0-7'
      when ${TABLE}.days_old <= 30 then '7-30'
      when ${TABLE}.days_old <= 60 then '30-60'
      else '60+' end ;;
  }

}
