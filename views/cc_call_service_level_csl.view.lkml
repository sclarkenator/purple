include: "/views/_period_comparison.view.lkml"
view: cc_call_service_level_csl {
  extends: [_period_comparison]
  derived_table: {
    sql: select sla_date date, service_level, contacts_within_SLA, contacts_outside_sla,  contacts_within_SLA+contacts_outside_sla as first_contacts, total_contacts, skill_name
      from customer_care.sla_summary slas
       left join customer_care.skill sk on slas.skill_id = sk.skill_id
       ;;
  }

  #### Used with period comparison view
  dimension_group: event {
    hidden: yes
    type: time
    timeframes: [ raw,time,time_of_day,date,day_of_week,day_of_week_index,day_of_month,day_of_year,
      week,month,month_num,quarter,quarter_of_year,year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date;;
  }

  measure: count {
    hidden: yes
    type: count
  #  drill_fields: [detail*]
  }

  dimension: date {
    type: date
    sql: ${TABLE}."DATE" ;;
  }

  dimension_group: SLA {
    type: time
    hidden: no
    timeframes: [raw,date,day_of_week,week,week_of_year,month,quarter,year]
    sql: ${TABLE}.date ;;
  }


  dimension: service_level {
    description: "Contacts within SLA / total first contacts"
    label: "Service Level (dimension version)"
    type: number
    value_format: "0\%"
    sql: ${TABLE}.SERVICE_LEVEL ;;
  }

  measure: contacts_within_SLA {
    description: "Number of first contacts responded to within 30 seconds"
    type: sum
    sql: ${TABLE}.contacts_within_sla ;;
  }

  measure: contacts_outside_sla {
    description: "Number of first contacts not responded to after 30 seconds"
    type: sum
    sql: ${TABLE}.contacts_outside_sla ;;
  }

  measure: first_contacts {
    description: "Number of first contacts that did not abandon within the first 15 seconds of being in queue"
    type: sum
    sql: ${TABLE}.FIRST_CONTACTS ;;
  }

  measure: service_lvl {
    description: "Percent of first contacts responded to within SLA"
    label: "Service Level"
    type: average
    value_format: "0.0\%"
    sql: ${TABLE}.SERVICE_LEVEL ;;
  }

  measure: total_contacts {
    description: "Total number of contacts"
    type: sum
    sql: ${TABLE}.total_contacts ;;
  }

  measure: true_service_level {
    type: number
    sql: ${contacts_within_SLA}/${first_contacts} ;;
  }
  #${cc_call_service_level_csl.contacts_within_SLA}/${cc_call_service_level_csl.first_contacts}

  dimension: skill_name {
    type: string
    sql: ${TABLE}.SKILL_NAME ;;
  }

  dimension: call_type {
    description: ""
    type: string
    sql:
    case
        when ${skill_name} in ('8885Purple','888Purple','AAA EnCompass','Abandoned Carts','American Legion Auxiliary','Archaeology Magazine','Arthritis Today','BOGO 50','C_D_L_Trucker_Discount','CDL_Trucker _Discount','Discover Magazine Ad','Doctors_Medical_Discount','Elks','FB Campaign','FKL Free Sheets 2Pillow','FKL_10Percent off Mattress','FKL_20Dollar_Off','FKL_SleepMask','Financing','First 100 Days','Fluent','Inbound Sales','Innovation and Tech Today','Magazine Ad','Mantra Wellness magazine','Military Officer','MyMove','Online Chat','Parade 1','Parade 2','Presidents Day Promo','Progressive','Progressive Corporate Support','Purple Call Campaign','Sales Team Landing Page 1','Sales Team Landing Page 2','Sales Xfer (From Support)','Sleep Bundles','Smithsonian','Spring Sale','TV Ads','Teacher_Discount','Teacher Discount','Time Magazine','SheerID Discount')
            then 'Sales Inbound'
        when ${skill_name} in ('Customer Service General','Customer Service Spanish','Order Follow Up','Purple Outlet Store','Retail Support','Returns','Returns - Mattress','Returns - Other','Support Xfer (From Sales)','Training - Support Xfer','Warranty')
            then 'Support Inbound'
        when ${skill_name} in ('Service Recovery','Sleep Country Canada','Sleep County Canada','Showrooms (Purple owned Retail','Showrooms (Purple owned Retail)')
            then 'SRT'
        when  ${skill_name} = 'Customer Service OB'
            then 'Support OB'
        when  ${skill_name} in ('Fraud (Avail M-F 8a-6p)','Verification (Avail M-F 8a-5p)','Verification')
            then 'Verification'
        when  ${skill_name} = 'Sales Team OB'
            then 'Sales OB'
        when  ${skill_name} = 'PurpleBoysPodcast'
            then 'PurpleBoysPodcast'
        when  ${skill_name} in ('Operations Support','Ops Service Recovery','Purple Delivery','Shipping (Manna)','Shipping (XPO Logistics)')
            then 'Ops'
        else 'Other/Unknown'
    end
    ;;
  }

 # set: detail {
#    fields: [
#      date,
#      service_level,
#      contacts_within_SLA,
#      contacts_outside_sla,
#      first_contacts,
#      total_contacts,
#      skill_name
#    ]
 # }
}
