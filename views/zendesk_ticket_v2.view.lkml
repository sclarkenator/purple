view: zendesk_ticket_v2 {
   sql_table_name: "CUSTOMER_CARE"."V_ZENDESK_TICKET" ;;

  dimension: ticket_id {
    primary_key: yes
    group_label: "Ticket Attributes"
    description: "Numeric ID for the ticket"
    type: number
    sql:  ${TABLE}."TICKET_ID" ;;
  }

  dimension: status {
    group_label: "Ticket Attributes"
    description: "Status of the ticket"
    type: string
    sql: ${TABLE}."TICKET_STATUS" ;;
  }

  dimension: group_id {
    group_label: "Ticket Attributes"
    type: number
    hidden: yes
    sql: ${TABLE}."TICKET_GROUP_ID";;
  }

  dimension: group {
    group_label: "Ticket Attributes"
    description: "Name of the group where the ticket is assigned"
    type: string
    sql:  ${TABLE}."TICKET_GROUP" ;;
  }

  dimension: channel {
    group_label: "Ticket Attributes"
    description: "Channel that the ticket was created from. chat=chat, api=phone, email, web and facebook = email"
    type: string
    sql: ${TABLE}."TICKET_CHANNEL" ;;
  }

  dimension: form_id {
    group_label: "Ticket Attributes"
    type: number
    hidden: yes
    sql: ${TABLE}."TICKET_FORM_ID";;
  }

  dimension: form_name {
    group_label: "Ticket Attributes"
    description: "Ticket form used when creating the ticket"
    type: string
    sql: ${TABLE}."FORM_NAME" ;;
  }

  dimension: priority {
    group_label: "Ticket Attributes"
    description: "The priority of a ticket: Low, Normal, High, or Urgent"
    type: string
    sql:  ${TABLE}."PRIORITY" ;;
  }

  dimension: subject {
    group_label: "Ticket Attributes"
    description: "Subject line in the ticket"
    type: string
    sql: ${TABLE}."SUBJECT" ;;
  }

  dimension: type {
    group_label: "Ticket Attributes"
    description: "The ticket type: Question, Incident, Problem, or Task."
    type: string
    sql: ${TABLE}."TYPE" ;;
  }

  dimension: assignee_id {
    group_label: "Assignee"
    description: "The ticket's assignee ID (Zendesk ID)"
    type: number
    sql: ${TABLE}."ASSIGNEE_ID" ;;
  }

  dimension: assignee_name {
    group_label: "Assignee"
    description: "The name of the person who the ticket was assigned to.  Assignees are usually internal employees/agents."
    type: string
    sql: ${TABLE}."ASIGNEE_NAME" ;;
  }

  dimension: assignee_role {
    group_label: "Assignee"
    description: "The role of an assignee, either admin, agent, or end-user.  End-user is generally used to denote an inactive agent or account."
    type: string
    sql: ${TABLE}."ASIGNEE_ROLE" ;;
  }

  dimension: assignee_email {
    group_label: "Assignee"
    description: "Email address for the assignee"
    type: string
    sql:  ${TABLE}."ASIGNEE_EMAIL" ;;
  }

  dimension: assignee_status {
    group_label: "Assignee"
    description: "The current status of the ticket assignee (active, deleted, or suspended)"
    type: string
    sql: ${TABLE}."ASIGNEE_STATUS" ;;
  }

  dimension_group: assignee_last_signed_in {
    label: "Assignee Last Signed In"
    type: time
    timeframes: [
      raw,
      time,
      hour,
      hour_of_day,
      minute30,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."ASIGNEE_LAST_SIGNED_IN" AS TIMESTAMP_NTZ) ;;
  }

  dimension: requester_id {
    group_label: "Requester"
    description: "The ID for the requester of the ticket. (Zendesk ID)"
    type: number
    sql: ${TABLE}."REQUESTER_ID" ;;
  }

  dimension: requester_name {
    group_label: "Requester"
    description: "The name of the ticket requester"
    type: string
    sql: ${TABLE}."REQUESTER_NAME" ;;
  }

  dimension: requester_role {
    group_label: "Requester"
    description: "The role of the requester, either admin, agent, or end-user.  Admin/Agent are internal users. End-user is a customer."
    type: string
    sql: ${TABLE}."REQUESTER_ROLE" ;;
  }

  dimension: requester_email {
    group_label: "Requester"
    description: "Email address for the requester"
    type: string
    sql:  ${TABLE}."REQUESTER_EMAIL" ;;
  }

  dimension_group: requester_created {
    description: "Date the Requester's profile was created"
    type: time
    timeframes: [
      raw,
      time,
      hour,
      hour_of_day,
      minute30,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."REQUESTER_CREATED" AS TIMESTAMP_NTZ) ;;
    }

    dimension_group: requester_updated {
      description: "Date the Requester's profile was last updated"
      type: time
      timeframes: [
        raw,
        time,
        hour,
        hour_of_day,
        minute30,
        date,
        week,
        month,
        quarter,
        year
      ]
      sql: CAST(${TABLE}."REQUESTER_UPDATED" AS TIMESTAMP_NTZ) ;;
    }

    dimension: submitter_id {
      group_label: "Submitter"
      description: "The ID for the submitter of the ticket. (Zendesk ID)"
      type: number
      sql: ${TABLE}."SUBMITTER_ID" ;;
    }

  dimension: submitter_name {
    group_label: "Submitter"
    description: "The name of the submitter.  This is the person who intitiated the ticket."
    type: string
    sql: ${TABLE}."SUBMITTER_NAME" ;;
  }

  dimension: submitter_role {
    group_label: "Submitter"
    description: "The role of the submitter, either admin, agent, or end user. Admin/Agent are internal users. End-User is a customer."
    type: string
    sql: ${TABLE}."SUBMITTER_ROLE" ;;
  }

  dimension: submitter_email {
    group_label: "Submitter"
    description: "Email address for the submitter"
    type: string
    sql:  ${TABLE}."SUBMITTER_EMAIL" ;;
  }

  dimension: organization_id {
    group_label: "Ticket Attributes"
    description: "The ID of the organization associated with the ticket"
    type: number
    hidden: yes
    sql: ${TABLE}."ORGANIZATION_ID" ;;
  }

  dimension: organization_name {
    group_label: "Ticket Attributes"
    description: "The name of the organization associated with the ticket"
    type: string
    sql: ${TABLE}."NAME";;
  }

  dimension: requester_organization_id {
    group_label: "Requester"
    description: "The organization ID of the ticket requester"
    type: number
    hidden: yes
    sql: ${TABLE}."REQUESTER_ORGANIZATION_ID" ;;
  }

  dimension: requester_organization {
    group_label: "Requester"
    description: "The organization name of the ticket requester."
    type: string
    sql: ${TABLE}."REQUESTER_ORGANIZATION";;
  }

  dimension_group: tkt_created {
    description: "The time and date when the ticket was created."
    type: time
    timeframes: [
      raw,
      time,
      hour,
      hour_of_day,
      minute30,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week
    ]
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: tkt_first_agent_response {
    description: "The time and date of the first response by an agent"
    type: time
    timeframes: [
      raw,
      time,
      hour,
      hour_of_day,
      minute30,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."FIRST_AGENT_RESPONSE" AS TIMESTAMP_NTZ) ;;
    }

  dimension_group: tkt_first_resolution {
    description: "The time and date that the ticket was first marked as solved"
    type: time
    timeframes: [
      raw,
      time,
      hour,
      hour_of_day,
      minute30,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."FIRST_RESOLVED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: tkt_last_resolution {
    description: "The time and date that the ticket was last marked as solved"
    type: time
    timeframes: [
      raw,
      time,
      hour,
      hour_of_day,
      minute30,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."LAST_RESOLVED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: tkt_last_updated {
    description: "The time and date that the ticket was last updated"
    type: time
    timeframes: [
      raw,
      time,
      hour,
      hour_of_day,
      minute30,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."TICKET_LAST_UPDATED" AS TIMESTAMP_NTZ) ;;
  }

    dimension_group: tkt_last_updated_by_requester{
      description: "The time and date that the ticket was last updated by the requester"
      type: time
      timeframes: [
        raw,
        time,
        hour,
        hour_of_day,
        minute30,
        date,
        week,
        month,
        quarter,
        year
      ]
      sql: CAST(${TABLE}."LAST_UPDATE_BY_REQUESTER" AS TIMESTAMP_NTZ) ;;
    }

  dimension_group: tkt_first_assigned{
    description: "The time and date that the ticket was first assigned to an agent"
    type: time
    timeframes: [
      raw,
      time,
      hour,
      hour_of_day,
      minute30,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."FIRST_ASSIGNED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: tkt_last_assigned{
    description: "The time and date that the ticket was last assigned to an agent"
    type: time
    timeframes: [
      raw,
      time,
      hour,
      hour_of_day,
      minute30,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."LAST_ASSIGNED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: tkt_survey_received{
    description: "Date/time that Stella Connect survey response was recieved for the associated ticket "
    type: time
    timeframes: [
      raw,
      time,
      hour,
      hour_of_day,
      minute30,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."CUSTOM_STELLA_CONNECT_RESPONSE_RECEIVED_AT" AS TIMESTAMP_NTZ) ;;
  }

  dimension: number_of_opens {
    group_label: "Ticket Attributes"
    description: "Number of times a ticket has been in open status"
    type: number
    sql: ${TABLE}."NUM_OPENS" ;;
  }

  dimension: first_response_hours {
    group_label: "Ticket Attributes"
    description: "Number of hours to the first response"
    type: number
    sql: ${TABLE}."HOURS_TO_FIRST_RESPONSE" ;;
  }

  dimension: first_resolved_hours {
    group_label: "Ticket Attributes"
    description: "Number of hours from ticket creation to first resolution time"
    type: number
    sql: ${TABLE}."HOURS_TO_FIRST_RESOLVED" ;;
  }

  dimension: last_resolved_hours {
    group_label: "Ticket Attributes"
    description: "Number of hours from ticket creation to last resolution time"
    type: number
    sql: ${TABLE}."HOURS_TO_LAST_RESOLVED" ;;
  }

  dimension: ticket_age {
    group_label: "Ticket Attributes"
    description: "Age of ticket in days, measured from the creation date"
    type: number
    sql: ${TABLE}."TICKET_AGE" ;;
  }

  dimension: ns_request_type {
    group_label: "Ticket Custom Fields"
    description: "Custom field used to categorize certain requests (usually internal ticket requests dealing with NetSuite)"
    type: string
    sql: ${TABLE}."CUSTOM_REQUEST_TYPE" ;;
  }

  dimension: fulfillment_issue_type {
    group_label: "Ticket Custom Fields"
    description: "Custom field used to categorize fulfillment issues. Most commonly used on White Glove and Warranty/Shipping tickets."
    type: string
    sql: ${TABLE}."CUSTOM_FULFILLMENT_ISSUE_TYPE" ;;
  }

  dimension: cx_task_type {
    group_label: "Ticket Custom Fields"
    label: "CX Task Type"
    description: "Ticket category for the Customer Experience Team"
    type: string
    sql: ${TABLE}."CUSTOM_CX_TASK_TYPE" ;;
  }

  dimension: fulfillment_requested {
    group_label: "Ticket Custom Fields"
    description: "T/F indicator whether fulfillment was requested on the ticket.  Most commonly used by Fulfillment, White Glove, and Warranty/Shipping"
    type: yesno
    sql: ${TABLE}."CUSTOM_FULFILLMENT_REQUESTED" ;;
  }

  dimension: rma_number {
    group_label: "Ticket Custom Fields"
    label: "RMA Number"
    description: "RMA number associated with the ticket"
    type: string
    sql: ${TABLE}."CUSTOM_RMA_" ;;
  }

  dimension: contact_id_all {
    group_label: "Ticket Custom Fields"
    description: "All inContact Contact ID's associated with a phone ticket"
    type: string
    sql: ${TABLE}."CUSTOM_CONTACT_ID" ;;
  }

  dimension: contact_id_first{
    group_label: "Ticket Custom Fields"
    description: "First inContact Contact ID's associated with a phone ticket"
    type: string
    sql: ${TABLE}."CONTACT_ID" ;;
  }

  dimension: return_form_submitted{
    group_label: "Ticket Custom Fields"
    description: "Checkbox indicating that the customer completed the return form."
    type: yesno
    sql: ${TABLE}."CUSTOM_FORM_SUBMITTED" ;;
  }

  dimension: call_length_all {
    group_label: "Ticket Custom Fields"
    description: "Length of each call associated with the phone ticket. "
    type: string
    sql: ${TABLE}."CUSTOM_LENGTH_OF_CALL" ;;
  }

  dimension: call_length_first {
    group_label: "Ticket Custom Fields"
    description: "Length of the first call associated with the phone ticket. "
    type: string
    sql: substring(${TABLE}."CUSTOM_LENGTH_OF_CALL",1,5);;
  }

  dimension: phone_ticket {
    group_label: "Ticket Custom Fields"
    description: "Indicates that the ticket was a designated phone ticket"
    type: yesno
    sql: ${TABLE}."CUSTOM_DESIGNATED_PHONE_TICKET" ;;
  }

  dimension: purple_charity {
    group_label: "Ticket Custom Fields"
    description: "Indicates that contact requested charitable donation information"
    type: yesno
    sql: ${TABLE}."CUSTOM_PURPLE_CHARITY" ;;
  }

  dimension: stamped_io_review {
    group_label: "Ticket Custom Fields"
    description: "Indicates that ticket was generated due to a Stamped.io review"
    type: yesno
    sql: ${TABLE}."CUSTOM_STAMPED_IO_REVIEW" ;;
  }

  dimension: warranty_type {
    group_label: "Ticket Custom Fields"
    description: "Custom field categorizing warranty request type"
    type: string
    sql: ${TABLE}."CUSTOM_WARRANTY_TYPE" ;;
  }

  dimension: verification_type {
    group_label: "Ticket Custom Fields"
    description: "Custom field indicating how the potential fraud was reported"
    type: string
    sql: ${TABLE}."CUSTOM_FRAUD_TYPE" ;;
  }

  dimension: skill_name {
    group_label: "Ticket Custom Fields"
    description: "inContact phone skill that is associated with the call segment on the ticket. Only applicable to phone tickets."
    type: string
    sql: ${TABLE}."CUSTOM_SKILL_NAME" ;;
  }

  dimension: freeform_ticket {
    group_label: "Ticket Custom Fields"
    description: "Custom field allowing an agent to indicate when they use freeform text in their response rather than a macro."
    type: yesno
    sql: ${TABLE}."CUSTOM_FREEFORM_TICKET" ;;
  }

  dimension: receipt_request_sent {
    group_label: "Ticket Custom Fields"
    description: "Indicates that the receipt request was sent. Most commonly used by the Returns team."
    type: yesno
    sql: ${TABLE}."CUSTOM_RECIEPT_REQUEST_SENT" ;;
  }

  dimension: item_title {
    group_label: "Ticket Custom Fields"
    description: "Title of the product associated with the eBay Item ID or Amazon Item ID."
    type: string
    sql: ${TABLE}."CUSTOM_ITEM_TITLE" ;;
  }

  dimension: purchased_from {
    group_label: "Ticket Custom Fields"
    description: "Indicates which retail partner the customer purchased from, including a catergory for Purple (DTC)"
    type: string
    sql: ${TABLE}."CUSTOM_RETAIL_PARTNER_PURCHASE" ;;
  }

  dimension: amazon_item_id {
    group_label: "Ticket Custom Fields"
    description: "Amazon item number for the product associated with the ticket. (Amazon Standard Identification Number). "
    type: string
    sql: ${TABLE}."CUSTOM_ASIN" ;;
  }

  dimension: verification_outcome {
    group_label: "Ticket Custom Fields"
    description: "Used for Fraud tickets to categorize the result of the interaction"
    type: string
    sql: ${TABLE}."CUSTOM_OUTCOME" ;;
  }

  dimension: question_type {
    group_label: "Ticket Custom Fields"
    description: "Field used to categorize the type of customer request. Most often associated with Chat Tickets."
    type: string
    sql: ${TABLE}."CUSTOM_QUESTION_TYPE" ;;
  }

  dimension: amazon_order_status{
    group_label: "Ticket Custom Fields"
    description: "Status of the Amazon order associated with the ticket"
    type: string
    sql: ${TABLE}."CUSTOM_ORDER_STATUS" ;;
  }

  dimension: no_survey{
    group_label: "Ticket Custom Fields"
    description: "Indicates that the agent marked No Survey resulting in no survey being sent to the customer. "
    type: yesno
    sql: ${TABLE}."CUSTOM_NO_SURVEY" ;;
  }

  dimension: tl_assigned{
    group_label: "Ticket Custom Fields"
    description: "Indicates tickets where an agent escalated to a Team Lead"
    type: yesno
    sql: ${TABLE}."CUSTOM_TEAM_LEAD_ASSIGNED" ;;
  }

  dimension: tl_approved{
    group_label: "Ticket Custom Fields"
    description: "Indicates agent received Team Lead Approval for something on the ticket. "
    type: yesno
    sql: ${TABLE}."CUSTOM_TEAM_LEAD_APPROVED_" ;;
  }

  dimension: delivery_partner{
    group_label: "Ticket Custom Fields"
    description: "Delivery partner assoiated with the ticket"
    type: string
    sql: ${TABLE}."CUSTOM_DELIVERY_PARTNER_ORGANIZATION" ;;
  }

  dimension: shipping_carrier{
    group_label: "Ticket Custom Fields"
    description: "Shipping carrier assoiated with the ticket"
    type: string
    sql: ${TABLE}."CUSTOM_SHIPPING_CARRIER" ;;
  }

  dimension: tracking_id {
    group_label: "Ticket Custom Fields"
    description: "Tracking number associated with the ticket"
    type: string
    sql: ${TABLE}."CUSTOM_TRACKING_ID" ;;
  }

  dimension: follow_up_tkt {
    group_label: "Ticket Custom Fields"
    description: "Indicates that the ticket was created as a follow up from a closed ticket"
    type: yesno
    sql: ${TABLE}."CUSTOM_FOLLOW_UP_TICKET_" ;;
  }

  dimension: survey_id {
    group_label: "Ticket Custom Fields"
    description: "Survey ID from Stella Connect"
    type: string
    sql: ${TABLE}."CUSTOM_STELLA_CONNECT_REQUEST_ID" ;;
  }

  dimension: transfer {
    group_label: "Ticket Custom Fields"
    description: "Indicates whether the ticket was marked as a transfer to another agent or team."
    type: yesno
    sql: ${TABLE}."CUSTOM_TRANSFER_" ;;
  }

  dimension: white_glove_bol {
    group_label: "Ticket Custom Fields"
    label: "White Glove BOL#"
    description: ""
    type: string
    sql: ${TABLE}."CUSTOM_WHITE_GLOVE_BOL_" ;;
  }

  dimension: return_type {
    group_label: "Ticket Custom Fields"
    description: "Categoy of the return"
    type: string
    sql: ${TABLE}."CUSTOM_RETURN_TYPE_" ;;
  }

  dimension: wholesale_issue_type {
    group_label: "Ticket Custom Fields"
    description: "Categoy of the wholesale issue"
    type: string
    sql: ${TABLE}."CUSTOM_WHOLESALE_ISSUE_TYPE" ;;
  }

  dimension: order_id {
    group_label: "Ticket Custom Fields"
    description: "Order number associated with the ticket"
    type: string
    sql: ${TABLE}."CUSTOM_ORDER_" ;;
  }

  dimension: pick_up_method {
    group_label: "Ticket Custom Fields"
    description: "Company contracted to pick up the return or warranty mattress."
    type: string
    sql: ${TABLE}."CUSTOM_PICK_UP_METHOD" ;;
  }

  dimension: system_request_type {
    group_label: "Ticket Custom Fields"
    description: "Category of internal request"
    type: string
    sql: ${TABLE}."CUSTOM_SYSTEM_REQUEST_TYPE" ;;
  }

  dimension: survey_sent {
    group_label: "Ticket Custom Fields"
    description: "Indicates that a Stella Connect survey was sent for the ticket."
    type: yesno
    sql: ${TABLE}."CUSTOM_SURVEY_SENT" ;;
  }

  dimension: point_of_purchase {
    group_label: "Ticket Custom Fields"
    description: "Point of purchase for the order associated with the ticket"
    type: string
    sql: ${TABLE}."CUSTOM_POINT_OF_PURCHASE" ;;
  }

  dimension: order_date {
    group_label: "Ticket Custom Fields"
    description: "The date the order associated with the ticket was placed.  Required field for the Wholesale Ticket Form"
    type: string
    sql: ${TABLE}."CUSTOM_ORDER_DATE" ;;
  }

  dimension: primary_disposition{
    group_label: "Ticket Disposition"
    description: "Primary disposition of the contact or ticket"
    type: string
    sql: ${TABLE}."PRIMARY_DISPOSITION";;
  }

  dimension: secondary_disposition{
    group_label: "Ticket Disposition"
    description: "The secondary disposition or reason for the contact. A ticket may have multiple secondary dispositions and this is ONLY the FIRST one listed"
    type: string
    sql: replace(${TABLE}."CUSTOM_SECONDARY_DISPOSITION", '_', ' ');;
  }

  dimension: secondary_disposition_call {
    group_label: "Ticket Disposition"
    description: "Secondary disposition of the call segment, as captured in FAC.  A ticket may have multiple secondary call dispositions due to multiple call segments being associated with a ticket. "
    type: string
    sql: replace(${TABLE}."CUSTOM_SECONDARY_DISPOSITION_CALL", '_', ' ');;
  }

  dimension: disposition_comments{
    group_label: "Ticket Disposition"
    description: "Agent comments entered in to the FAC.  If no comments are entered the result will be undefined or NULL if not a phone ticket"
    type: string
    sql: ${TABLE}."CUSTOM_DISPOSITION_COMMENTS";;
  }

  dimension: product{
    group_label: "Ticket Disposition"
    description: "Product(s) discussed during the interaction with the customer. A ticket may have multiple products discussed."
    type: string
    sql: ${TABLE}."PRODUCT";;
  }

  dimension: agent_replies_brackets {
    group_label: "Ticket Brackets"
    description: "The number of agent replies left on the ticket. Values are returned as 0, 1, 2, 3-5 or >5."
    type: string
    sql: ${TABLE}."AGENT_REPLIES_BRACKETS" ;;
  }

  dimension: reopens_brackets {
    group_label: "Ticket Brackets"
    description: "The number of times the ticket was reopened. Values are returned as 0, 1, >1."
    type: string
    sql: ${TABLE}."REOPENS_BRACKETS" ;;
  }

  dimension: first_reply_time_brackets {
    group_label: "Ticket Brackets"
    description: "The time between when the ticket was first opened, and when an agent first replied. Values are returned as: No Replies, 0-1 hrs, 1-8 hrs, 8-24 hrs, >24 hrs."
    type: string
    sql: ${TABLE}."FIRST_REPLY_TIME_BRACKETS" ;;
  }

  dimension: first_resolution_time_brackets {
    group_label: "Ticket Brackets"
    description: "The time between when the ticket was first opened, and the FIRST time it was set to solved. Values are returned as:  Unsolved, 0-5 hrs, 1-7 days, 5-24 hrs, 7-30 days, >30 days."
    type: string
    sql: ${TABLE}."FIRST_RESOLUTION_TIME_BRACKETS" ;;
  }

  dimension: full_resolution_time_brackets {
    group_label: "Ticket Brackets"
    description: "The time between when the ticket was first opened, and the LAST time it was set to solved. Values are returned as:  Unsolved, 0-5 hrs, 1-7 days, 5-24 hrs, 7-30 days, >30 days."
    type: string
    sql: ${TABLE}."FULL_RESOLUTION_TIME_BRACKETS" ;;
  }

  dimension: requester_wait_time_brackets {
    group_label: "Ticket Brackets"
    description: "The time a requester was waiting for agent replies. The values are returned as 0-1 hrs, 1-24 hrs, 1-3 days, 3-7 days, >7 days or No wait."
    type: string
    sql: ${TABLE}."REQUESTER_WAIT_TIME_BRACKETS" ;;
  }

  dimension: unsolved_ticket_age_brackets {
    group_label: "Ticket Brackets"
    description: "The duration in days between when an unsolved ticket was created and now. The values are returned as 1 day, 1-7 days, 7-30 days, >30 days, Solved."
    type: string
    sql: ${TABLE}."UNSOLVED_TICKET_AGE_BRACKETS" ;;
  }



  ## REQUESTER_WAIT_TIME in Snowflake is rounded to the minute on every ticket making the aggregation inaccurate.
  ## Created more accurate calculated wait times below. - Angie McDonald
  measure: wait_time_sum {
    description: "Total minutes the requester waited for a response. Wait time is rounded to the minute on each ticket"
    type: sum
    value_format_name: decimal_0
    hidden: yes
    sql: ${TABLE}."REQUESTER_WAIT_TIME" ;;
  }

  measure: wait_time_total {
    description: "Total minutes the requester waited for a response."
    type: sum
    value_format_name: decimal_2
    sql: DATEDIFF(second,${tkt_created_raw},${tkt_first_agent_response_raw})/60;;
  }


  ## REQUESTER_WAIT_TIME in Snowflake is rounded to the minute on every ticket making the aggregation inaccurate.
  ## Created more accurate calculated wait times below. - Angie McDonald
  measure: wait_time_avg {
    description: "Average minutes the requester waited for a response. Wait time is rounded to the minute on each ticket"
    type: average
    value_format_name: decimal_2
    hidden: yes
    sql:  ${TABLE}."REQUESTER_WAIT_TIME"  ;;
  }


  measure: wait_time_average {
    description: "Total minutes the requester waited for a response."
    type: average
    value_format_name: decimal_2
    sql: DATEDIFF(second,${tkt_created_raw},${tkt_first_agent_response_raw})/60;;
  }


  measure: ticket_count {
    description: "Count of tickets"
    type: count
    value_format_name: decimal_0
  }


  measure: agent_replies_total {
    description: "Number of agent responses on the ticket"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}."AGENT_REPLIES" ;;
  }

  measure: agent_replies_average {
    description: "Average number of agent responses on the tickets"
    type: average
    value_format_name: decimal_2
    sql: ${TABLE}."AGENT_REPLIES" ;;
  }

  measure: open_average {
      description: "Average number of times the ticket has been in Open status."
      type: average
      value_format_name: decimal_2
      sql: ${TABLE}."NUM_OPENS" ;;
  }











  }
