project_name: "Main_Sales_Model"

# application: executive-dashboards {
#   label: "Executive Dashboards"
#   definition_file: "Main_Sales_Model//application.json"
# }


application: tabbed_dashboards {
  label: "Forecast Dashboards"
  file: "tabbed_dashboards.js"
  # url : "http://localhost:8080/bundle.js"
  entitlements: {
    local_storage: yes
    navigation: yes
    new_window: yes
    use_embeds: yes
    use_form_submit: yes
    core_api_methods: ["dashboard", "dashboard_dashboard_filters", "all_connections","search_folders", "run_inline_query", "me", "all_roles"]
  }
}

# application: tabbed_dashboard_2 {
#   label: "Test Tabbed Dashboards"
#   file: "tabbed_dashboards.js"
#   # url : "http://localhost:8080/bundle.js"
#   entitlements: {
#     local_storage: yes
#     navigation: yes
#     new_window: yes
#     use_embeds: yes
#     use_form_submit: yes
#     core_api_methods: ["dashboard", "dashboard_dashboard_filters", "all_connections","search_folders", "run_inline_query", "me", "all_roles"]
#   }
# }
