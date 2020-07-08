view: customer_table {
  sql_table_name: analytics_stage.ns.CUSTOMERS ;;

  dimension: customer_id {
    label: "Customer ID"
    description: "Hyperlink to customer record in netsuite by internal id. Source:netsuite.customers"
    group_label: " Advanced"
    type: string
    primary_key: yes
    html: <a href = "https://system.na2.netsuite.com/app/common/entity/custjob.nl?id={{value}}" target="_blank"> {{value}} </a> ;;
    sql: ${TABLE}.customer_id::int ;; }

  dimension: companyname {
    label: "Wholesale Customer Name"
    group_label: "Wholesale"
    description: "Company Name from netsuite.
      Source:netsuite.customers"
    type: string
    sql: ${TABLE}.companyname ;; }

  dimension: full_name {
    label: "Customer Name"
    description: "Merging first and last name from netsuite. Source: netsuite.customers"
    type: string
    sql:  initcap(lower(${TABLE}.firstname))||' '||initcap(lower(${TABLE}.lastname));;
    required_access_grants:[can_view_pii] }

  dimension: first_name {
    label: "First Name"
    description: "First name from netsuite. Source: netsuite.customers"
    type: string
    sql:  ${TABLE}.firstname;;
    required_access_grants:[can_view_pii] }

  dimension: last_name {
    label: "Last Name"
    description: "Last name from netsuite. Source: netsuite.customers"
    type: string
    sql:  ${TABLE}.lastname ;;
    required_access_grants:[can_view_pii] }

  dimension: email {
    hidden:  no
    group_label: " Advanced"
    label: "Customer Email"
    description: "Customer Email Address on the Netsuite customer record. Source:netsuite.customers"
    type: string
    sql: CASE WHEN '{{ _user_attributes['can_view_pii'] }}' = 'yes'
              THEN ${TABLE}.email
              ELSE '**********' || '@' || SPLIT_PART(${TABLE}.email, '@', 2)
            END ;;
    }

  dimension: email_join {
    hidden: yes
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: phone {
    hidden:  no
    label: "Customer Phone"
    description: "Looking first at Home Phone, then at Mobile. Source: netsuite.customers"
    type: string
    sql: nvl(${TABLE}.home_phone,${TABLE}.mobile_phone) ;;
    required_access_grants:[can_view_pii] }

  dimension: mf_or_other {
    label: "Is Mattress Firm"
    hidden: yes
    description: "Yes is Mattress Firm.
      Source: netsuite.customers"
    type: yesno
    sql: ${customer_id}=2662 ;;}

  dimension: shipping_hold {
    view_label: "Customer"
    label: " * Is Shipping Hold (Yes/No)"
    description: "Whether the Customer has a shipping hold on their account. Source: netsuite.customers"
    type: string
    sql: ${TABLE}.SHIPPING_HOLD
    ;;
    }

  dimension: hold_reason_id {
    view_label: "Customer"
    group_label: " Advanced"
    label: "Shipping Hold Reason"
    description: "Reason For Shipping Hold. Source:netsuite.customers"
    type: string
    sql: case when ${TABLE}.hold_reason_id = 1 then 'Potential Fraud'
    when ${TABLE}.hold_reason_id = 2 then 'Future Ship Date'
    when ${TABLE}.hold_reason_id = 3 then 'Chargeback'
    when ${TABLE}.hold_reason_id = 4 then 'Return Issue'
    when ${TABLE}.hold_reason_id is not null  then 'Other'
    end

      ;;
  }

  dimension: top_vendors {
    label: "Wholesale Top Customers"
    group_label: "Wholesale"
    hidden: yes
    description: "List of top wholesale customers (Mattress Firm, Sams Club, BB&B, Medline, TA, Access Health, Miracle Cushion, Iowa 90, Ace). Source: netsuite.customers"
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
    label: "Top Wholesale Customers"
    group_label: "Wholesale"
    description: "List of top wholesale customers for forecasting. Source:netsuite.customers"
    case: {
      when: { sql: lower(${TABLE}.companyname) like 'mattress%firm%' ;;  label: "Mattress Firm" }
      when: { sql: lower(${TABLE}.companyname) like 'furniture%row%' ;; label: "Furniture Row" }
      when: { sql: lower(${TABLE}.companyname) like 'macy%' ;; label: "Macy's" }
      when: { sql: lower(${TABLE}.companyname) like 'sleep country%' ;; label: "Sleep Country" }
      when: { sql: lower(${TABLE}.companyname) like 'bed bath%' ;; label: "Bed Bath and Beyond" }
      when: { sql: lower(${TABLE}.companyname) like 'hom%furniture%' ;; label: "HOM Furniture" }
      when: { sql: lower(${TABLE}.companyname) like 'steinhafel%' ;; label: "Steinhafels" }
      when: { sql: lower(${TABLE}.companyname) like 'raymour%' ;; label: "Raymour" }
      when: { sql: lower(${TABLE}.companyname) like 'city%furniture%' ;; label: "City Furniture" }
      when: { sql: lower(${TABLE}.companyname) like 'mathis%' ;; label: "Mathis Brothers" }
      when: { sql: lower(${TABLE}.companyname) like 'big%sandy%' ;; label: "Big Sandy" }
      when: { sql: lower(${TABLE}.companyname) like 'big%sky%' ;; label: "Big Sky" }
      when: { sql: lower(${TABLE}.companyname) like 'sam%' ;; label: "Sam's Club" }

      #when: { sql: lower(${TABLE}.companyname) like 'sam%club%' ;; label: "Sam's Club" }
      when: { sql: lower(${TABLE}.companyname) like 'access%'
        or lower(${TABLE}.companyname) like 'medline%'
        or lower(${TABLE}.companyname) like '%miracle cushion%'
        or lower(${TABLE}.companyname) like '%posture works%'
        or lower(${TABLE}.companyname) like 'my elder%'
        or lower(${TABLE}.companyname) like '%medical%'
        or lower(${TABLE}.companyname) like '%therapy%'
        or lower(${TABLE}.companyname) like '%posture%' ;; label: "Medical Cushions" }
      when: { sql: lower(${TABLE}.companyname) like 'ta operating%'
        or lower(${TABLE}.companyname) like '%iowa 80%'
        or lower(${TABLE}.companyname) like 'das %'
        or lower(${TABLE}.companyname) like '%little america%'
        or lower(${TABLE}.companyname) like '%truck%' ;; label: "Trucking" }
      else: "Other" } }

  dimension: account_manager_id {
    hidden: yes
    sql: ${TABLE}.account_manager_id ;;}

  dimension: sales_manager_id {
    hidden: yes
    sql: ${TABLE}.sales_manager_id ;;}



}
