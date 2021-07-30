view: agent_current_warning_level {
  sql_table_name: "CUSTOMER_CARE"."AGENT_CURRENT_WARNING_LEVEL"
    ;;

  dimension: ic_id {
    label: "InContact ID"
    primary_key: yes
    type: number
    sql: ${TABLE}."IC_ID" ;;
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
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension: warning_level {
    label: "Warning Level"
    order_by_field: sort_order
    # hidden: yes
    description: "Current attendance warning level"
    type: string
    sql: ltrim(rtrim(${TABLE}."WARNING_LEVEL")) ;;
    html: <a href="https://purple.looker.com/dashboards-next/4398">{{ value }}</a> ;;
  }

  dimension: sort_order{
    hidden: yes
    type: string
    sql: case when ${warning_level} like 'Final%' then concat('3 ', ltrim(rtrim(${TABLE}."WARNING_LEVEL")))
      when ${warning_level} like 'Written%' then concat('2 ', ltrim(rtrim(${TABLE}."WARNING_LEVEL")))
      when ${warning_level} like 'Verbal%' then concat('1 ', ltrim(rtrim(${TABLE}."WARNING_LEVEL")))
      else '0' end;;
  }

  # dimension: current_warning_level {
  #   label: "Warning Level"
  #   description: "Current ranked attendance warning level"
  #   sql: ${warning_level} ;;
  #   html:
  #     <p>strpos(value, "Final")</p> ;;
  #     # {% if strpos(value, "Final") !== false %}
  #     #   <p style="background-color: lightgreen">{{rendered_value}}<p>
  #     # {% endif %} ;;

  #   }
}
