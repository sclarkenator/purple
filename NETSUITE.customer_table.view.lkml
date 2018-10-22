view: customer_table {
  sql_table_name: ANALYTICS_STAGE.netsuite.CUSTOMERS ;;

  dimension: customer_id {
    hidden: yes
    type:number
    sql: ${TABLE}.customer_id ;;
  }

  dimension: companyname {
    label: "Wholesale customer name"
    type: string
    sql: ${TABLE}.companyname ;;
  }

  dimension: full_name {
    label: "Customer name"
    type: string
    sql:  initcap(lower(${TABLE}.firstname))||' '||initcap(lower(${TABLE}.lastname));;
  }

  dimension: email {
    label: "Customer email"
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: phone {
    label: "Customer phone"
    type: string
    sql: nvl(${TABLE}.home_phone,${TABLE}.mobile_phone) ;;
  }

  dimension: mf_or_other {
    label: "Mattress Firm"
    description: "Toggle to select Mattress Firm"
    type: yesno
    sql: ${customer_id}=2662 ;;
  }

  dimension: top_vendors {
    label: "Top customers"
    description: "List of top wholesale customers"
    case: {
      when: {
        label: "Mattress Firm"
        sql: lower(companyname) = 'mattress firm' ;;
      }
      when: {
        label: "Sam's Club"
        sql: lower(companyname) like 'sam%club%' ;;
      }
      when: {
        label: "Bed Bath and Beyond"
        sql: lower(companyname) like 'bed bath %' ;;
      }
      when: {
        label: "Medline Industries"
        sql: lower(companyname) = 'medline industries' ;;
      }
      when: {
        label: "TA Operating"
        sql: lower(companyname) = 'ta operating' ;;
      }
      when: {
        label: "Access Health"
        sql: lower(companyname) = 'access health' ;;
      }
      when: {
        label: "Miracle Cushion"
        sql: lower(companyname) like '%miracle cushion%' ;;
      }
      when: {
        label: "Posture Works"
        sql: lower(companyname) like '%posture works%' ;;
      }
      when: {
        label: "Iowa 80 DC"
        sql: lower(companyname) like '%iowa 80%' ;;
      }
      when: {
        label: "Ace Hardware"
        sql: lower(companyname) like '%ace hardware%' ;;
      }

    else: "Other"
  }
}
}
