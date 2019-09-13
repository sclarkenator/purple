#-------------------------------------------------------------------
# Model Header Information
#-------------------------------------------------------------------

connection: "analytics_warehouse"

include: "*.view.lkml"                       # include all views in this project
#include: "customer_care.model.lkml"
#include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

week_start_day: sunday



#-------------------------------------------------------------------
# Customer Care [CC] explores
#-------------------------------------------------------------------
