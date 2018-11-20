view: discount_code {
  sql_table_name: SALES.DISCOUNT_CODE ;;

  dimension: discount_code_id {
    primary_key: yes
    hidden:  yes
    type: number
    sql: ${TABLE}.DISCOUNT_CODE_ID ;; }

  dimension: created {
    hidden: yes
    type: string
    sql: ${TABLE}.CREATED ;; }

  dimension: discount_reason {
    label: "Discount Reason (buckets)"
    description: "Reason for retroactive discount (Issue, Military, Promo, Change, Other)"
    case: {
      when: { sql:  ${TABLE}.discount_code_id in (5,13) ;; label: "APOLOGY/ISSUE" }
      when: { sql: ${TABLE}.discount_code_id in (2,10) ;; label: "MILITARY DISCOUNT" }
      when: { sql: ${TABLE}.discount_code_id in (1,9,7,15) ;; label: "MARKETING - PROMO" }
      #when: { sql: ${TABLE}.discount_code_id in (36,40) ;; label: "MARKETING - NSI" }
      when: { sql: ${TABLE}.discount_code_id = 23 ;; label: "CHANGE/CANCEL" }
      else: "OTHER" } }

}
