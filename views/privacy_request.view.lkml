view: privacy_request {
  sql_table_name: ANALYTICS.LEGAL.PRIVACY_REQUEST
    ;;

  dimension: privacy_request_flg {
    hidden: yes
    group_label: "  Customer details"
    label: "  * Is Privacy Request"
    description: "Yes if this customer has requested their data be deleted through CCPA. Source:analytics.privacy_request"
    type: yesno
    sql: ${TABLE}.email_join is not null ;;
  }

  dimension: delete_in_progress {
    hidden: yes
    type: yesno
    sql: ${TABLE}."DELETE_IN_PROGRESS" ;;
  }

  dimension_group: deleted {
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
    sql: CAST(${TABLE}."DELETED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: email_join {
    hidden: yes
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: email {
    group_label: "  Customer details"
    hidden:  yes
    label: "Customer Email"
    description: "Customer Email Address on the Netsuite customer record. Source:netsuite.privacy_request"
    type: string
    sql: CASE WHEN '{{ _user_attributes['can_view_pii'] }}' = 'yes'
              THEN ${TABLE}.email
              ELSE '**********' || '@' || SPLIT_PART(${TABLE}.email, '@', 2)
            END ;;
  }

  dimension: request_type {
    hidden: yes
    type: string
    sql: ${TABLE}."REQUEST_TYPE" ;;
  }

}
