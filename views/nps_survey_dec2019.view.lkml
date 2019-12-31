view: nps_survey_dec2019 {derived_table: {
      sql:
      select "EMAIL","CREATED_DATE","FULFILLED_DATE","SURVEY_RECORDED_DATE","ITEM_ID","SKU_ID","TRANID","ORDER_ID",product,csat
      from (select *
          from analytics.csv_uploads.nps_survey_dec2019
          unpivot(csat for product in ("WEIGHTED_BLANKET","ULTIMATE_CUSHION","SLEEP_MASK","SIMPLY_CUSHION","SHEETS_TWIN_WHITE","SHEETS_TWIN_SLATE","SHEETS_TWIN_SAND","SHEETS_TWIN_PURPLE","SHEETS_SPLIT_KING_WHITE","SHEETS_SPLIT_KING_SLATE","SHEETS_SPLIT_KING_SAND","SHEETS_SPLIT_KING_PURPLE","SHEETS_KING_WHITE","SHEETS_KING_SLATE","SHEETS_KING_SAND","SHEETS_KING_PURPLE","SHEETS_FULL_WHITE","SHEETS_FULL_SLATE","SHEETS_FULL_SAND","SHEETS_FULL_PURPLE","ROYAL_CUSHION","PURPLE_PLUSH_PILLOW_KING","PURPLE_PLUSH_PILLOW","PURPLE_PILLOW","PURPLE_MATTRESS_TWIN_XL","PURPLE_MATTRESS_TWIN","PURPLE_MATTRESS_SPLIT_KING","PURPLE_MATTRESS_QUEEN","PURPLE_MATTRESS_KING","PURPLE_MATTRESS_FULL","PURPLE_MATTRESS_CAL_KING","POWERBASE_TWIN_XL","POWERBASE_SPLIT_KING","POWERBASE_QUEEN","PORTABLE_CUSHION","PLATFORM_BASE_TWIN_XL","PLATFORM_BASE_TWIN","PLATFORM_BASE_QUEEN","PLATFORM_BASE_KING","PLATFORM_BASE_FULL","PLATFORM_BASE_CALIFORNIA_KING","PET_BED_SMALL","PET_BED_MEDIUM","PET_BED_LARGE","MATTRESS_PROTECTOR_TWIN_XL","MATTRESS_PROTECTOR_TWIN","MATTRESS_PROTECTOR_SPLIT_KING","MATTRESS_PROTECTOR_QUEEN","MATTRESS_PROTECTOR_KING","MATTRESS_PROTECTOR_FULL_XL","MATTRESS_PROTECTOR_FULL","MATTRESS_PROTECTOR_CALIFORNIA_KING","HYBRID_PREMIER_4_TWIN_XL","HYBRID_PREMIER_4_SPLIT_KING","HYBRID_PREMIER_4_QUEEN","HYBRID_PREMIER_4_MATTRESS_KING","HYBRID_PREMIER_4_MATTRESS_FULL","HYBRID_PREMIER_4_CAL_KING","HYBRID_PREMIER_3_TWIN_XL","HYBRID_PREMIER_3_SPLIT_KING","HYBRID_PREMIER_3_QUEEN","HYBRID_PREMIER_3_MATTRESS_KING","HYBRID_PREMIER_3_MATTRESS_FULL","HYBRID_PREMIER_3_CAL_KING","HYBRID_MATTRESS_TWIN_XL","HYBRID_MATTRESS_SPLIT_KING","HYBRID_MATTRESS_QUEEN","HYBRID_MATTRESS_KING","HYBRID_MATTRESS_FULL","HYBRID_MATTRESS_CAL_KING","HARMONY_PILLOW_TALL","HARMONY_PILLOW","EVERYWHERE_CUSHION","DOUBLE_CUSHION","BACK_CUSHION"
                                 ))
                                );;
    }

  dimension: Primary_Key {
    type: string
    primary_key: yes
    sql:  ${TABLE}.email || ${TABLE}.item_id || ${TABLE}.order_id || ${TABLE}.FULFILLED_DATE;;
    hidden: yes
  }

  dimension: CSAT_Group {
    label: "Survey Response Group"
    description: "Aggregate survey responses by Promoter, Passive, and Detractor"
    type: string
    case: {
      when: {
        sql: ${TABLE}.csat = 'Extremely satisfied' ;;
        label: "Promoter"
      }
      when: {
        sql: ${TABLE}.csat = 'Somewhat satisfied' ;;
        label: "Passive"
      }
      when: {
        sql: ${TABLE}.csat = 'Neither satisfied nor dissatisfied' ;;
        label: "Detractor"
      }
      when: {
        sql: ${TABLE}.csat = 'Somewhat dissatisfied' ;;
        label: "Detractor"
      }
      when: {
        sql: ${TABLE}.csat = 'Extremely dissatisfied' ;;
        label: "Detractor"
      }
      when: {
        sql: ${TABLE}.csat = 'I did not order/receive that product' ;;
        label: "Did not Order/Receive"
      }
      else: "Unanswered"
      }
    }

  dimension_group: created {
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
    label: "Order Created"
    sql: ${TABLE}."CREATED_DATE" ;;
  }

    measure: count {
      type: count
      drill_fields: []
    }

    dimension: email {
      label: "Email"
      type: string
      sql: ${TABLE}."EMAIL" ;;
    }

    dimension_group: fulfilled {
      type: time
      label: "Order Fulfilled"
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
      sql: ${TABLE}.fulfilled_date ;;
    }

    dimension_group: survey_recorded {
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
      sql: ${TABLE}.survey_recorded_date ;;
    }

    dimension: item_id {
      type: string
      hidden: yes
      sql: ${TABLE}."ITEM_ID" ;;
    }

    dimension: sku_id {
      type: string
      hidden: yes
      sql: ${TABLE}."SKU_ID" ;;
    }

    dimension: tranid {
      type: string
      hidden: yes
      sql: ${TABLE}."TRANID" ;;
    }

    dimension: order_id {
      type: string
      hidden: yes
      sql: ${TABLE}."ORDER_ID" ;;
    }

    dimension: product {
      type: string
      hidden: yes
      sql: ${TABLE}."PRODUCT" ;;
    }

    dimension: csat {
      label: "Survey Response"
      description: "Customer's selected response in the survey"
      type: string
      case: {
        when: {
          sql: ${TABLE}."CSAT" = 'Extremely satisfied' ;;
          label: "Extremely Satisfied"
        }
        when: {
          sql: ${TABLE}."CSAT" = 'Somewhat satisfied' ;;
          label: "Somewhat Satisfied"
        }
        when: {
          sql: ${TABLE}."CSAT" = 'Neither satisfied nor dissatisfied' ;;
          label: "Neither Satisfied nor Dissatisfied"
        }
        when: {
          sql: ${TABLE}."CSAT" = 'Somewhat dissatisfied' ;;
          label: "Somewhat Dissatisfied"
        }
        when: {
          sql: ${TABLE}."CSAT" = 'Extremely dissatisfied' ;;
          label: "Extremely Dissatisfied"
        }
        else: "Unanswered"
      }
    }

    set: detail {
      fields: [
        email,
        created_date,
        fulfilled_date,
        survey_recorded_date,
        item_id,
        sku_id,
        tranid,
        order_id,
        product,
        csat
      ]
    }
    }
