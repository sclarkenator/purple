include: "/views/_period_comparison.view.lkml"
view: zendesk_ticket {
  extends: [_period_comparison]
  sql_table_name: "CUSTOMER_CARE"."ZENDESK_TICKET"
    ;;

  #### Used with period comparison view
  dimension_group: event {
    hidden: yes
    type: time
    timeframes: [ raw,time,time_of_day,date,day_of_week,day_of_week_index,day_of_month,day_of_year,
      week,month,month_num,quarter,quarter_of_year,year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.created;;
  }

  dimension: allow_channelback {
    type: yesno
    sql: ${TABLE}."ALLOW_CHANNELBACK" ;;
  }

  dimension: assignee_id {
    type: number
    sql: ${TABLE}."ASSIGNEE_ID" ;;
  }

  # Mason Fuller on 1/14/2021 - Adding month_name
  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      week_of_year,
      month,
      month_name,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: primary_disposition {
    type: string
    sql: ${TABLE}."PRIMARY_DISPOSITION" ;;
  }

  dimension: secondary_disposition {
    type: string
    sql: ${TABLE}."SECONDARY_DISPOSITION" ;;
  }

  dimension: disposition_call {
    type: string
    sql: ${TABLE}."DISPOSITION_CALL" ;;
  }

  dimension: disposition_comments {
    type: string
    sql: ${TABLE}."DISPOSITION_COMMENTS" ;;
  }

  dimension: requester_role {
    type: string
    sql: ${TABLE}."REQUESTER_ROLE" ;;
  }

  dimension: submitter_role {
    type: string
    sql: ${TABLE}."SUBMITTER_ROLE" ;;
  }

  dimension: product {
    type: string
    sql: ${TABLE}."PRODUCT" ;;
  }

  # Added by Mason Fuller on 1/14/2021 to clean the product field. The product field is a listagg.
  dimension: product_clean {
    type: string
    sql: case
      when ${TABLE}."PRODUCT" like '%blanket%' then 'blanket'
      when ${TABLE}."PRODUCT" like '%cover%' then 'cover'
      when ${TABLE}."PRODUCT" like '%duvet%' then 'duvet'
      when ${TABLE}."PRODUCT" like '%egift_card%' then 'egift_card'
      when ${TABLE}."PRODUCT" like '%eye_mask%' then 'eye_mask'
      when ${TABLE}."PRODUCT" like '%face_mask%' then 'face_mask'
      when ${TABLE}."PRODUCT" like '%mattress%' then 'mattress'
      when ${TABLE}."PRODUCT" like '%no_product_discussed%' then 'no_product_discussed'
      when ${TABLE}."PRODUCT" like '%pajamas%' then 'pajamas'
      when ${TABLE}."PRODUCT" like '%petbed%' then 'petbed'
      when ${TABLE}."PRODUCT" like '%pillow%' then 'pillow'
      when ${TABLE}."PRODUCT" like '%pillow_case%' then 'pillow_case'
      when ${TABLE}."PRODUCT" like '%platform_bases%' then 'platform_bases'
      when ${TABLE}."PRODUCT" like '%platform_stabilization_kit%' then 'platform_stabilization_kit'
      when ${TABLE}."PRODUCT" like '%powerbase%' then 'powerbase'
      when ${TABLE}."PRODUCT" like '%protector%' then 'protector'
      when ${TABLE}."PRODUCT" like '%seat_cushion%' then 'seat_cushion'
      when ${TABLE}."PRODUCT" like '%sheets%' then 'sheets'
      when ${TABLE}."PRODUCT" like '%squishy%' then 'squishy'
      end ;;
  }

  dimension: first_response_comment_order {
    type: number
    sql: ${TABLE}."FIRST_RESPONSE_COMMENT_ORDER" ;;
  }

  dimension: first_response_minute {
    type: number
    sql: ${TABLE}."FIRST_RESPONSE_MINUTE" ;;
  }

  dimension: first_response_ticket_comment_id {
    type: number
    sql: ${TABLE}."FIRST_RESPONSE_TICKET_COMMENT_ID" ;;
  }

  dimension: group_id {
    type: number
    sql: ${TABLE}."GROUP_ID" ;;
  }

  dimension: has_incidents {
    type: yesno
    sql: ${TABLE}."HAS_INCIDENTS" ;;
  }

  dimension: is_public {
    type: yesno
    sql: ${TABLE}."IS_PUBLIC" ;;
  }

  dimension: length_of_call {
    type: string
    sql: ${TABLE}."LENGTH_OF_CALL" ;;
  }

  dimension: priority {
    type: string
    sql: ${TABLE}."PRIORITY" ;;
  }

  dimension: requester_id {
    type: number
    sql: ${TABLE}."REQUESTER_ID" ;;
  }

  dimension: skill_name {
    type: string
    sql: ${TABLE}."SKILL_NAME" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: subject {
    type: string
    sql: ${TABLE}."SUBJECT" ;;
  }

  dimension: system_location {
    type: string
    sql: ${TABLE}."SYSTEM_LOCATION" ;;
  }

  dimension: ticket_form_id {
    type: number
    sql: ${TABLE}."TICKET_FORM_ID" ;;
  }

  dimension: ticket_id {
    group_label: " Advanced"
    label: "Ticket ID"
    primary_key: yes
    type: number
    link: {
      label: "Zendesk"
      url: "https://purplesupport.zendesk.com/agent/tickets/{{value}}"
      icon_url: "https://zendesk.com/favicon.ico"
    }
    description: "This is Zendesk's internal ID. This will be a hyperlink to the ticket in Zendesk."
    sql: ${TABLE}."TICKET_ID" ;;
  }

  dimension: time_spent_last_update {
    type: number
    sql: ${TABLE}."TIME_SPENT_LAST_UPDATE" ;;
  }

  dimension: total_time_spent {
    type: number
    sql: ${TABLE}."TOTAL_TIME_SPENT" ;;
  }

  dimension: url {
    type: string
    sql: ${TABLE}."URL" ;;
  }

  dimension: via_channel {
    type: string
    sql: ${TABLE}."VIA_CHANNEL" ;;
  }

  measure: count {
    type: count
    drill_fields: [skill_name]
  }
}
