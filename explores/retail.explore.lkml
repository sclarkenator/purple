#-------------------------------------------------------------------
#
# Retail Care Explores
#
#-------------------------------------------------------------------
include: "/views/**/*.view"
include: "/dashboards/**/*.dashboard"

  explore: procom_security_daily_customer {
    label: "Procom Customers"
    group_label: "Retail"
    hidden:yes
  }

  explore: owned_retail_target_by_location {hidden: yes }
