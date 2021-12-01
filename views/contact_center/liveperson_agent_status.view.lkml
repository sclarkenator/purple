## REFERENCE: https://developers.liveperson.com/agent-metrics-api-methods-agent-status.html
view: liveperson_agent_status {
  sql_table_name: liveperson.agent_status ;;
  # derived_table: {
    # sql:
      # select stat.agent_id,
      #     stat.status_change,
      #     stat.sequence_number,
      #     # stat.session_id,
      #     last.name as type,
      #     lass.name as subtype,
      #     stat.duration,
      #     stat.reason

      # from liveperson.agent_status as stat

      #     left join liveperson.agent_status_type as last
      #         on stat.type = last.type_id

      #     left join liveperson.agent_status_subtype as lass
      #         on stat.sub_type = lass.subtype_id
        # ;;
    #   sql:  select stat.agent_id,
    # stat.status_change,
    # sequence_number,
    # last.name as type,
    # lass.name as subtype,
    # stat.duration,
    # stat.reason,
    # stat.agent_id || status_change || sequence_number as pk


# from liveperson.agent_status as stat

#     left join liveperson.agent_status_type as last
#         on stat.type = last.type_id

#     left join liveperson.agent_status_subtype as lass
#         on stat.sub_type = lass.subtype_id

# order by agent_id, status_change, sequence_number
# ;;


  set: default_agent_status {
    fields: [
      reason,
      type,
      subtype,
      duration,
      status_change_date,
      status_change_time,
      status_change_minute,
      status_change_minute15,
      status_change_hour,
      status_change_week,
      status_change_month,
      status_change_year,
      agent_status_count,
      pk
    ]
    }

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: duration {
    label: "Duration"
    description: "Duration in seconds"
    type: number
    sql: ${TABLE}.duration ;;
  }

  dimension: reason {
    label: "Reason"
    description: "Optional custom reason for the status change. Null if no custom reason was provided by the agent."
    type: string
    sql: ${TABLE}."REASON" ;;
  }

  dimension: subtype {
    label: "Subtype"
    description: "Subtype of status change when Type = 'Status Changed'."
    type: string
    # hidden: yes
    sql: ${TABLE}.sub_type ;;
  }

  dimension: type{
    label: "Type"
    description: "Type of status change."
    type: string
    # hidden: yes
    sql: ${TABLE}.type ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## DATE DIMENSIONS

  dimension_group: insert_ts {
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
    hidden: yes
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: previous_status_change {
    label: "- Previous Status Change"
    type: time
    timeframes: [
      raw,
      time,
      minute,
      minute15,
      hour,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."PREVIOUS_STATUS_CHANGE" AS TIMESTAMP_NTZ) ;;
  }

dimension_group: status_change {
  label: "- Status Change"
  type: time
  timeframes: [
      raw,
      time,
      minute,
      minute15,
      hour,
      date,
      week,
      month,
      quarter,
      year
  ]
  sql: CAST(${TABLE}."STATUS_CHANGE" AS TIMESTAMP_NTZ) ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## IDs

  dimension: pk {
    label: "Primary Key"
    description: "[Agent ID] - [Status Change Time] - [Sequence Number]"
    type: string
    # hidden: yes
    primary_key: yes
    sql: concat(${agent_id}, '-', ${status_change_time}, right(concat('00', ${sequence_number}), 2)) ;;
  }

  dimension: agent_id {
    description: "Agent's LivePerson ID"
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}."AGENT_ID" ;;
  }

  dimension: sequence_number {
    label: "Sequence Number"
    description: "Sequential number of this status change within the session."
    type: number
    value_format_name: id
    sql: ${TABLE}."SEQUENCE_NUMBER" ;;
  }

  # dimension: session_id {
  #   description: "Identifier of the session during which this status change took place."
  #   type: number
  #   value_format_name: id
  #   # hidden: yes
  #   sql: ${TABLE}."SESSION_ID" ;;
  # }

  dimension: status_reason_id {
    description: "Identifier of optional custom reason for the status change."
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}."STATUS_REASON_ID" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## COUNT MEASURES

  measure: agent_count {
    label: "Agent Count"
    type: count_distinct
    hidden: yes
    sql: agent_id ;;
    drill_fields: [pk]
  }

  measure: agent_status_count {
    label: "Agent Status Count"
    description: "Count of all status changes.  Includes 'Login' and 'Logout'."
    type: count
    # hidden: yes
    drill_fields: [pk]
  }

  measure: count_away {
    label: "Count Away"
    description: "Count of status changes to 'Away' status."
    type: count_distinct
    sql: case when ${subtype} = 'Away' then ${pk} end ;;
  }

  measure: count_occupied {
    label: "Count Occupied"
    description: "Count of status changes to 'Occupied' status."
    type: count_distinct
    sql: case when ${subtype} = 'Occupied' then ${pk} end ;;
  }

  measure: count_offline {
    label: "Count Offline"
    description: "Count of status changes to 'Offline' status."
    type: count_distinct
    sql: case when ${subtype} = 'Offline' then ${pk} end ;;
  }

  measure: online_count {
    label: "Count Online"
    description: "Count of status changes to 'Online' status."
    type: count_distinct
    sql: case when ${subtype} = 'Online' then ${pk} end ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## DURATION MEASURES

  measure: duration_away {
    label: "Duration Away"
    description: "Duration in away status in minutes."
    type: number
    sql: sum(case when ${subtype} = 'Away' then ${duration} end) / 60 ;;
  }

  measure: duration_occupied {
    label: "Duration Occupied"
    type: number
    sql: sum(case when ${subtype} = 'Occupied' then ${duration} end) / 60 end ;;
  }

  measure: duration_offline {
    label: "Duration Offline"
    type: number
    sql: sum(case when ${subtype} = 'Offline' then ${duration} end) / 60 ;;
  }

  measure: duration_online {
    label: "Duration Online"
    type: number
    sql: sum(case when ${subtype} = 'Online' then ${duration} end) / 60 ;;
  }

}
