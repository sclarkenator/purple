view: l2l_quality_yellow_card {
  sql_table_name: "L2L"."V_QUALITY_YELLOW_CARD"
    ;;

  dimension: area {
    type: string
    sql: ${TABLE}."AREA" ;;
  }

  dimension: bed_size {
    type: string
    description: "Source: l2l.v_quality_yellow_card"
    sql: case when ${TABLE}."BED_SIZE" = 'T' then 'TWIN'
      when ${TABLE}."BED_SIZE" = 'TXL' then 'TWINXL'
      when ${TABLE}."BED_SIZE" = 'F' then 'FULL'
      when ${TABLE}."BED_SIZE" = 'Q' then 'QUEEN'
      when ${TABLE}."BED_SIZE" = 'K' then 'KING'
      when ${TABLE}."BED_SIZE" = 'CK' then 'CKING'
      else ${TABLE}."BED_SIZE"
      end ;;
  }

  dimension: bed_type {
    type: string
    description: "Source: l2l.v_quality_yellow_card"
    sql: case when ${TABLE}."BED_TYPE" = 'OG' THEN 'ORIGINAL PURPLE MATTRESS'
      WHEN ${TABLE}."BED_TYPE" = 'NOG' THEN 'THE PURPLE MATTRESS'
      WHEN ${TABLE}."BED_TYPE" = '2' THEN 'HYBRID 2'
      WHEN ${TABLE}."BED_TYPE" = '3' THEN 'HYBRID PREMIER 3'
      WHEN ${TABLE}."BED_TYPE" = '4' THEN 'HYBRID PREMIER 4'
      ELSE ${TABLE}."BED_TYPE"
      END ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}."CREATED" ;;
  }

  dimension_group: shift_time{
    label: "Shift Timescale"
    description: "Adjusts the Produced time to make 0700 to 0000. This sets the beginning of the day as the beginning of the shift. 0000 - 0100 is the first hour of the AM shift."
    type: time
    timeframes: [raw, time, date,hour_of_day, day_of_week, day_of_month, week, week_of_year,hour, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(Dateadd(hour,-7,${TABLE}.created));;
  }

  dimension: date {
    type: string
    sql: ${TABLE}."DATE" ;;
  }

  dimension: defect_location {
    type: string
    sql: ${TABLE}."DEFECT_LOCATION" ;;
  }


  dimension: defect_type {
    type: string
    sql: ${TABLE}."DEFECT_TYPE" ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: details {
    type: string
    sql: ${TABLE}."DETAILS" ;;
  }

  dimension: dispatch_num {
    type: string
    sql: ${TABLE}."DISPATCH_NUM" ;;
  }

  dimension: line {
    type: string
    sql: ${TABLE}."LINE" ;;
  }

  dimension: machine_code {
    type: string
    sql: ${TABLE}."MACHINE_CODE" ;;
  }

  dimension_group: modified {
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
    sql: ${TABLE}."MODIFIED" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: number {
    type: string
    sql: ${TABLE}."NUMBER" ;;
  }

  dimension: prod_approval_name {
    type: string
    sql: ${TABLE}."PROD_APPROVAL_NAME" ;;
  }

  dimension: product {
    type: string
    sql: ${TABLE}."PRODUCT" ;;
  }

  dimension: shift {
    type: string
    sql: ${TABLE}."SHIFT" ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}."SOURCE" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: technology {
    type: string
    sql: ${TABLE}."TECHNOLOGY" ;;
  }

  dimension: workorder_num {
    type: string
    sql: ${TABLE}."WORKORDER_NUM" ;;
  }

  dimension: what_for {
    label: "Whats this for?"
    type: string
    sql: ${TABLE}."WHAT_FOR" ;;
  }

  dimension: part_no {
    label: "Part Number"
    type: string
    sql: ${TABLE}."PART_No" ;;
  }

  dimension: vendor_name {
    type: string
    sql: ${TABLE}."VENDOR_NAME" ;;
  }

  dimension: machine_description {
    type: string
    sql: ${TABLE}."MACHINE_DESCRIPTION" ;;
  }

  dimension: cover_sealed {
    label: "Cover Sealed?"
    type: yesno
    sql: ${TABLE}.COVER_SEALED ;;
  }

  dimension: site {
    label: "Production Site"
    type: string
    sql: CASE WHEN ${TABLE}.site = '2' THEN 'Grantsville'
              WHEN ${TABLE}.site = '3' THEN 'Alpine'
              WHEN ${TABLE}.site = '4' THEN 'McDonough'
              ELSE ${TABLE}.site END;;
  }

  measure: quantity {
    type: sum
    sql: ${TABLE}."QUANTITY" ;;
    #sql: case when ${TABLE}."QUANTITY" >= 100 then 1 else ${TABLE}."QUANTITY" end ;;
    }

  measure: count {
    type: count
    drill_fields: [prod_approval_name, name]
  }
}
