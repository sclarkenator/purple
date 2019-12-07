view: product_csat_dec_2019 {

  derived_table: {
    sql:

select "Start Date", "End Date", "Response Type", "IP Address", "PROGRESS", "FINISHED", "Recorded Date"
    , "Response ID", "Recipient Email", product, csat
    , case when product = 'Hybrid Premier 4 Mattress - King' then 'Hybrid Premier 4 - King'
     when product = 'Hybrid Premier 4 Mattress - Full' then 'Hybrid Premier 4 - Full'
     when product = 'Hybrid Premier 3 Mattress - King' then 'Hybrid Premier 3 - King'
     when product = 'Hybrid Premier 3 Mattress - Full' then 'Hybrid Premier 3 - Full'
     when product = 'Hybrid Premier 4 - Twin XL 2' then 'Hybrid Premier 4 - Twin XL'
     when product = 'Hybrid Premier 3 Mattress - Full 2' then 'Hybrid Premier 3 - Full'
     when product = 'Hybrid Premier 3 - Cal King 2' then 'Hybrid Premier 3 - Cal King'
     when product = 'Hybrid Mattress - Twin XL 2' then 'Hybrid Mattress - Twin XL'
     when product = 'Mattress Protector - Split King 2' then 'Mattress Protector - Split King'
     when product = 'Hybrid Mattress - Split King 2' then 'Hybrid Mattress - Split King'
     when product = 'Hybrid Premier 3 - Queen 2' then 'Hybrid Premier 3 - Queen'
     when product = 'Hybrid Premier 3 Mattress - King 2' then 'Hybrid Premier 3 - King'
     when product = 'Hybrid Premier 3 - Twin XL 2' then 'Hybrid Premier 3 - Twin XL'
     when product = 'Hybrid Premier 4 - Cal King 2' then 'Hybrid Premier 4 - Cal King'
     when product = 'Hybrid Premier 4 Mattress - Full 2' then 'Hybrid Premier 4 - Full'
     when product = 'Hybrid Premier 4 Mattress - King 2' then 'Hybrid Premier 4 - King'
     when product = 'Hybrid Premier 4 - Queen 2' then 'Hybrid Premier 4 - Queen'
     when product = 'Hybrid Premier 4 - Split King 2' then 'Hybrid Premier 4 - Split King'
     else product end as product_cleaned
from (select *
          from analytics.csv_uploads.nps_survey_06dec2019
          unpivot(csat for product in ("Purple Mattress - Twin XL"
                                 , "Purple Mattress - Twin"
                                 , "Purple Mattress - Split King"
                                 , "Purple Mattress - Queen"
                                 , "Purple Mattress - King"
                                 , "Purple Mattress - Full"
                                 , "Purple Mattress - Cal King"
                                 , "Hybrid Premier 4 Mattress - King" --as "Hybrid Premier 4 - King"
                                 , "Hybrid Premier 4 Mattress - Full" --as "Hybrid Premier 4 - Full"
                                 , "Hybrid Premier 4 - Twin XL"
                                 , "Hybrid Premier 4 - Split King"
                                 , "Hybrid Premier 4 - Queen"
                                 , "Hybrid Premier 4 - Cal King"
                                 , "Hybrid Premier 3 Mattress - King" --as "Hybrid Premier 3 - King"
                                 , "Hybrid Premier 3 Mattress - Full" --as "Hybrid Premier 3 - Full"
                                 , "Hybrid Premier 3 - Twin XL"
                                 , "Hybrid Premier 3 - Queen"
                                 , "Hybrid Premier 3 - Cal King"
                                 , "Hybrid Mattress - Twin XL"
                                 , "Hybrid Mattress - Split King"
                                 , "Hybrid Premier 4 - Twin XL 2" --as "Hybrid Premier 4 - Twin XL"
                                 , "Hybrid Mattress - King"
                                 , "Hybrid Mattress - Full"
                                 , "Hybrid Mattress - Cal King"
                                 , "Hybrid Premier 3 - Split King"
                                 , "Hybrid Premier 3 Mattress - Full 2" --as "Hybrid Premier 3 - Full"
                                 , "Hybrid Premier 3 - Cal King 2" --as "Hybrid Premier 3 - Cal King"
                                 , "Hybrid Mattress - Twin XL 2" --as "Hybrid Mattress - Twin XL"
                                 , "Mattress Protector - Split King 2" --as "Mattress Protector - Split King"
                                 , "Hybrid Mattress - Split King 2" --as "Hybrid Mattress - Split King"
                                 , "Hybrid Premier 3 - Queen 2" --as "Hybrid Premier 3 - Queen"
                                 , "Hybrid Premier 3 Mattress - King 2" --as "Hybrid Premier 3 - King"
                                 , "Mattress Protector - Full XL"
                                 , "Ultimate Cushion"
                                 , "Simply Cushion"
                                 , "Royal Cushion"
                                 , "Portable Cushion"
                                 , "Back Cushion"
                                 , "Double Cushion"
                                 , "Mattress Protector - Split King "
                                 , "Hybrid Premier 3 - Twin XL 2" --as "Hybrid Premier 3 - Twin XL"
                                 , "Hybrid Premier 4 - Cal King 2" --as "Hybrid Premier 4 - Cal King"
                                 , "Hybrid Premier 4 Mattress - Full 2" --as "Hybrid Premier 4 - Full"
                                 , "Hybrid Premier 4 Mattress - King 2" --as "Hybrid Premier 4 - King"
                                 , "Hybrid Premier 4 - Queen 2" --as "Hybrid Premier 4 - Queen"
                                 , "Hybrid Premier 4 - Split King 2" --as "Hybrid Premier 4 - Split King"
                                 , "Platform Base - Queen"
                                 , "Platform Base - Twin"
                                 , "Platform Base - Twin XL"
                                 , "PowerBase - Twin XL"
                                 , "PowerBase - Queen"
                                 , "PowerBase - Split King"
                                 , "Harmony Pillow"
                                 , "Harmony Pillow - Tall"
                                 , "Purple Pillow"
                                 , "Purple Plush Pillow"
                                 , "Purple Plush Pillow - King"
                                 , "Weighted Blanket"
                                 , "Sleep Mask"
                                 , "Sheets - Full (Sand)"
                                 , "Sheets - Split King (Sand)"
                                 , "Sheets - Full (Slate)"
                                 , "Sheets - Twin (Sand)"
                                 , "Sheets - Full (White)"
                                 , "Sheets - Full (Purple)"
                                 , "Sheets - King (Purple)"
                                 , "Sheets - King (Purple)"
                                 , "Sheets - King (Sand)"
                                 , "Sheets - King (Slate)"
                                 , "Sheets - Twin (Purple)"
                                 , "Sheets - King (White)"
                                 , "Sheets - Split King (Purple)"
                                 , "Sheets - Split King (Slate)"
                                 , "Sheets - Split King (White)"
                                 , "Sheets - Twin (Slate)"
                                 , "Sheets - Twin (White)"
                                 ))
                                )
      ;;
  }


  dimension: key {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}."Response ID"||${TABLE}.product_cleaned ;;
  }

  dimension_group: start {
    type: time
    hidden: yes
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
    sql: ${TABLE}."Start Date" ;;
  }

  dimension_group: end {
    type: time
    hidden: yes
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
    sql: ${TABLE}."End Date" ;;
  }

  dimension_group: response {
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
    sql: ${TABLE}."Recorded Date" ;;
  }

  dimension: survey_finished {
    type: yesno
    sql: ${TABLE}.FINISHED ;;
  }

  dimension: response_id {
    type: string
    sql: ${TABLE}."Response ID" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."Recipient Email" ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_cleaned ;;
  }

  dimension: csat {
    type: string
    label: "CSAT"
    sql: ${TABLE}.csat ;;
  }

  measure: response_count {
    type: count
  }

  ## item categorization
  dimension: production_buckets {
    type: string
    sql: case when lower(${TABLE}.product) like ('%sheet%') then 'SHEETS'
          when lower(${TABLE}.product) like ('%purple mattress%') then 'MATTRESS'
          when lower(${TABLE}.product) like ('%hybrid%') then 'MATTRESS'
          when lower(${TABLE}.product) like ('%cushion%') then 'CUSHION'
          when lower(${TABLE}.product) like ('%protector%') then 'PROTECTOR'
          when lower(${TABLE}.product) like ('%power%') then 'POWERBASE'
          when lower(${TABLE}.product) like ('%platform%') then 'PLATFORM'
          when lower(${TABLE}.product) like ('%pillow%') then 'PILLOW'
          when lower(${TABLE}.product) like ('%mask%') then 'MASK'
          when lower(${TABLE}.product) like ('%weighted blanket%') then 'BLANKET'
          when lower(${TABLE}.product) like ('%mask%') then 'MASK'
          else 'bacon'
          end
          ;;
  }

  dimension: mattress_model {
    type: string
    sql: case when lower(${TABLE}.product) like ('%purple mattress%') then 'NEW ORIGNAL'
          when lower(${TABLE}.product) like ('%hybrid mattress%') then 'PURPLE.2'
          when lower(${TABLE}.product) like ('%premier 3%') then 'PURPLE.3'
          when lower(${TABLE}.product) like ('%premier 4%') then 'PURPLE.4'
          else NULL
          end
    ;;
  }

  dimension: mattress_size {
    type: string
    sql: case lower(${TABLE}.product) like ('%cal king%') then 'CAL KING'
          when lower(${TABLE}.product) like ('%split king%') then 'SPLIT KING'
          when lower(${TABLE}.product) like ('%king%') then 'KING'
          when lower(${TABLE}.product) like ('%queen%') then 'QUEEN'
          when lower(${TABLE}.product) like ('%full%') then 'FULL'
          when lower(${TABLE}.product)  = 'harmony pillow' then 'QUEEN'
          when lower(${TABLE}.product)  = 'purple plush pillow' then 'QUEEN'
          when lower(${TABLE}.product) like ('%twin xl%') then 'TWIN XL'
          when lower(${TABLE}.product) like ('%twin%') then 'TWIN'
          when lower(${TABLE}.product) like ('%tall%') then 'TALL'
          else NULL
          end
    ;;
  }

  dimension: sheet_color {
    type: string
    sql: case lower(${production_buckets}) = 'sheets' and lower(${TABLE}.product) like ('%sand%') then 'SAND'
          when lower(${production_buckets}) = 'sheets' and lower(${TABLE}.product) like ('%white%') then 'WHITE'
          when lower(${production_buckets}) = 'sheets' and lower(${TABLE}.product) like ('%purple%') then 'PURPLE'
          when lower(${production_buckets}) = 'sheets' and lower(${TABLE}.product) like ('sand') then 'SLATE'
          else NULL
          end
    ;;
  }

}
