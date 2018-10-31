view: bills {

  derived_table: {
    sql: -- aggregating the bill line up to one per purchase order
      select a.bill_id
          , a.purchase_order
          , a.tranid
          , a.vendor
          , a.status

          , min(a.created) as created
          , max(a.due) as due

          , max(b.bill_row_number) as row_count
          , sum(b.amount) as amount
          , sum(b.item_count) as items

      from production.bill a
      left join production.bill_line b on b.bill_id = a.bill_id
      group by a.bill_id
          , a.purchase_order
          , a.tranid
          , a.vendor
          , a.status
      ;;
  }

  dimension: bill_id {
    primary_key: yes
    hidden: yes
    type:  string
    sql: ${TABLE}.bill_id ;;
  }

  dimension: purchase_order {
    hidden: yes
    type:  string
    sql: ${TABLE}.purchase_order ;;
  }

  dimension: tranid {
    hidden: yes
    type:  string
    sql: ${TABLE}.tranid ;;
  }

  dimension: vendor {
    label: "Vendor"
    #description: "??"
    type:  string
    sql:${TABLE}.vendor ;;
  }

  dimension: status {
    label: "Status"
     type:  string
    sql:${TABLE}.status ;;
  }

  dimension: row_count_dim {
    label: "Unique_Items"
    description: "Count of distinct items aggregated to the max"
    type:  number
    sql:${TABLE}.row_count ;;
  }

  dimension: created {
    label: "Created"
    description: "First created date of any item"
    type:  date
    sql:${TABLE}.created ;;
  }

  dimension: due {
    label: "Due"
    description: "Last due date of any item"
    type:  date
    sql:${TABLE}.due ;;
  }

  measure: row_count {
    label: "Unique_Items"
    description: "Count of distinct items aggregated to the max"
    type:  average   #sum??
    sql:${TABLE}.row_count ;;
  }

  measure: amount {
    label: "Total Amount"
    #description: "Summing the total amount"
    type:  sum
    sql:${TABLE}.amount ;;
  }

  measure: amount_paid {
    label: "Total Amount Paid"
    #description: "Summing the total amount"
    type:  sum
    sql:case when ${TABLE}.status = "Paid In Full" then ${TABLE}.amount else 0 end;;
  }

  measure: items {
    label: "Total Units"
    description: "Sum of all units of that item included in that bill"
    type:  sum
    sql:${TABLE}.items ;;
  }

}
