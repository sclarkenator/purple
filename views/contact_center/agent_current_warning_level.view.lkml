view: agent_current_warning_level {
  ## Tracks only the current warning level and attendance points for each agent
  ## No historic data is tracked in this table

  derived_table: {
    sql:
    select distinct a.incontact_id as incontact_id,
        coalesce(sum(c.points), 0) as current_points,
        ltrim(rtrim(w.warning_level)) as warning_level,
        a.insert_ts

    from customer_care.agent_lkp a

        left join customer_care.attendance_changes c
            on a.incontact_id = c.ic_id

        left join customer_care.agent_current_warning_level w
            on a.incontact_id = w.ic_id

    where a.incontact_id > 0

    group by a.incontact_id,
        w.warning_level,
        ltrim(rtrim(w.warning_level)),
        a.insert_ts ;;
  }

  dimension: incontact_id {
    label: "InContact ID"
    primary_key: yes
    type: number
    sql: ${TABLE}.incontact_id ;;
  }

  dimension_group: insert_ts {
    label: "Inserted"
    # hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}.insert_ts AS TIMESTAMP_NTZ) ;;
  }

  dimension: warning_level {
    label: "Warning Level"
    order_by_field: sort_order
    # hidden: yes
    description: "Current attendance warning level"
    type: string
    sql: ${TABLE}.warning_level ;;
    html: <a href="https://purple.looker.com/dashboards-next/4398">{{ value }}</a> ;;
  }

  dimension: current_points {
    label: "Current Points"
    description: "Current accumulated Occurrence Points."
    type: number
    value_format_name: decimal_1
    sql: ${TABLE}.current_points ;;
  }

  dimension: sort_order{
    hidden: yes
    type: string
    sql: case when ${warning_level} like 'Final%' then concat('3 ', ltrim(rtrim(${TABLE}."WARNING_LEVEL")))
      when ${warning_level} like 'Written%' then concat('2 ', ltrim(rtrim(${TABLE}."WARNING_LEVEL")))
      when ${warning_level} like 'Verbal%' then concat('1 ', ltrim(rtrim(${TABLE}."WARNING_LEVEL")))
      else '0' end;;
  }
}
