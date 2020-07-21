#-------------------------------------------------------------------
#
# Other Explores
#
#-------------------------------------------------------------------
include: "/views/**/*.view"
include: "/dashboards/**/*.dashboard"

  explore: russ_order_validation {
    label: "Order Validation"
    description: "Constructed table comparing orders from different sources"
    hidden:yes
  }
