#-------------------------------------------------------------------
#
# Retail Care Explores
#
#-------------------------------------------------------------------
include: "/views/**/*.view"
include: "/dashboards/**/*.dashboard"



  explore: owned_retail_target_by_location {hidden: yes }
  explore: store_four_wall {hidden:yes}
  explore: retail_goal {hidden:yes description:"Owened Retail Sales and Mattress Unit Goals by date and location"}
