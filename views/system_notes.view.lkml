view: system_notes {
  derived_table: {
    sql:    WITH checks as (
    select
        transaction_id,
        CUSTOM_FIELD as field,
        convert_timezone('America/Denver', date_created) as date_created
    from
        analytics_stage.ns.system_notes_custom
    where
        custom_field in (
            'CUSTBODY_SHIPPING_ADDRESS_VALIDATED',
            'CUSTBODY_KOUNT_STATUS'
        )
        and value_new in ('Yes', 'Approved')
    union all
    select
        transaction_id,
        standard_field as field,
        convert_timezone('America/Denver', date_created) as date_created
    from
        analytics_stage.ns.system_notes_custom
    where
        standard_field = 'DOCUMENTSTATUS'
        AND upper(VALUE_NEW) = 'PENDING APPROVAL'
    union all
    select
        transaction_id,
        CUSTOM_FIELD as field,
        convert_timezone('America/Denver', date_created) as date_created
    from
        analytics_stage.ns.system_notes_custom
    where
        custom_field = 'CUSTBODY_A1WMS_BACKORDERS'
        and value_new > 0
    union all
    select
        transaction_id,
        CUSTOM_FIELD as field,
        convert_timezone('America/Denver', date_created) as date_created
    from
        analytics_stage.ns.system_notes_custom
    where
        custom_field = 'CUSTBODY_MINIMUM_SHIP_DATE'
        and value_old is not null
)
select
    *
from
    checks pivot(
        max(date_created) for field in (
            'CUSTBODY_SHIPPING_ADDRESS_VALIDATED',
            'CUSTBODY_KOUNT_STATUS',
            'DOCUMENTSTATUS',
            'CUSTBODY_A1WMS_BACKORDERS',
            'CUSTBODY_MINIMUM_SHIP_DATE'
        )
    ) as s (
        transaction_id,
        ship_address_validated,
        kount_status_approved,
        pending_approval_status,
        backorder,
        shipping_hold)

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

  dimension: pending_approval_status {
    description: "Date the order entered Pending Approval Status, if applicable"
    type: date_time
    sql: ${TABLE}.pending_approval_status ;;
  }
  dimension: backorder {
    description: "Latest date the order recorded a backorder, if applicable"
    type: date_time
    sql: ${TABLE}.backorder ;;
  }
  dimension: shipping_hold {
    description: "Latest date the order was put on hold, if applicable"
    type: date_time
    sql: ${TABLE}.shipping_hold ;;
  }
}
