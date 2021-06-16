view: bridge_by_agent {
  derived_table: {
    sql:
      select u.email
          --, e.completed_at::date, c.title
          , min(case when c.title = 'Sales Methodology' then e.completed_at::date end) as sales_methodology
          , min(case when c.title = 'Selling the Sleep System: Bases' then e.completed_at::date end) as selling_the_sleep_system_bases
          , min(case when c.title = 'Required Reads - SALES (5/24-5/28)' then e.completed_at::date end) as rr_sales_5_24
      from analytics.hr.bridge_enrollment e
      left join analytics.hr.bridge_course c on c.id = e.course_id
      left join analytics.hr.bridge_user u on u.id = e.learner_id
      where e.completed_at is not null
          and u.email is not null
          and c.title in ('Sales Methodology','Selling the Sleep System: Bases','Required Reads - SALES (5/24-5/28)')
      group by 1
    ;;
  }
  dimension: email {primary_key:yes}
  dimension: sales_methodology {}
  dimension: selling_the_sleep_system_bases {}
  dimension: rr_sales_5_24 {}

  dimension: sales_methodogy_tf {
    type: yesno
    sql: ${sales_methodology}<${cc_traffic.event_date} ;;
  }
  dimension: selling_the_sleep_system_bases_tf {
    type: yesno
    sql: ${selling_the_sleep_system_bases}<${cc_traffic.event_date} ;;
  }
  dimension: rr_sales_5_24_tf {
    type: yesno
    sql: ${rr_sales_5_24}<${cc_traffic.event_date} ;;
  }
}
