view: tealium_visitors_view_normalized {
  sql_table_name: "TEALIUM"."VISITORS_VIEW_NORMALIZED"
    ;;

  dimension: visitor_id {
    label: "Visitor ID"
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}."VISITOR_ID" ;;
  }

  dimension_group: expire_day {
    group_label: "Visitor Metrics"
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
    sql: ${TABLE}."EXPIRE_DAY" ;;
  }

  dimension_group: updated {
    group_label: "Visitor Metrics"
    label: "visitor updated"
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
    sql: ${TABLE}."UPDATED" ;;
  }

  dimension: va_blanket_fans {
    type: yesno
    label: "Blanket Fan"
    group_label: "Fan Audiences"
    sql: ${TABLE}."VA_BLANKET_FANS" ;;
  }

  dimension: va_bundle_fans {
    label: "Bundle Fan"
    group_label: "Fan Audiences"
    type: yesno
    sql: ${TABLE}."VA_BUNDLE_FANS" ;;
  }

  dimension: va_cart_abandoner {
    group_label: "Audiences"
    label: "Cart Abandoner"
    type: yesno
    sql: ${TABLE}."VA_CART_ABANDONER" ;;
  }

  dimension: va_ccpa {
    group_label: "Audiences"
    label: "CCPA Opt Out"
    type: yesno
    sql: ${TABLE}."VA_CCPA" ;;
  }

  dimension: va_duvet_fans {
    group_label: "Fan Audiences"
    type: yesno
    label: "Duvet Fan"
    sql: ${TABLE}."VA_DUVET_FANS" ;;
  }

  dimension: va_financing_fans {
    group_label: "Fan Audiences"
    label: "Financing Fan"
    type: yesno
    sql: ${TABLE}."VA_FINANCING_FANS" ;;
  }

  dimension: va_foundation_fans {
    group_label: "Fan Audiences"
    label: "Foundation Fan"
    type: yesno
    sql: ${TABLE}."VA_FOUNDATION_FANS" ;;
  }

  dimension: va_frequent_visitor {
    group_label: "Audiences"
    label: "Frequent Visitor"
    type: yesno
    sql: ${TABLE}."VA_FREQUENT_VISITOR" ;;
  }

  dimension: va_hybrid_premier_fans {
    group_label: "Fan Audiences"
    label: "Hybrid Premier Fan"
    type: yesno
    sql: ${TABLE}."VA_HYBRID_PREMIER_FANS" ;;
  }

  dimension: va_likelihood_of_purchasing_mattress_in_next_30_days_70_plus {
    hidden: yes
    type: yesno
    sql: ${TABLE}."VA_LIKELIHOOD_OF_PURCHASING_MATTRESS_IN_NEXT_30_DAYS_70_PLUS" ;;
  }

  dimension: va_mask_fans {
    group_label: "Fan Audiences"
    label: "Mask Fan"
    type: yesno
    sql: ${TABLE}."VA_MASK_FANS" ;;
  }

  dimension: va_mattress_fans {
    group_label: "Fan Audiences"
    label: "Mattress Fan"
    type: yesno
    sql: ${TABLE}."VA_MATTRESS_FANS" ;;
  }

  dimension: va_pet_bed_fans {
    group_label: "Fan Audiences"
    label: "Pet Bed Fan"
    type: yesno
    sql: ${TABLE}."VA_PET_BED_FANS" ;;
  }

  dimension: va_pillow_fans {
    group_label: "Fan Audiences"
    label: "Pillow Fan"
    type: yesno
    sql: ${TABLE}."VA_PILLOW_FANS" ;;
  }

  dimension: va_platform_fans {
    group_label: "Fan Audiences"
    label: "Platform Fan"
    type: yesno
    sql: ${TABLE}."VA_PLATFORM_FANS" ;;
  }

  dimension: va_powerbase_fans {
    group_label: "Fan Audiences"
    label: "Powerbase Fan"
    type: yesno
    sql: ${TABLE}."VA_POWERBASE_FANS" ;;
  }

  dimension: va_seat_cushion_fans {
    group_label: "Fan Audiences"
    label: "Seat Cushion Fan"
    type: yesno
    sql: ${TABLE}."VA_SEAT_CUSHION_FANS" ;;
  }

  dimension: va_sheets_fans {
    group_label: "Fan Audiences"
    label: "Sheet Fan"
    type: yesno
    sql: ${TABLE}."VA_SHEETS_FANS" ;;
  }

  dimension: va_vip {
    group_label: "Audiences"
    label: "VIP"
    type: yesno
    sql: ${TABLE}."VA_VIP" ;;
  }

  dimension: vb_initiate_checkout_abandoner {
    group_label: "Audiences"
    label: "Initiate Checkout Abandoner"
    type: yesno
    sql: ${TABLE}."VB_INITIATE_CHECKOUT_ABANDONER" ;;
  }

  dimension: vb_unbadged {
    group_label: "Audiences"
    label: "Unbadged"
    type: yesno
    sql: ${TABLE}."VB_UNBADGED" ;;
  }


  dimension_group: vd_first_visit {
    label: "First Visit"
    group_label: "Visitor Metrics"
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
    sql: ${TABLE}."VD_FIRST_VISIT" ;;
  }

  dimension_group: vd_last_visit {
    label: "Last Visit"
    group_label: "Visitor Metrics"
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
    sql: ${TABLE}."VD_LAST_VISIT" ;;
  }

  dimension_group: visitor_created {
    label: "Visitor Created"
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
    sql: ${TABLE}."VISITOR_CREATED" ;;
  }


  dimension: visitor_secondary_id_cordial_id {
    type: string
    hidden: yes
    sql: ${TABLE}."VISITOR_SECONDARY_ID_CORDIAL_ID" ;;
  }

  dimension: visitor_secondary_id_customer_email_id {
    type: string
    hidden: yes
    sql: ${TABLE}."VISITOR_SECONDARY_ID_CUSTOMER_EMAIL_ID" ;;
  }

  dimension: vp_cordial_id {
    hidden: yes
    type: string
    sql: ${TABLE}."VP_CORDIAL_ID" ;;
  }

  dimension: vp_customer_email {
    hidden: yes
    type: string
    sql: ${TABLE}."VP_CUSTOMER_EMAIL" ;;
  }

  dimension: vp_lifetime_browser_types_used_favorite {
    group_label: "Visitor Metrics"
    label: "Favorite Browser Types Used"
    type: string
    sql: ${TABLE}."VP_LIFETIME_BROWSER_TYPES_USED_FAVORITE" ;;
  }

  dimension: vp_lifetime_devices_used_favorite {
    group_label: "Visitor Metrics"
    label: "Favorite Lifetime Devices Used"
    type: string
    sql: ${TABLE}."VP_LIFETIME_DEVICES_USED_FAVORITE" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
