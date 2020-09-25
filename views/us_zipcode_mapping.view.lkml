view: us_zipcode_mapping {
  derived_table: {
    sql:
    select
      case
        when not zcta and parent_zcta is not null then parent_zcta
        else zip
      end as parent_zcta,
      zip
    from analytics.util.us_zipcode;;
   }

  dimension: zip {
    primary_key: yes
    view_label: "Geography"
    group_label: "Demographics"
    label: "Zipcode"
    description: "Source: looker_block.us_zipcode"
    hidden: yes
    type: zipcode
    sql: ${TABLE}."ZIP" ;;
  }

  dimension: parent_zcta {
    view_label: "Geography"
    group_label: "Demographics"
    label: "Parent ZCTA"
    description: "Source: looker_block.us_zipcode"
    hidden: yes
    type: string
    sql: ${TABLE}."PARENT_ZCTA" ;;
  }

}
