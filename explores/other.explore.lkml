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

  explore: pii_review {
    group_label: "Legal"
    label: "PII Review"
    description: "This explore is used by Legal for PII.  It is updated every morning."
    hidden: yes
  }
