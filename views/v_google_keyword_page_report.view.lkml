view: v_google_keyword_page_report {
  sql_table_name: "MARKETING"."V_GOOGLE_KEYWORD_PAGE_REPORT"
    ;;

  dimension_group: _fivetran_synced {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."_FIVETRAN_SYNCED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: country {
    label: "Country"
    type: string
    map_layer_name: countries
    sql: ${TABLE}."COUNTRY" ;;
  }

  dimension: keyword_type {
    label: "Keyword Type"
    type: string
    sql: case when ${keyword} ilike '%purple%' then 'brand'
    else 'non-brand' end;;
  }

  dimension_group: date {
    label: "Date"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."DATE" ;;
  }
     dimension: liquid_date {
      label: "Liquid Date"
      description: "For dynamic access. If > 365 days in the look, than month, if > 30 than week, else day"
      sql:
          CASE
            WHEN
              datediff(
                      'day',
                      cast({% date_start date_date %} as date),
                      cast({% date_end date_date  %} as date)
                      ) >365
            THEN cast(${date_month} as varchar)
            WHEN
              datediff(
                      'day',
                      cast({% date_start date_date %} as date),
                      cast({% date_end date_date  %} as date)
                      ) >30
            THEN cast(${date_week} as varchar)
            else ${date_date}
            END
          ;;
    }

    parameter: see_data_by {
      description: "This is a parameter filter that changes the value of See Data By dimension.  Source: looker.calculation"
      hidden: yes
      type: unquoted
      allowed_value: {
        label: "Day"
        value: "day"
      }
      allowed_value: {
        label: "Week"
        value: "week"
      }
      allowed_value: {
        label: "Month"
        value: "month"
      }
      allowed_value: {
        label: "Quarter"
        value: "quarter"
      }
      allowed_value: {
        label: "Year"
        value: "year"
      }
    }

    dimension: see_data {
      label: "See Data By"
      description: "This is a dynamic dimension that changes when you change the See Data By filter.  Source: looker.calculation"
      hidden: yes
      sql:
        {% if see_data_by._parameter_value == 'day' %}
          ${date_date}
        {% elsif see_data_by._parameter_value == 'week' %}
          ${date_week}
        {% elsif see_data_by._parameter_value == 'month' %}
          ${date_month}
        {% elsif see_data_by._parameter_value == 'quarter' %}
          ${date_quarter}
        {% elsif see_data_by._parameter_value == 'year' %}
          ${date_year}
        {% else %}
          ${date_date}
        {% endif %};;
    }
  dimension: device {
    label: "Device"
    type: string
    sql: ${TABLE}."DEVICE" ;;
  }

  dimension: keyword {
    label: "Keyword"
    type: string
    sql: ${TABLE}."KEYWORD" ;;
  }

  dimension: page {
    label: "Page"
    type: string
    sql: ${TABLE}."PAGE" ;;
  }

  dimension: position {
    label: "Position"
    type: number
    sql: ${TABLE}."POSITION" ;;
  }

  dimension: search_type {
    label: "Search Type"
    type: string
    sql: ${TABLE}."SEARCH_TYPE" ;;
  }

  dimension: site {
    label: "Site"
    type: string
    sql: ${TABLE}."SITE" ;;
  }
  measure: clicks {
    label: "Clicks"
    type: sum
    sql: ${TABLE}."CLICKS" ;;
  }
  measure: ctr {
    label: "CTR"
    type: number
    value_format: "00.00%"
    sql: (${clicks}/NULLIF(${impressions},0));;
    }
  measure: impressions {
    label: "Impression"
    type: sum
    sql: ${TABLE}."IMPRESSIONS" ;;
  }
  measure: count {
    type: count
    drill_fields: []
  }
}
