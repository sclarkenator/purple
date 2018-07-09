view: daily_summary {
  derived_table: {
    sql: select to_Date(sol.created) date
            ,'GROSS' as type
            ,sum(sol.gross_Amt) AMOUNT
        from sales_order_line sol join sales_order so on so.order_id = sol.order_id
        where channel_id = 1
        and to_date(sol.created) > '2018-07-07'
        group by 1,2
        union
        select to_Date(r.created) date
            ,'RETURN' as type
            ,-sum(rl.gross_Amt) AMOUNT
        from return_order_line rl join return_order r on rl.return_order_id = r.return_order_id
        where r.channel_id = 1
        and to_date(r.created) > '2018-07-07'
        and r.status <> 'CANCELLED'
        group by 1,2
        union
        select to_Date(c.cancelled) date
            ,'CANCELLATION' as type
            ,-sum(c.GROSS_Amt) AMOUNT
        from cancelled_order c
        where c.channel_id = 1
        and to_date(c.cancelled) > '2018-07-07'
        group by 1,2
        union
        select to_Date(rd.created) date
            ,'RETRO_DISCOUNT' as type
            ,-sum(rd.amount) AMOUNT
        from retroactive_discount rd
        where to_date(rd.created) > '2018-07-07'
        group by 1,2
        union
        select to_Date(created) date
            ,'NET' as type
            ,0 AMOUNT
        from sales_order
        where channel_id = 1
        and to_date(created) > '2018-07-07'
        group by 1,2

       ;;
  }

  dimension_group: date {
    type: time
    timeframes: [
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: type {
    type: string
    case: {
      when: {
        sql:${TABLE}.type = 'GROSS' ;;
        label:  "GROSS"
      }
      when: {
        sql:${TABLE}.type = 'RETURN' ;;
        label:  "RTRN"
      }
      when: {
        sql:${TABLE}.type = 'CANCELLATION' ;;
        label:  "CNCLD"
      }
      when: {
        sql:${TABLE}.type = 'RETRO_DISCOUNT' ;;
        label:  "DSCNT"
      }
      when: {
        sql:${TABLE}.type = 'NET' ;;
        label:  "NET"
      }
    }

  }

  dimension: yesterday {
    type: yesno
    sql: ${TABLE}.date = dateadd(d,-1,current_date) ;;
  }

  dimension: amount {}


  measure: total_amount {
    type: sum
    sql: ${TABLE}.amount ;;
  }

}
