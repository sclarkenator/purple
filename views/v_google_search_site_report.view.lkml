# view: v_google_search_site_report {
#   sql_table_name: "MARKETING"."V_GOOGLE_SEARCH_SITE_REPORT"
#     ;;

#   dimension_group: _fivetran_synced {
#     type: time
#     hidden: yes
#     timeframes: [
#       raw,
#       time,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     sql: CAST(${TABLE}."_FIVETRAN_SYNCED" AS TIMESTAMP_NTZ) ;;
#   }

#   dimension: country {
#     label: "Country"
#     type: string
#     map_layer_name: countries
#     sql: ${TABLE}."COUNTRY" ;;
#   }

#   dimension: search_type {
#     label: "Search Type"
#     type: string
#     sql: ${TABLE}."SEARCH_TYPE" ;;
#   }

#   dimension: site {
#     label: "Site"
#     type: string
#     sql: ${TABLE}."SITE" ;;}

#   dimension_group: date {
#     type: time
#     timeframes: [
#       raw,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     convert_tz: no
#     datatype: date
#     sql: ${TABLE}."DATE" ;;
#   }

#   dimension: device {
#     label: "Device Type"
#     type: string
#     sql: ${TABLE}."DEVICE" ;;
#   }

#   measure: clicks {
#     label: "Clicks"
#     type: sum
#     sql: ${TABLE}."CLICKS" ;;
#   }

#   measure: impressions {
#     label: "Impressions"
#     type: sum
#     sql: ${TABLE}."IMPRESSIONS" ;;
#   }

#   measure: ctr {
#     label: "  CTR"
#     description: " (Total Clicks / Total Impressions) *100"
#     type: number
#     value_format: "00.00%"
#     sql: (${clicks}/NULLIF(${impressions},0));;  }

#   measure: position {
#     type: number
#     sql: ${TABLE}."POSITION" ;;
#   }

# }
