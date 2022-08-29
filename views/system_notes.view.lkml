view: system_notes {
  derived_table: {
    sql:    WITH checks as (
       select transaction_id, CUSTOM_FIELD, date_created
   from analytics_stage.ns.system_notes_custom
   where custom_field in ('CUSTBODY_SHIPPING_ADDRESS_VALIDATED', 'CUSTBODY_KOUNT_STATUS')
   and value_new in ('Yes', 'Approved')
   )

      select *
      from checks
      pivot(max(date_created) for custom_field in ('CUSTBODY_SHIPPING_ADDRESS_VALIDATED', 'CUSTBODY_KOUNT_STATUS')) as s
      (transaction_id, ship_address_validated, kount_status_approved)
      ;;
  }

  # Define your dimensions and measures here, like this:
  dimension: transaction_id {
    primary_key: yes
    description: "Unique ID for each transaction"
    type: number
    sql: ${TABLE}.transaction_id ;;
  }

  dimension: ship_address_validated {
    description: "Date the shipping address was validated"
    type: date_time
    sql: ${TABLE}.ship_address_validated ;;
  }

  dimension: kount_status_approved {
    description: "Date the fraud check was approved"
    type: date_time
    sql: ${TABLE}.kount_status_approved ;;

  }
}
