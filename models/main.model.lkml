#-------------------------------------------------------------------
# Model Header Information
#-------------------------------------------------------------------

  connection: "analytics_warehouse"
    include: "/views/**/*.view"
    include: "/dashboards/**/*.dashboard"
    include: "/explores/*.explore"

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

#-------------------------------------------------------------------
#
# Production Explores
#
#-------------------------------------------------------------------

# I moved the Production Explores to Production.lkml -- Blake

#-------------------------------------------------------------------
#
# Accounting Explores
#
#-------------------------------------------------------------------

# I moved the Accounting Explores to Accounting.lkml -- Blake

#-------------------------------------------------------------------
#
# Operations Explores
#
#-------------------------------------------------------------------

# I moved the Operations Explores to Operations.lkml -- Blake

#-------------------------------------------------------------------
#
# Marketing explores
#
#-------------------------------------------------------------------

# I moved the Marketing Explores to Marketing.lkml -- Blake

#-------------------------------------------------------------------
#
# Customer Care Explores
#
#-------------------------------------------------------------------

# I moved the Customer Care Explores to customer_care.lkml -- Blake

#-------------------------------------------------------------------

#-------------------------------------------------------------------
#
# Sales Explores
#
#-------------------------------------------------------------------

# I moved the Sales and Wholesale Explores to Sales.lkml -- Blake

#-------------------------------------------------------------------
#
# Retail Explores
#
#-------------------------------------------------------------------

# I moved the Retail Explores to Retail.lkml -- Blake

#-------------------------------------------------------------------
#
# eCommerce Explore
#
#-------------------------------------------------------------------

# I moved the eCommerce Explore to ecommerce.explore -- Blake

#-------------------------------------------------------------------
#
# Affinity Analysis Block Explore
#
#-------------------------------------------------------------------

  explore: order_purchase_affinity {
    hidden: yes
    group_label: "Marketing"
    label: "🔗 Item Affinity"
    view_label: "Item Affinity"

    always_filter: {
      filters: {
        field: affinity_timeframe
        value: "last 90 days"
      }
      filters: {
        field: order_items_base.product_level
        #### TO DO: Replace with your most used hierarchy level (defined in the affinity_analysis view)
        value: "SKU"
      }
    }

    join: order_items_base {}

    join: total_orders {
      type: cross
      relationship: many_to_one
    }
  }

#-------------------------------------------------------------------
# Old/Bad Explores
#-------------------------------------------------------------------

# I moved the Old/Bad Explores to Old_or_Bad.lkml -- Blake
