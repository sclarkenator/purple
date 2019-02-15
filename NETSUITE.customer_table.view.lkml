view: customer_table {
  sql_table_name: ANALYTICS_STAGE.netsuite.CUSTOMERS ;;

  dimension: customer_id {
    label: "Customer ID"
    description: "Hyperlink to customer record in netsuite by internal id"
    type: string
    html: <a href = "https://system.na2.netsuite.com/app/common/entity/custjob.nl?id={{value}}" target="_blank"> {{value}} </a> ;;
    sql: ${TABLE}.customer_id::int ;; }

  dimension: companyname {
    label: "Wholesale Customer Name"
    description: "Company Name from netsuite"
    type: string
    sql: ${TABLE}.companyname ;; }

  dimension: full_name {
    label: "DTC Customer Name"
    description: "Merging first and last name from netsuite"
    type: string
    sql:  initcap(lower(${TABLE}.firstname))||' '||initcap(lower(${TABLE}.lastname));; }

  dimension: email {
    hidden:  yes
    label: "Customer Email"
    type: string
    sql: ${TABLE}.email ;; }

  dimension: phone {
    hidden:  yes
    label: "Customer Phone"
    description: "Looking first at Home Phone, then at Mobile"
    type: string
    sql: nvl(${TABLE}.home_phone,${TABLE}.mobile_phone) ;; }

  dimension: mf_or_other {
    label: "Is Mattress Firm"
    description: "Yes is Mattress Firm"
    type: yesno
    sql: ${customer_id}=2662 ;;}

  dimension: top_vendors {
    label: "Wholesale Top Customers"
    description: "List of top wholesale customers (Mattress Firm, Sams Club, BB&B, Medline, TA, Access Health, Miracle Cushion, Iowa 90, Ace)"
    case: {
      when: { label: "Mattress Firm" sql: lower(companyname) = 'mattress firm' ;; }
      when: { label: "Sam's Club" sql: lower(companyname) like 'sam%club%' ;; }
      when: { label: "Bed Bath and Beyond" sql: lower(companyname) like 'bed bath %' ;; }
      when: { label: "Medline Industries" sql: lower(companyname) = 'medline industries' ;; }
      when: { label: "TA Operating" sql: lower(companyname) = 'ta operating' ;; }
      when: { label: "Access Health" sql: lower(companyname) = 'access health' ;; }
      when: { label: "Miracle Cushion" sql: lower(companyname) like '%miracle cushion%' ;; }
      when: { label: "Posture Works" sql: lower(companyname) like '%posture works%' ;;}
      when: { label: "Iowa 80 DC" sql: lower(companyname) like '%iowa 80%' ;; }
      when: { label: "Ace Hardware" sql: lower(companyname) like '%ace hardware%' ;; }
      else: "Other" } }

  dimension: wholesale_type {
    label: "Wholesale Top Customers 2"
    description: "List of top wholesale customers for forecasting"
    case: {
      when: { sql: lower(${TABLE}.companyname) like 'mattress%firm%' ;;  label: "Mattress Firm" }
      when: { sql: lower(${TABLE}.companyname) like 'furniture%row%' ;; label: "Furniture Row" }
      when: { sql: lower(${TABLE}.companyname) like 'macy%' ;; label: "Macy's" }
      when: { sql: lower(${TABLE}.companyname) like 'sleep country%' ;; label: "Sleep Country" }
      when: { sql: lower(${TABLE}.companyname) like 'bed bath%' ;; label: "Bed Bath and Beyond" }
      when: { sql: lower(${TABLE}.companyname) like 'sam%club%' ;; label: "Sam's Club" }
      when: { sql: lower(${TABLE}.companyname) like 'medline%' ;; label: "Medical Cushions" }
      when: { sql: lower(${TABLE}.companyname) like 'access health%' ;; label: "Medical Cushions" }
      when: { sql: lower(${TABLE}.companyname) like '%miracle cushion%' ;; label: "Medical Cushions" }
      when: { sql: lower(${TABLE}.companyname) like '%posture works%' ;; label: "Medical Cushions" }
      when: { sql: lower(${TABLE}.companyname) like 'my elder%' ;; label: "Medical Cushions" }
      when: { sql: lower(${TABLE}.companyname) like '%medical%' ;; label: "Medical Cushions" }
      when: { sql: lower(${TABLE}.companyname) like '%therapy%' ;; label: "Medical Cushions" }
      when: { sql: lower(${TABLE}.companyname) like '%posture%' ;; label: "Medical Cushions" }
      when: { sql: lower(${TABLE}.companyname) like 'ta operating%' ;; label: "Trucking" }
      when: { sql: lower(${TABLE}.companyname) like '%iowa 80%' ;; label: "Trucking" }
      when: { sql: lower(${TABLE}.companyname) like '%little america%' ;; label: "Trucking" }
      when: { sql: lower(${TABLE}.companyname) like 'das %' ;; label: "Trucking" }
      when: { sql: lower(${TABLE}.companyname) like '%trucka%' ;; label: "Trucking" }
      else: "Other" } }

}
