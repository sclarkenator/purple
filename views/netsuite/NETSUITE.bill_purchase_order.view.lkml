view: bill_purchase_order {
  derived_table: {
    sql:
      -- OLD BILL QUERY --
        --select a.bill_id,
            --a.purchase_order_id,
            --a.tranid,
            --a.vendor,
            --a.status,
            --min(a.created) as created,
            --max(a.due) as due,
            --max(b.bill_row_number) as row_count,
            --sum(b.amount) as amount,
            --sum(b.item_count) as items
        --from production.bill a
        --left join production.bill_line b on b.bill_id = a.bill_id
        --group by a.bill_id,
            --a.purchase_order_id,
            --a.tranid,
            --a.vendor,
            --a.status
      -- END OF OLD BILL QUERY --
      -- aggregating the bill line up to one per purchase order
      with a as (
        select
            b.bill_id,
            l.account_id,
            b.entity_id,
            o.purchase_order_id,
            b.tranid,
            convert_timezone('America/Denver',b.created) as CREATED,
            b.trandate,
            convert_timezone('America/Denver',b.modified) as MODIFIED,
            b.due,
            b.actual_invoice,
            b.tax_point,
            b.status,
            p.name as accounting_period,
            e.full_name as VENDOR,
            b.vendor_email,
            b.billaddress,
            l.amount,
            l.quantity,
            c.name as CLASS_NAME,
            l.product_line,
            a.name as ACCOUNT_NAME,
            l.department,
            l.location
        from analytics.finance.bill b
            left join analytics.finance.bill_line l on b.bill_id = l.bill_id
            left join analytics_stage.ns.accounts a on l.account_id = a.account_id
            left join analytics_stage.ns.entity e on b.entity_id = e.entity_id
            left join analytics.finance.accounting_period p on b.accounting_period_id = p.accounting_period_id
            left join analytics_stage.ns.classes c on l.class_id = c.class_id
            left join analytics.production.purchase_order o on b.purchase_order_id = o.purchase_order_id
      ), t1 as (
        select
            a.bill_id,
            a.purchase_order_id,
            a.tranid,
            a.vendor,
            a.status,
            min(a.created) as created,
            max(a.due) as due,
            count(*) as row_count,
            sum(a.amount) as amount,
            sum(a.quantity) as items
        from a
        group by
            a.bill_id,
            a.purchase_order_id,
            a.tranid,
            a.vendor,
            a.status
      )
      select * from t1  ;; }

  dimension: bill_id {
    primary_key: yes
    hidden: yes
    type:  string
    sql: ${TABLE}.bill_id ;; }

  dimension: purchase_order_id {
    hidden: yes
    type:  string
    sql: ${TABLE}.purchase_order_id ;; }

  dimension: tranid {
    hidden: yes
    type:  string
    sql: ${TABLE}.tranid ;; }

  dimension: vendor {
    label: "Vendor"
    type:  string
    sql:${TABLE}.vendor ;; }

  dimension: status {
    label: "Status"
     type:  string
    sql:${TABLE}.status ;; }

  dimension: row_count_dim {
    label: "Unique Items"
    description: "Count of distinct items aggregated to the max"
    type:  number
    sql:${TABLE}.row_count ;; }

  dimension: created {
    label: "Created"
    description: "First created date of any item"
    type:  date
    sql:${TABLE}.created ;; }

  dimension: due {
    label: "Due"
    description: "Last due date of any item"
    type:  date
    sql:${TABLE}.due ;; }

  measure: row_count {
    label: "Average Unique Items"
    description: "Count of distinct items aggregated to the max"
    type:  average   #sum??
    sql:${TABLE}.row_count ;; }

  measure: amount {
    label: "Total Amount"
    type:  sum
    sql:${TABLE}.amount ;; }

  measure: amount_paid {
    label: "Total Amount Paid"
    type:  sum
    filters: {
      field: status
      value: "Paid In Full" }
    sql:${TABLE}.amount;; }

  measure: items {
    label: "Total Units"
    description: "Sum of all units of that item included in that bill"
    type:  sum
    sql:${TABLE}.items ;; }

  measure: items_paid {
    label: "Total Items Paid in Full"
    type:  sum
    filters: {
      field: status
      value: "Paid In Full" }
    sql:${TABLE}.items;; }

}
