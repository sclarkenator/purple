connection: "analytics_warehouse"

include: "*.view"

datagroup: customer_care_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: customer_care_default_datagroup

week_start_day: sunday


explore: customer_satisfaction_survey {group_label: "Customer Care"  label: "CSAT"  description: "Details for Customer Satisfaction Surveys."}

explore: return_form_entry {group_label: "Customer Care"  label: "Return Form Entry"  description: "Compiled result of all online return forms."}
