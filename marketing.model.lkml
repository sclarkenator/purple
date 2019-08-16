#-------------------------------------------------------------------
# Model Header Information
#-------------------------------------------------------------------
connection: "analytics_warehouse"

include: "*.view.lkml"                       # include all views in this project
#include: "base.model.lkml"
#include: "main.model.lkml"

week_start_day: sunday
