view: liveperson_conversation_transfer {
  # REFERENCE: https://developers.liveperson.com/messaging-interactions-api-methods-conversations.html#:~:text=string-,Transfer%20info,-NAME
  derived_table: {
    sql:
      select ct.*
        ,s.name as source_skill
        ,t.name as target_skill

      from liveperson.conversation_transfer ct

        join liveperson.skill s
          on ct.source_skill_id = s.skill_id

        join liveperson.skill t
          on ct.source_skill_id = t.skill_id ;;
    }

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: testing_skill_match {
    label: "Testing Skill Matching"
    description: "Testing whether Source and Target skill values typeically match."
    type: yesno
    sql: ${source_skill_id} = ${target_skill_id} ;;
  }

  dimension: reason {
    label: "Reason"
    description: "Reason for transfer (back2Q, Agent, SuggestedAgentTimeout, Skill, TakeOver)"
    type: string
    sql: ${TABLE}."REASON" ;;
    ## NOTE: the reason property gives you insight into why the conversation was transferred:
    ##    * back2Q - the agent transferred the conversation back to the queue.
    ##    * Agent - the conversation was transferred to a specific agent.
    ##    * SuggestedAgentTimeout - the conversation was transferred to a specific agent but they did not accept
    ##        it in time and it was transferred back to the queue.
    ##    * Skill - the conversation was transferred to a skill.
    ##    * TakeOver - a manager has taken over the conversation.
  }

  dimension: source_skill {
    label: "Source Skill"
    type: string
    sql: ${TABLE}.source_skill ;;
  }

  dimension: target_skill {
    label: "Target Skill"
    type: string
    sql: ${TABLE}.target_skill ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## DATE DIMENSIONS

  dimension_group: transfer {
    label: "- Transfer"
    description: "TS when transfer was logged."
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
    # hidden: yes
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: insert_ts {
    label: "- Inserted"
    description: "TS when transfer record was updated in database."
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

  ##########################################################################################
  ##########################################################################################
  ## IDs

  dimension: assigned_agent_id {
    label: "Assigned Agent ID"
    group_label: "* IDs"
    type: number
    # hidden: yes
    sql: ${TABLE}."ASSIGNED_AGENT_ID" ;;
  }

  dimension: conversation_id {
    label: "Conversation IDs"
    group_label: "* IDs"
    type: string
    # hidden: yes
    sql: ${TABLE}."CONVERSATION_ID" ;;
  }

  dimension: pk {
    label: "Primary Key"
    group_label: "* IDs"
    type: string
    primary_key: yes
    # hidden: yes
    sql: concat(${conversation_id}, ${transfer_time}) ;;
  }

  dimension: source_agent_id {
    label: "Source Agent ID"
    group_label: "* IDs"
    type: number
    # hidden: yes
    sql: ${TABLE}."SOURCE_AGENT_ID" ;;
  }

  dimension: source_skill_id {
    label: "Source Skill ID"
    group_label: "* IDs"
    type: number
    # hidden: yes
    sql: ${TABLE}."SOURCE_SKILL_ID" ;;
  }

  dimension: target_skill_id {
    label: "Target Skill ID"
    group_label: "* IDs"
    type: number
    # hidden: yes
    sql: ${TABLE}."TARGET_SKILL_ID" ;;
  }

  dimension: transfered_by_id {
    label: "Transfered By ID"
    group_label: "* IDs"
    type: number
    # hidden: yes
    sql: ${TABLE}."TRANSFERED_BY_ID" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## MEASURES

  measure: transfer_count {
    label: "Transfer Count"
    type: count_distinct
    sql: ${pk} ;;
  }

  measure: transfer_percent {
    label: "Transfer Percent"
    type: percent_of_total
    sql: count(distinct ${pk}) ;;
  }
}
