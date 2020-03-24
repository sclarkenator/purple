view: cc_call_service_level_csl {
  derived_table: {
    sql: select sla_date date, service_level, contacts_within_SLA, contacts_outside_sla,  contacts_within_SLA+contacts_outside_sla as first_contacts, total_contacts, skill_name
      from customer_care.sla_summary slas
       left join customer_care.skill sk on slas.skill_id = sk.skill_id
       ;;
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

  dimension: service_level {
    description: "Contacts within SLA / total first contacts"
    label: "Service Level (dimension version)"
    type: number
    sql: ${TABLE}.SERVICE_LEVEL / 100 ;;
  }

  measure: contacts_within_SLA {
    description: "Number of first contacts responded to within 30 seconds"
    type: sum
    sql: ${TABLE}."contacts_within_SLA" ;;
  }

  measure: contacts_outside_sla {
    description: "Number of first contacts not responded to after 30 seconds"
    type: sum
    sql: ${TABLE}."contacts_outside_sla" ;;
  }

  measure: first_contacts {
    description: "Number of first contacts after 30 seconds"
    type: sum
    sql: ${TABLE}."FIRST_CONTACTS" ;;
  }

  measure: service_lvl {
    description: "Percent of first contacts responded to within SLA"
    label: "Service Level"
    type: average
    sql: ${contacts_within_SLA} / ${first_contacts} ;;
  }

  measure: total_contacts {
    description: "Total number of contacts"
    type: sum
    sql: ${TABLE}.total_contacts ;;
  }

  dimension: skill_name {
    type: string
    sql: ${TABLE}."SKILL_NAME" ;;
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
