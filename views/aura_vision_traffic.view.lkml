view: aura_vision_traffic {
  sql_table_name: "RETAIL"."AURA_VISION_TRAFFIC"
    ;;

  dimension: PK {
    primary_key: yes
    hidden: yes
    sql: ${created_date}||'-'||${location}||'-'||${metric}||'-'||${context} ;;
  }

  dimension_group: created {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: location {
    hidden: yes
    description: "Source: aura_vision.aura_vision_traffic"
    type: string
    sql: ${TABLE}."LOCATION" ;;
  }

  dimension: metric {
    group_label: " Advanced"
    description: "Source: aura_vision.aura_vision_traffic"
    type: string
    sql: ${TABLE}."METRIC" ;;
  }

  dimension: context {
    group_label: " Advanced"
    description: "Location within the store. Source: aura_vision.aura_vision_traffic"
    type: string
    sql: ${TABLE}."CONTEXT" ;;
  }


  dimension: showroom_name {
    hidden: yes
    description: "Source: aura_vision.aura_vision_traffic"
    type: string
    sql: ${TABLE}."SHOWROOM_NAME" ;;
  }

  measure: breakdownby_age_16_to_24 {
    group_label: "Break Down By"
    label: "Age: 16 to 24"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."BREAKDOWNBY_AGE_16_TO_24" ;;
  }

  measure: breakdownby_age_25_to_34 {
    group_label: "Break Down By"
    label: "Age: 25 to 34"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."BREAKDOWNBY_AGE_25_TO_34" ;;
  }

  measure: breakdownby_age_35_to_44 {
    group_label: "Break Down By"
    label: "Age: 35 to 44"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."BREAKDOWNBY_AGE_35_TO_44" ;;
  }

  measure: breakdownby_age_45_to_54 {
    group_label: "Break Down By"
    label: "Age: 45 to 54"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."BREAKDOWNBY_AGE_45_TO_54" ;;
  }

  measure: breakdownby_age_55_to_64 {
    group_label: "Break Down By"
    label: "Age: 55 to 64"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."BREAKDOWNBY_AGE_55_TO_64" ;;
  }

  measure: breakdownby_age_under_16 {
    group_label: "Break Down By"
    label: " Age: Under 16"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."BREAKDOWNBY_AGE_UNDER_16" ;;
  }

  measure: breakdownby_gender_female {
    group_label: "Break Down By"
    label: "Female"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."BREAKDOWNBY_GENDER_FEMALE" ;;
  }

  measure: breakdownby_gender_male {
    group_label: "Break Down By"
    label: "Male"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."BREAKDOWNBY_GENDER_MALE" ;;
  }

  measure: breakdownby_role_customer {
    hidden: yes
    group_label: "Break Down By"
    label: "Customer"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."BREAKDOWNBY_ROLE_CUSTOMER" ;;
  }

  measure: breakdownby_role_staff {
    hidden: yes
    group_label: "Break Down By"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."BREAKDOWNBY_ROLE_STAFF" ;;
  }

  measure: category_16_to_24_customer {
    group_label: "Category"
    label: "Age: 16 to 24"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."CATEGORY_16_TO_24_CUSTOMER" ;;
  }

  measure: category_25_to_34_customer {
    group_label: "Category"
    label: "Age: 25 to 34"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."CATEGORY_25_TO_34_CUSTOMER" ;;
  }

  measure: category_45_to_54_customer {
    group_label: "Category"
    label: "Age: 45 to 54"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."CATEGORY_45_TO_54_CUSTOMER" ;;
  }

  measure: category_55_to_64_customer {
    group_label: "Category"
    label: "Age: 55 to 64"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."CATEGORY_55_TO_64_CUSTOMER" ;;
  }

  measure: category_customer {
    group_label: "Category"
    label: "Customer"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."CATEGORY_CUSTOMER" ;;
  }

  measure: category_female_16_to_24_customer {
    group_label: "Category"
    label: "Female Age: 16 to 24"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."CATEGORY_FEMALE_16_TO_24_CUSTOMER" ;;
  }

  measure: category_female_25_to_34_customer {
    group_label: "Category"
    label: "Female Age: 25 to 34"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."CATEGORY_FEMALE_25_TO_34_CUSTOMER" ;;
  }

  measure: category_female_35_to_44_customer {
    group_label: "Category"
    label: "Female Age: 35 to 44"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."CATEGORY_FEMALE_35_TO_44_CUSTOMER" ;;
  }

  measure: category_female_45_to_54_customer {
    group_label: "Category"
    label: "Female Age: 45 to 54"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."CATEGORY_FEMALE_45_TO_54_CUSTOMER" ;;
  }

  measure: category_female_55_to_64_customer {
    group_label: "Category"
    label: "Female Age: 55 to 64"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."CATEGORY_FEMALE_55_TO_64_CUSTOMER" ;;
  }

  measure: category_female_customer {
    group_label: "Category"
    label: "Female Customer"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."CATEGORY_FEMALE_CUSTOMER" ;;
  }

  measure: category_female_under_15_customer {
    group_label: "Category"
    label: "Female Age: Under 15"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."CATEGORY_FEMALE_UNDER_15_CUSTOMER" ;;
  }

  measure: category_male_16_to_24_customer {
    group_label: "Category"
    label: "Male Age: 16 to 24"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."CATEGORY_MALE_16_TO_24_CUSTOMER" ;;
  }

  measure: category_male_25_to_34_customer {
    group_label: "Category"
    label: "Male Age: 25 to 34"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."CATEGORY_MALE_25_TO_34_CUSTOMER" ;;
  }

  measure: category_male_35_to_44_customer {
    group_label: "Category"
    label: "Male Age: 35 to 44"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."CATEGORY_MALE_35_TO_44_CUSTOMER" ;;
  }

  measure: category_male_45_to_54_customer {
    group_label: "Category"
    label: "Male Age: 45 to 54"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."CATEGORY_MALE_45_TO_54_CUSTOMER" ;;
  }

  measure: category_male_55_to_64_customer {
    group_label: "Category"
    label: "Male Age: 55 to 64"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."CATEGORY_MALE_55_TO_64_CUSTOMER" ;;
  }

  measure: category_male_customer {
    group_label: "Category"
    label: "Male Customer"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."CATEGORY_MALE_CUSTOMER" ;;
  }

  measure: category_male_under_15_customer {
    group_label: "Category"
    label: "Male Age: Under 15"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."CATEGORY_MALE_UNDER_15_CUSTOMER" ;;
  }

  measure: category_under_15_customer {
    group_label: "Category"
    label: "Age: Under 15"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."CATEGORY_UNDER_15_CUSTOMER" ;;
  }

  measure: catetory_35_to_44_customer {
    group_label: "Category"
    label: "Age: 35 to 44"
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."CATETORY_35_TO_44_CUSTOMER" ;;
  }

  measure: overall_value {
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: ${TABLE}."OVERALL_VALUE" ;;
  }

  measure: Store_Entries {
    description: "Source: aura_vision.aura_vision_traffic"
    type: sum
    sql: case when ${TABLE}."METRIC" = 'Store > Entries' then ${TABLE}."OVERALL_VALUE" else 0 end ;;
  }


  measure: count {
    hidden: yes
    type: count
    drill_fields: [showroom_name]
  }
}
