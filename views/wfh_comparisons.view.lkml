view: wfh_comparisons {
  ## contact center Work From Home performance comparisons
  derived_table: {
    sql:
      select reported
        ,a.agent_id as incontact_id
        ,al.created as agent_created
        ,floor(datediff('day', al.created::date, reported)/7) as agent_tenure
        ,minutes_in_state as acw_duration
        ,concat(reported, agent_id, state) as id

      from customer_care.rpt_agent_state a

        join customer_care.agent_lkp al
        on a.agent_id = al.incontact_id

      where lower(state) = 'wrap up' ;;
    }

  dimension: pk {
    label: "Primary Key"
    type: string
    hidden: yes
    sql: ${TABLE}.id ;;
  }

  dimension: agent_tenure {
    label: "Agent Tenure"
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.agent_tenure ;;
  }

  dimension: incontact_id {
    label: "InContact ID"
    type: number
    value_format_name: id
    sql: ${TABLE}.incontact_id ;;
  }

  dimension: duration {
    label: "ACW Duration"
    description: "ACW duration in minutes."
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.acw_duration/60 ;;
  }

  dimension_group: reported {
    label: "* Reported" ## Date
    type: time
    timeframes: [
      raw,
      date
      # week,
      # month,
      # quarter,
      # year
    ]
    sql: ${TABLE}.reported ;;
  }

  dimension_group: agent_created {
    label: "* Agent Start" ## Date
    type: time
    timeframes: [
      raw,
      date
      # week,
      # month,
      # quarter,
      # year
    ]
    sql: ${TABLE}.agent_created ;;
  }

  measure: avg_acw {
    label: "AVG ACW"
    type: average
    value_format_name: decimal_2
    sql: ${TABLE}.acw_duration/60 ;;
  }

  }
