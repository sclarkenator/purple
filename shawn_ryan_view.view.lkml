view: shawn_ryan_view {
  sql_table_name: marketing.adspend ;;


  dimension_group: Date {
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
    sql: ${TABLE}.date ;;
  }


dimension: partner {
  type: string
  sql: CASE
            when trim(lower(${TABLE}.ad_name)) like '%calps%' then 'AGENCY_WITHIN'
            else 'PURPLE'
        END ;;
}

dimension: campaign_name {
  type: string
  sql: ${TABLE}.campaign_name;;
}

  dimension: ad_name {
    type: string
    sql: ${TABLE}.ad_name;;
  }

measure: spend {
  type: sum
  value_format: "$0.00"
  sql: ${TABLE}.spend;;
}

dimension: primary_key{
  primary_key: yes
  hidden:  yes
  type: string
  sql: CONCAT(${TABLE}.spend, ${TABLE}.campaign_name, ${TABLE}.partner) ;;
  #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
}


}
