connection: "tealium_redshift"

  include: "/views/tealium/*.view"
  include: "/explores/tealium.explore"

  week_start_day: monday

  datagroup: gross_to_net_sales_default_datagroup {
    # sql_trigger: SELECT MAX(id) FROM etl_log;;
    max_cache_age: "1 hour"}

  persist_with: gross_to_net_sales_default_datagroup

  datagroup: temp_ipad_database_default_datagroup {
    max_cache_age: "1 hour"}

  persist_with: temp_ipad_database_default_datagroup

  # Rebuilds at 6:00am MDT / 13:00 UTC
  datagroup: pdt_refresh_6am {
    sql_trigger: SELECT FLOOR((DATE_PART('EPOCH_SECOND', CURRENT_TIMESTAMP) - 60*60*13)/(60*60*24)) ;;
    max_cache_age: "24 hours"
  }

  named_value_format: curr {
    value_format: "#,##0.00 \" USD\""
  }
  named_value_format: curr_0 {
    value_format: "#,##0 \" USD\""
  }

#-------------------------------------------------------------------
#
# Access Grants
#
#-------------------------------------------------------------------

  access_grant: can_view_pii {
    user_attribute: can_view_pii
    allowed_values: ["yes"]
  }

  access_grant: is_customer_care_manager{
    user_attribute: is_customer_care_manager
    allowed_values: [ "yes" ]
  }
