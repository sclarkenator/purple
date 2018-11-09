view: purcahse_and_transfer_ids {

  derived_table: {
    sql: -- unioning purchase and transfer orders
      SELECT purchase_order_id as id
      FROM  production.purchase_order
      UNION
      SELECT transfer_order_id as id
      FROM production.transfer_order
      ;;
  }


  dimension: id {
    label: "PO/TO id"
    description: "Unioning Purchase and Transfer Order IDs"
    type:  string
    primary_key: yes
    hidden: yes
    sql:${TABLE}.id ;;
  }


}
