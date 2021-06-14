view: incontact_phone {


  # Add Refusals to count, avg and pct measures
  # Add % inbound and % outbound measures

  sql_table_name: ANALYTICS.CUSTOMER_CARE.CONTACT ;;

  drill_fields: [master_contact_id, contact_id]

  dimension: primary_key {
    label: "PK"
    group_label: "* IDs"
    description: "Primary key field.  [master_contact_id] & [contact_id]"
    primary_key: yes
    hidden:  yes
    type: string
    sql: ${master_contact_id} || ${contact_id} ;;
    }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      master_contact_id,
      start_ts_mst_time,
      campaign_name,
      skill_name,
      team_name,
      poc_name,
      from_ani
      ]
    }

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: campaign_name {
    label: "Campaign Name"
    description: "Name of the Campaign as specified in NICE inContact."
    type: string
    sql: ${TABLE}."CAMPAIGN_NAME" ;;
     }

  dimension: conferences {
    label: "Conferences"
    description: "Number of times a contact was placed in Conference."
    hidden: yes
    type: number
    sql: ${TABLE}."CONFERENCES" ;;
    }

  dimension: contact_type {
    label: "Contact Type"
    description: "Displays the description for a contact."
    type: string
    sql: ${TABLE}."CONTACT_TYPE" ;;
    }

  # dimension: contacts { Delete if no issues caused by removal
  #   label: "Contacts"
  #   type: number
  #   value_format_name: decimal_0
  #   sql: 1 ;;
  #   }

  dimension: direction {
    label: "Direction"
    description: "Direction of the contact (Inbound or Outbound)."
    type: string
    sql: ${TABLE}."DIRECTION" ;;
    }

  dimension: disposition_notes {
    label: "Disposition Notes"
    type: string
    sql: ${TABLE}."DISPOSITION_NOTES" ;;
    }

  dimension: from_ani {
    label: "From_ANI"
    description: "Phone number that the call originates from."
    type: string
    sql: ${TABLE}."FROM_ANI" ;;
    }

  dimension: holds {
    label: "Holds"
    description: "Number of times a contact was placed on hold during a conversation."
    type: number
    sql: ${TABLE}."HOLDS" ;;
    }

  dimension: media_type {
    label: "Media Type"
    description: "Displays the media type/channel of a contact."
    type: string
    sql: ${TABLE}."MEDIA_TYPE" ;;
    }

  dimension: poc_name {
    label: "POC Name"
    description: "Displays the name of the Point of Contact.  Similar to a VDN, the POCs feed into defined Skills."
    type: string
    sql: ${TABLE}."POC_NAME" ;;
    }

  dimension: refusals {
    label: "Refusals"
    description: "Number of times the same contact was refused."
    type: number
    hidden: yes
    sql: ${TABLE}."REFUSALS" ;;
    }

  dimension: refused_reason {
    label: "Refused Reason"
    type: string
    sql: ${TABLE}."REFUSED_REASON" ;;
    }

  dimension: routed {
    label: "Routed"
    description: "Number of times a contact was routed to an agent.  Normally relates to Refusals."
    type: number
    # hidden: yes
    sql: ${TABLE}."ROUTED" ;;
    }

  dimension: skill_name {
    label: "Skill Name"
    description: "Skill Associated with the Contact / Name of the Skill as specified in NICE inContact."
    type: string
    sql: ${TABLE}."SKILL_NAME" ;;
    }

  dimension: team_name {
    label: "Team Name"
    description: "Team Name in inContact."
    type: string
    sql: ${TABLE}."TEAM_NAME" ;;
    }

  dimension: to_dnis {
    label: "To DNIS"
    description: "Phone number that the call is coming in to."
    type: string
    sql: ${TABLE}."TO_DNIS" ;;
    }

  ##########################################################################################
  ##########################################################################################
  ## RAW TIME DIMENSIONS

  dimension: abandon_time {
    label: "Abandon Time"
    group_label: "* Time Dimensions"
    description: "Length of time the contact spent in the queue prior to abandoning "
    type: number
    sql: ${TABLE}."ABANDON_TIME" ;;
    }

  dimension: acd_time {
    label: "ACD Time"
    group_label: "* Time Dimensions"
    description: "Total length of time the contact spend in the Automatic Call Distributor (ACD)."
    type: number
    sql: ${TABLE}."ACD_TIME" ;;
    }

  dimension: active_talk_time {
    label: "Active Talk Time"
    group_label: "* Time Dimensions"
    description: "Length of time the contact spend in active conversation with the primary agent. Note: Does not include Hold Time or Conference Time."
    type: number
    sql: ${TABLE}."ACTIVE_TALK_TIME" ;;
    }

  dimension: acw_time {
    label: "ACW Time"
    group_label: "* Time Dimensions"
    description: "The length of time the agent spent on work that is necessitated by and immediately follows a call/contact."
    type: number
    sql: ${TABLE}."ACW_TIME" ;;
    }

  dimension: callback_time {
    label: "Callback Time"
    group_label: "* Time Dimensions"
    description: "Length of time contact spent waiting for the NICE inContact system to call back after the caller requested a callback."
    type: number
    sql: ${TABLE}."CALLBACK_TIME" ;;
    }

  dimension: conference_time {
    label: "Conference Time"
    group_label: "* Time Dimensions"
    description: "Length of time agent spent in conference with another agent and the caller."
    type: number
    sql: ${TABLE}."CONFERENCE_TIME" ;;
    }

  dimension: handle_time {
    label: "Handle Time"
    group_label: "* Time Dimensions"
    description: "Length of time contact was actively handled by an agent. (ATT+ACW+Conf+Hold)."
    type: number
    sql: ${active_talk_time} + ${acw_time} + ${conference_time} + ${hold_time} ;;
    }

  dimension: hold_time {
    label: "Hold Time"
    group_label: "* Time Dimensions"
    description: "Length of time contact spent on hold with an agent."
    type: number
    sql: ${TABLE}."HOLD_TIME" ;;
    }

  dimension: inqueue_time {
    label: "In Queue Time"
    group_label: "* Time Dimensions"
    description: "Length of time contact spent in the queue waiting for an agetn starting when the contact entered the queue until the contact was answered by the agent."
    type: number
    sql: ${TABLE}."INQUEUE_TIME" ;;
    }

  dimension: long_abandon_time {
    label: "Long Abandon Time"
    group_label: "* Time Dimensions"
    description: "Length of time the contact spent waiting in the queue prior to the long abandon. This length of time determines if the contact is a long abandon based on the short abandon threshold configured on the skill."
    type: number
    sql: case when ${long_abandon} = true then ${abandon_time} end;;
    }

  dimension: postqueue_time {
    label: "Post Queue Time"
    group_label: "* Time Dimensions"
    description: "Time after an agent has left a call but before the caller hangs up.  This time is accrued only if the script performs an UNLINK.  This disassociates the agent from the call and lets the call return to an IVR state. It is possible to do another ReqAgent and talk to a second agent, or be transferred to an outside number among other things. This can be used to offer callers a post call survey."
    type: number
    sql: ${TABLE}."POSTQUEUE_TIME" ;;
    }

  dimension: release_time {
    label: "Release Time"
    group_label: "* Time Dimensions"
    description: "Length of time a script spends executing in an On Release event.  At this point the Contact and the Agent have disconnected but the script that is processing that contact continues to run due to subsequent script actions."
    type: number
    sql: ${TABLE}."RELEASE_TIME" ;;
    }

  dimension: routing_time {
    label: "Routing Time"
    group_label: "* Time Dimensions"
    description: "Length of time contact spent being routed to an agent after entering the queue."
    type: number
    sql: ${TABLE}."ROUTING_TIME" ;;
    }

  dimension: short_abandon_time {
    label: "Short Abandon Time"
    group_label: "* Time Dimensions"
    description: "Length of time the contact spent waiting in the queue prior to the short abandon. This length of time determines whether the contact qualifies as a short abandon or note."
    type: number
    sql: case when ${short_abandon} = true then ${abandon_time} end;;
    }

  dimension: talk_time {
    label: "Talk Time"
    group_label: "* Time Dimensions"
    description: "Length of time the contact spent connected with an agent from 'hello' to 'goodbye'. Includes anything that may happen during a conversation, including placeing customers on hold to confer with supervisors or other.  May include both inbound time and outbound time depending on report filters.  [Active Talk Time] + [Hold Time] + [Conference Time]"
    type: number
    sql: ${active_talk_time} + ${hold_time} + ${conference_time};;
    }

  dimension: total_contact_time {
    label: "Total Contact Time"
    group_label: "* Time Dimensions"
    description: "CONFIRM WHICH FIELD THIS MATCHES"
    type: number
    sql: ${TABLE}."TOTAL_CONTACT_DURATION" ;;
    }

  ##########################################################################################
  ##########################################################################################
  ## NON-KEY ID DIMENSIONS

  dimension: agent_id {
    label: "Agent ID"
    group_label: "* IDs"
    description: "Unique ID given to the Agent.  Matches agent's InContact ID."
    hidden: yes
    type: string
    sql: ${TABLE}."AGENT_ID" ;;
    }

  dimension: campaign_id {
    label: "Campaign ID"
    group_label: "* IDs"
    description: "Unique ID given to a Campaign."
    hidden: yes
    type: string
    sql: ${TABLE}."CAMPAIGN_ID" ;;
    }

  dimension: contact_id {
    label: "Contact ID"
    group_label: "* IDs"
    description: "Unique ID of a Contact (call)."
    type: string
    # hidden: yes
    sql: ${TABLE}."CONTACT_ID" ;;
    }

  dimension: master_contact_id {
    label: "Master Contact ID"
    group_label: "* IDs"
    description: "Master/Parent ID of one or more Contacts."
    # hidden: yes
    type: string
    sql: ${TABLE}."MASTER_CONTACT_ID" ;;
    }

  dimension: primary_disposition_id {
    label: "Primary Disposition ID"
    group_label: "* IDs"
    description: "ID of primary disposition."
    # hidden: yes
    type: number
    sql: ${TABLE}."PRIMARY_DISPOSITION_ID" ;;
    }

  dimension: secondary_disposition_id {
    label: "Secondary Disposition ID"
    group_label: "* IDs"
    description: "ID of secondary disposition."
    # hidden: yes
    type: number
    sql: ${TABLE}."SECONDARY_DISPOSITION_ID" ;;
    }

  dimension: skill_id {
    label: "Skill ID"
    group_label: "* IDs"
    description: "Uniique ID given to a Skill."
    hidden: yes
    type: string
    sql: ${TABLE}."SKILL_ID" ;;
    }

  dimension: team_id {
    label: "Team ID"
    group_label: "* IDs"
    description: "Unique ID given to the Team."
    hidden: yes
    type: string
    sql: ${TABLE}."TEAM_ID" ;;
    }

  ##########################################################################################
  ##########################################################################################
  ## YesNo Flag Dimensions

  dimension: abandoned {
    label: "Abandoned"
    group_label: "* Flags"
    description: "Flags contacts that were not resolved by IVR and hung up or exited the system before being offered to an agent."
    type: yesno
    sql: ${TABLE}."ABANDONED" ;;
  }

  dimension: agent_offered {
    label: "Agent Offered"
    group_label: "* Flags"
    description: "Flags contacts that were routed to an agent."
    type: yesno
    sql: ${TABLE}."AGENT_OFFERED" ;;
  }

  dimension: busy {
    label: "Busy"
    group_label: "* Flags"
    description: "Flags contacts that resulted in a busy classification."
    type: yesno
    sql: ${TABLE}."BUSY" ;;
  }

  dimension: callback_requested {
    label: "Callback Request"
    group_label: "* Flags"
    description: "Flags contacts that entered the queue and then requested a callback instead of waiting for an agent to become available."
    type: yesno
    sql: ${TABLE}."CALLBACK_REQUESTED" ;;
  }

  dimension: conferenced {
    label: "Conferenced"
    group_label: "* Flags"
    description: "Flags contacts that were placed in Conference at least once."
    type: yesno
    sql: ${TABLE}."CONFERENCED" ;;
  }

  dimension: handled {
    label: "Handled"
    group_label: "* Flags"
    description: "Flags whether the Inbound or Outbound contact was handled by an agent at some point."
    type: yesno
    sql: ${TABLE}."HANDLED" ;;
  }

  dimension: held {
    label: "Held"
    group_label: "* Flags"
    description: "Flags contacts that were placed on Hold at least once."
    type: yesno
    sql: ${TABLE}."HELD" ;;
  }

  dimension: in_sla {
    label: "In SLA"
    group_label: "* Flags"
    description: "Flags contacts that were handled within the defined Service Level Objective."
    type: yesno
    sql: ${TABLE}."IN_SLA" ;;
  }

  dimension: long_abandon {
    label: "Long Abandon"
    group_label: "* Flags"
    description: "Flags contacts that abandoned call after the designated short abandon time."
    type: yesno
    sql: ${TABLE}."IS_LONG_ABANDON" ;;
  }

  dimension: out_sla {
    label: "Out SLA"
    group_label: "* Flags"
    description: "Flags whether the contact was NOT handled within the defined Service Level Objective (Abandons being taken into account is conditional on Skill Configuration)."
    type: yesno
    sql: case when ${service_level_flag} = 1 then true
      else false end;;
  }

  dimension: prequeue_abandon {
    label: "Prequeue Abandon"
    group_label: "* Flags"
    description: "Flags a contact that exited the system while in the IVR or Prequeue state. Contacts must spend at least 2 seconds within NICE inContact to be counted."
    type: yesno
    sql: ${TABLE}."PREQUEUE_ABANDON" ;;
  }

  dimension: prequeued {
    label: "Prequeued"
    group_label: "* Flags"
    description: "Flags a contact that entered the system through the IVR Prequeue state."
    type: yesno
    sql: ${TABLE}."PREQUEUED" ;;
  }

  dimension: queue_offered {
    label: "Queue Offered"
    group_label: "* Flags"
    description: "Flags contacts that enter the skill queue contact_state = Inqueue or Callback."
    type: yesno
    sql: ${TABLE}."QUEUE_OFFERED" ;;
  }

  dimension: queued {
    label: "Queued"
    group_label: "* Flags"
    description: "Flags inbound contacts placed in a queue regaredless of the time spend in the agent queue.  This includes those contacts that spent time in the queue and those immediately rounted to an available agent.  This includes contacts transferred to a skill and agent as distinct contacts (transfers followed by consult are not counted)."
    type: yesno
    sql: ${TABLE}."QUEUED" ;;
  }

  dimension: refused {
    label: "Refused"
    group_label: "* Flags"
    description: "Flags contacts offered to the agent but the agent never answered or otherwise responded.  If this contact is routed a 2nd time to the same agent after it was originally refused then it will count as both a refused call and a handled call. For this reason, Refused + Handled may not add up to Offered."
    type: yesno
    sql: ${TABLE}."REFUSED" ;;
  }

  dimension: service_level_flag {
    label: "Service Level"
    group_label: "* Flags"
    description: "Indicates whether the contact was handled within the skill defined Service Level (0), handled outside of the skill defined Service Level (1), or whether the contact never entered the queue (-1)."
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.service_level_flag ;;
  }

  dimension: short_abandon {
    label: "Short Abandon"
    group_label: "* Flags"
    description: "Flags contacts that abandoned call prior to the designated short abandon time."
    # hidden: yes
    type: yesno
    sql: ${TABLE}."IS_SHORT_ABANDON" ;;
  }

  dimension: spawned {
    label: "Spawned"
    group_label: "* Flags"
    description: "Flags contacts that were spawned within a NICE inContact script."
    hidden: yes
    type: yesno
    sql: ${TABLE}."SPAWNED" ;;
  }

  dimension: transferred {
    label: "Transferred"
    group_label: "* Flags"
    description: "Flags contacts that were transferred to another queue or agent at least once."
    type: yesno
    sql: ${TABLE}.transferred  ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## DATE DIMENSION GROUPS

  dimension_group: insert_ts {
    label: "Insert TS UDP"
    hidden: yes
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

  dimension_group: last_updated_ts {
    label: "Updated TS UDP"
    hidden: yes
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
    sql: CAST(${TABLE}."LAST_UPDATED_TS" AS TIMESTAMP_NTZ) ;;
    }

  dimension_group: last_updated_ts_mst {
    label: "Updated TS MST"
    hidden: yes
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
    sql: CAST(${TABLE}."LAST_UPDATED_TS_MST" AS TIMESTAMP_NTZ) ;;
    }

  dimension_group: refuse_ts {
    label: "Contact Refusal TS UDP"
    hidden: yes
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
    sql: CAST(${TABLE}."REFUSE_TS" AS TIMESTAMP_NTZ) ;;
    }

  dimension_group: refuse_ts_mst {
    label: "Contact Refusal"
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
    sql: CAST(${TABLE}."REFUSE_TS_MST" AS TIMESTAMP_NTZ) ;;
    }

  dimension_group: start_ts_mst {
    label: "Contact START"
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
    sql: CAST(${TABLE}."START_TS_MST" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: start_ts {
    label: "Contact Start TS UDP"
    hidden: yes
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
    sql: CAST(${TABLE}."START_TS" AS TIMESTAMP_NTZ) ;;
    }

  ##########################################################################################
  ##########################################################################################
  ## COUNT MEASURES

  measure: abandon_count {
    label: "Abandon Count"
    group_label: "Count Measures"
    description: "Counts abandoned contacts that were not resolved by IVR and hung up or exited the system before being offered to an agent."
    type: sum
    sql: case when ${abandoned} = true then 1 end ;;
    drill_fields: [detail*]
    }

  measure: agent_offered_count {
    label: "Agent Offered Count"
    group_label: "Count Measures"
    description: "Counts contacts that were routed to an agent."
    type: sum
    sql: case when ${agent_offered} = true then 1 end ;;
    drill_fields: [detail*]
    }

  measure: callback_request_count {
    label: "Callback Request Count"
    group_label: "Count Measures"
    description: "Counts contacts that entered the queue and then requested a callback instead of waiting for an agent to become available."
    type: sum
    sql: case when ${callback_requested} = true then 1 end ;;
    drill_fields: [detail*]
    }

  measure: contact_count {
    label: "Contact Count"
    group_label: "Count Measures"
    description: "Counts all calls."
    # hidden: yes
    type: number
    sql: count(*) ;;
    drill_fields: [detail*]
    }

  measure: conferences_count {
    label: "Conferences Count"
    group_label: "Count Measures"
    description: "Count of conferences."
    type: sum
    value_format: "###0"
    sql: case when ${conferences} > 0 then ${conferences} end ;;
    drill_fields: [detail*]
    }

  measure: handled_count {
    label: "Handled Count"
    group_label: "Count Measures"
    description: "Counts Inbound or Outbound contact that were handled by an agent at some point."
    type: sum
    sql: case when ${handled} = true then 1 else 0 end ;;
    drill_fields: [detail*]
    }

  measure: hold_count {
    label: "Hold Count"
    group_label: "Count Measures"
    description: "Count of holds."
    type: sum
    sql: case
      when ${holds} > 0 then ${holds}
      when ${held} = true then 1
      else 0 end ;;
    drill_fields: [detail*]
    }

  measure: in_sla_count {
    label: "In SLA Count"
    group_label: "Count Measures"
    description: "Counts contacts that were handled within the defined Service Level Objective."
    type: sum
    sql: cast(${in_sla} as integer) ;;
    drill_fields: [detail*]
    }

  measure: inbound_count {
    label: "Inbound Count"
    group_label: "Count Measures"
    description: "Count of Inbound calls"
    type: sum
    sql: case when ${direction} = 'Inbound' then 1 else 0 end ;;
    drill_fields: [detail*]
    }

  measure: long_abandon_count {
    label: "Long Abandon Count"
    group_label: "Count Measures"
    description: "Counts contacts that abandoned call after the designated short abandon time."
    type: sum
    sql: case when ${long_abandon} = true then 1 else 0 end ;;
    drill_fields: [detail*]
    }

  measure: out_sla_count {
    label: "Out SLA Count"
    group_label: "Count Measures"
    description: "Counts contacts that were handled outside the defined Service Level Objective."
    type: sum
    sql: case when ${service_level_flag} = 1 then 1 else 0 end ;;
    drill_fields: [detail*]
    }

  measure: outbound_count {
    label: "Outbound Count"
    group_label: "Count Measures"
    description: "Count of outbound calls"
    type: sum
    sql: case when ${direction} = 'Outbound' then 1 else 0 end ;;
    drill_fields: [detail*]
    }

  measure: prequeue_abandon_count {
    label: "Prequeue Abandon Count"
    group_label: "Count Measures"
    description: "Count of prequeue abandon calls"
    type: sum
    sql: case when ${prequeue_abandon} = true then 1 else 0 end ;;
    drill_fields: [detail*]
  }

  measure: queue_offered_count {
    label: "Queue Offered Count"
    group_label: "Count Measures"
    description: "Counts contacts that enter the skill queue contact_state = Inqueue or Callback for the first time during an interval or time period."
    type: sum
    sql: case when ${queue_offered} = true then 1 else 0 end ;;
    drill_fields: [detail*]
    }

  measure: queued_count {
    label: "Queued Count"
    group_label: "Count Measures"
    description: "Counts contacts that entered the system through the IVR Prequeue state."
    type: sum
    sql: case when ${queued} = true then 1 else 0 end ;;
    drill_fields: [detail*]
    }

  measure: refusal_count {
    label: "Refusal Count"
    group_label: "Count Measures"
    description: "Number of times the same contact was refused."
    type: sum
    sql: case when ${refused} = true then 1 else 0 end ;;
    drill_fields: [detail*]
    }

  measure: routed_count {
    label: "Routed Count"
    group_label: "Count Measures"
    description: "Number of times a contact was routed to an agent.  Normally relates to Refusals."
    type: sum
    sql: ${routed} ;;
    drill_fields: [detail*]
    }

  measure: short_abandon_count {
    label: "Short Abandon Count"
    group_label: "Count Measures"
    description: "Counts contacts in the queue that abandoned call prior to the designated short abandon time."
    type: sum
    sql: case when ${short_abandon} = true then 1 else 0 end ;;
    drill_fields: [detail*]
    }

  measure: transfer_count {
    label: "Transfer Count"
    group_label: "Count Measures"
    description: "Counts contacts transferred from original queued agent."
    type: sum
    sql: cast(${transferred} as integer) ;;
    drill_fields: [detail*]
    }

  ##########################################################################################
  ##########################################################################################
  ## AVERAGE MEASURES

  measure: abn_time_average {
    label: "AVG Abandon Time"
    group_label: "Average Measures"
    description: "Average time caller spent in queue before abandoning.  Includes long and short abandons."
    type: average
    value_format: "###0.00"
    sql: case when ${abandon_time} > 0 then ${abandon_time} end / 60 ;;
    drill_fields: [detail*]
  }

  measure: acd_time_average {
    label: "AVG ACD Time"
    group_label: "Average Measures"
    description: "Average time caller spent in ACD."
    type: average
    value_format: "###0.00"
    sql: case when ${acd_time} > 0 then ${acd_time} end / 60 ;;
    drill_fields: [detail*]
  }

  measure: acw_time_average {
    label: "AVG ACW Time"
    group_label: "Average Measures"
    description: "Average time agent spent in ACW."
    type: average
    value_format: "###0.00"
    sql: case when ${acw_time} > 0 then ${acw_time} end / 60 ;;
    drill_fields: [detail*]
  }

  measure: active_talk_time_average {
    label: "AVG Active Talk Time"
    group_label: "Average Measures"
    description: "Average time agent spent actively engaged with caller."
    type: average
    value_format: "###0.00"
    sql: case when ${active_talk_time} > 0 then ${active_talk_time} end / 60 ;;
    drill_fields: [detail*]
  }

  measure: holds_per_call_average {
    label: "AVG Holds"
    group_label: "Average Measures"
    description: "Average number of holds per call."
    type: average
    value_format_name: decimal_2
    hidden: yes
    sql:${holds}  ;;
    drill_fields: [detail*]
  }

  measure: conference_time_average {
    label: "AVG Conference Time"
    group_label: "Average Measures"
    description: "Average time agent spent in Conference with another agent and the caller."
    type: average
    value_format: "###0.00"
    sql: case when ${conference_time} > 0 then ${conference_time} end / 60 ;;
    drill_fields: [detail*]
  }

  measure: handle_time_average {
    label: "AVG Handle Time"
    group_label: "Average Measures"
    description: "Average handle time. (ATT+ACW+Conf+Hold)"
    type: average
    value_format: "###0.00"
    hidden: yes
    sql: case when ${handle_time} > 0 then ${handle_time} end / 60 ;;
    drill_fields: [detail*]
  }

  measure: in_queue_time_average {
    label: "AVG In Queue Time"
    group_label: "Average Measures"
    description: "Average time caller spent in queue."
    type: average
    value_format: "###0.00"
    sql: case when ${inqueue_time} > 0 then ${inqueue_time} end / 60 ;;
    drill_fields: [detail*]
  }

  measure: long_abn_time_average {
    label: "AVG Long ABN Time"
    group_label: "Average Measures"
    description: "Average time caller spent in queue before abandoning.  Only counts abandons taking place AFTER designated short abandon time."
    type: average
    value_format: "###0.00"
    sql: case when ${long_abandon_time} > 0 then ${long_abandon_time} end / 60 ;;
    drill_fields: [detail*]
  }

  measure: short_abn_time_average {
    label: "AVG Short ABN Time"
    group_label: "Average Measures"
    description: "Average time caller spent in queue before abandoning.  Only counts abandons taking place BEFORE designated short abandon time."
    type: average
    value_format: "###0.00"
    sql: case when ${short_abandon_time} > 0 then ${short_abandon_time} end / 60 ;;
    drill_fields: [detail*]
  }

  measure: talk_time_average {
    label: "AVG Talk Time"
    group_label: "Average Measures"
    description: "Average time caller spent connected with an agent from 'Hello' to 'Goodbye'."
    type: average
    value_format: "###0.00"
    sql: case when ${talk_time} > 0 then ${talk_time} end / 60 ;;
    drill_fields: [detail*]
  }

  measure: total_contact_time_average {
    label: "AVG Total Contact Time"
    group_label: "Average Measures"
    description: "Average total time caller spent on contact. (Prequeue + Inqueue + Active Talk + Hold + Conference + Consult + Postqueue)"
    type: average
    value_format: "###0.00"
    sql: case when ${total_contact_time} > 0 then ${total_contact_time} end / 60 ;;
    drill_fields: [detail*]
  }

  ##########################################################################################
  ##########################################################################################
  ## SUM MEASURES

  measure: abn_time_sum {
    label: "Sum Abandon Time"
    group_label: "Sum Measures"
    description: "Total time caller(s) spent in queue before abandoning.  Includes long and short abandons."
    type: number
    value_format: "###0.00"
    sql: sum(${abandon_time}) / 60 ;;
    drill_fields: [detail*]
  }

  measure: acd_time_sum {
    label: "Sum ACD Time"
    group_label: "Sum Measures"
    description: "Total time caller(s) spent in ACD."
    type: number
    value_format: "###0.00"
    sql: sum(${acd_time}) / 60 ;;
    drill_fields: [detail*]
  }

  measure: acw_time_sum {
    label: "Sum ACW Time"
    group_label: "Sum Measures"
    description: "Total time agent spent in ACW."
    type: number
    value_format: "###0.00"
    sql: sum(${acw_time}) / 60 ;;
    drill_fields: [detail*]
  }

  measure: active_talk_time_sum {
    label: "Sum Active Talk Time"
    group_label: "Sum Measures"
    description: "Total time agent spent actively engaged with caller."
    type: number
    value_format: "###0.00"
    sql: sum(${active_talk_time}) / 60 ;;
    drill_fields: [detail*]
  }

  measure: holds_per_call_sum {
    label: "Sum Holds"
    group_label: "Sum Measures"
    description: "Total number of holds per call."
    type: number
    value_format: "###0.00"
    sql: sum(${holds}) ;;
    drill_fields: [detail*]
  }

  measure: conference_time_sum {
    label: "Sum Conference Time"
    group_label: "Sum Measures"
    description: "Total time agent spent in Conference with another agent and the caller."
    type: number
    value_format: "###0.00"
    sql: sum(${conference_time}) / 60 ;;
    drill_fields: [detail*]
  }

  measure: handle_time_sum {
    label: "Sum Handle Time"
    group_label: "Sum Measures"
    description: "Total handle time. (ATT+ACW+Conf+Hold)"
    type: number
    value_format: "###0.00"
    sql: sum(${handle_time}) / 60 ;;
    drill_fields: [detail*]
  }

  measure: in_queue_time_sum {
    label: "Sum In Queue Time"
    group_label: "Sum Measures"
    description: "Total time caller spent in queue."
    type: number
    value_format: "###0.00"
    sql: sum(${inqueue_time}) / 60 ;;
    drill_fields: [detail*]
  }

  measure: long_abn_time_sum {
    label: "Sum Long ABN Time"
    group_label: "Sum Measures"
    description: "Total time caller spent in queue before abandoning.  Only counts abandons taking place AFTER designated short abandon time."
    type: number
    value_format: "###0.00"
    sql: sum(${long_abandon_time}) / 60 ;;
    drill_fields: [detail*]
  }

  measure: short_abn_time_sum {
    label: "Sum Short ABN Time"
    group_label: "Sum Measures"
    description: "Total time caller spent in queue before abandoning.  Only counts abandons taking place BEFORE designated short abandon time."
    type: number
    value_format: "###0.00"
    sql: sum(${short_abandon_time}}) / 60 ;;
    drill_fields: [detail*]
  }

  measure: talk_time_sum {
    label: "Sum Talk Time"
    group_label: "Sum Measures"
    description: "Total time caller spent connected with an agent from 'Hello' to 'Goodbye'."
    type: number
    value_format: "###0.00"
    sql: sum(${talk_time}) / 60 ;;
    drill_fields: [detail*]
  }

  measure: total_contact_time_sum {
    label: "Sum Total Contact Time"
    group_label: "Sum Measures"
    description: "Total time caller spent on contact. (Prequeue + Inqueue + Active Talk + Hold + Conference + Consult + Postqueue)"
    type: number
    value_format: "###0.00"
    sql: sum(${total_contact_time}) / 60 ;;
    drill_fields: [detail*]
  }

  ##########################################################################################
  ##########################################################################################
  ## PERCENTAGE MEASURES

  measure: inbound_pct {
    label:  "Inbound Pct"
    group_label: "Percentage Measures"
    description: "Percent of calls that were inbound."
    type: number
    value_format_name: percent_1
    sql: sum(case when ${direction} = 'Inbound' then 1 end) / nullifzero(count(*)) ;;
    drill_fields: [detail*]
    }

  measure: in_sla_pct {
    label:  "In SLA Pct"
    group_label: "Percentage Measures"
    description: "Percent of queued calls that were handled within the defined Service Level Agreement objective."
    type: number
    value_format_name: percent_1
    sql: sum(case when ${in_sla} = true then 1 else 0 end) /
      nullifzero(sum(case when ${service_level_flag} between 0 and 1 then 1 else 0 end)) ;;
    drill_fields: [detail*, in_sla]
    }

  measure: long_abandon_pct {
    label: "Long Abandon Pct"
    group_label: "Percentage Measures"
    description: "Percent of agent offered calls that were abandoned after short abandon threshhold."
    type: number
    value_format_name: percent_1
    sql: sum(case when ${long_abandon} = true then 1 else 0 end) /
      nullifzero(sum(case when ${agent_offered} = true then 1 else 0 end)) ;;
    drill_fields: [detail*, long_abandon, agent_offered]
    }

  measure: out_sla_pct {
    label:  "Out SLA Pct"
    group_label: "Percentage Measures"
    description: "Percent of queued calls that were NOT handled within the defined Service Level Agreement objective."
    type: number
    value_format_name: percent_1
    sql: sum(case when ${service_level_flag} = 1 then 1 else 0 end) /
      nullifzero(sum(case when ${service_level_flag} between 0 and 1 then 1 else 0 end)) ;;
    drill_fields: [detail*, in_sla]
    }

  measure: Outbound_pct {
    label:  "Outbound Pct"
    group_label: "Percentage Measures"
    description: "Percent of calls that were outbound."
    type: number
    value_format_name: percent_1
    sql: sum(case when ${direction} = 'Outbound' then 1 end) /
      nullifzero(count(*)) ;;
    drill_fields: [detail*]
    }
}
