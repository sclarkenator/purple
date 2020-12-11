view: cc_headcount_bydate {
  derived_table: {
    sql:
      select z.date
        , y.*
      from util.warehouse_date z
      left join customer_care.agent_lkp y on y.created::date <= z.date and nvl(y.inactive::date,current_date::date) > z.date
      where z.date between '2019-01-01' and current_date
    ;;
  }

  dimension_group: by {
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.date ;;
  }

  dimension: Before_today{
    group_label: "By Date"
    label: "z - Is Before Today (mtd)"
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: yesno
    sql: ${TABLE}.date < current_date;; }

  dimension: current_week_num{
    group_label: "By Date"
    label: "z - Before Current Week"
    description: "Yes/No for if the date is before the previous week"
    type: yesno
    sql: date_trunc(week, ${TABLE}.date::date) < date_trunc(week, current_date) ;;}
  #sql: date_part('week',${TABLE}.date) < date_part('week',current_date);; }
  #sql: date_part('week',${TABLE}.date) < 53;; }

  dimension: prev_week{
    group_label: "By Date"
    label: "z - Previous Week"
    description: "Yes/No for if the date is the previous week"
    type: yesno
    sql:  date_trunc(week, ${TABLE}.date::date) = dateadd(week, -1, date_trunc(week, current_date)) ;; }

  dimension: incontact_id {
    type: string
    #hidden: yes
    sql:  ${TABLE}.incontact_id ;;
  }

  dimension: pk {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${by_date} || ${incontact_id} ;;
  }


  dimension: zendesk_id {
    #hidden: yes
    type:  number
    sql: ${TABLE}.zendesk_id ;;
  }

  dimension: zendesk_sell_id {
    #hidden: yes
    type:  number
    sql: ${TABLE}.zendesk_sell_user_id ;;
  }

  dimension: shopify_id {
    type:  number
    #hidden: yes
    sql: ${TABLE}.shopify_id ;;
  }

  dimension: shopify_id_pos {
    #hidden: yes
    type:  number
    sql: ${TABLE}.shopify_id_pos ;;
  }

  dimension: retail {
    #hidden: yes
    type:  yesno
    sql: ${TABLE}.retail ;;
  }

  dimension: email {
    type:  string
    sql: ${TABLE}.email ;;
  }

  dimension: name {
    type:  string
    sql: ${TABLE}.name ;;
  }

  dimension: is_supervisor {
    #hidden: yes
    type: yesno
    sql: ${TABLE}.supervisor ;;
  }

  dimension_group: inactive {
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    datatype: timestamp
    sql: ${TABLE}.inactive ;;
  }

  dimension_group: created {
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.created ;; }

  dimension: team_type {
    #hidden: yes
    type:  string
    sql: ${TABLE}.team_type ;;
  }

  dimension: employee_type {
    #hidden: yes
    type:  string
    sql: ${TABLE}.employee_type ;;
  }

  dimension_group: purple_with_purpose {
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.purple_with_purpose ;;
  }

  dimension_group: mentor {
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.mentor ;;
  }

  dimension_group: service_recovery_team {
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.service_recovery_team ;;
  }

  measure: total {
    type: count_distinct
    sql: ${incontact_id} ;;
  }

  measure: agents {
    type: count_distinct
    sql: case when ${is_supervisor} then null else ${incontact_id} end ;;
  }

  measure: supervisors {
    type: count_distinct
    sql: case when ${is_supervisor} then ${incontact_id} end  ;;
  }

}
