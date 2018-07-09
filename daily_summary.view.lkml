view: daily_summary {
  derived_table: {
    sql:  select to_Date(sol.created) date
                  ,'GROSS' as type
                  ,sum(sol.gross_Amt) AMOUNT
          from sales_order_line sol join sales_order so on so.order_id = sol.order_id
          where channel_id = 1
          and to_date(sol.created) > '2018-06-15'
          group by 1,2
          union
          select to_Date(r.created) date
                  ,'RETURN' as type
                  ,-sum(rl.gross_Amt) AMOUNT
          from return_order_line rl join return_order r on rl.return_order_id = r.return_order_id
          where r.channel_id = 1
          and to_date(r.created) > '2018-06-15'
          and r.status <> 'CANCELLED'
          group by 1,2
          union
          select to_Date(c.cancelled) date
                  ,'CANCELLATION' as type
                  ,-sum(c.GROSS_Amt) AMOUNT
          from cancelled_order c
          where c.channel_id = 1
          and to_date(c.cancelled) > '2018-06-15'
          group by 1,2
          union
          select to_Date(rd.created) date
                  ,'RETRO_DISCOUNT' as type
                  ,-sum(rd.amount) AMOUNT
          from retroactive_discount rd
          where to_date(rd.created) > '2018-06-15'
          group by 1,2
          union
          select date
                  ,'NET' as type
                  ,sum(case when type = 'GROSS' then nvl(amount,0) else 0 end +
                      case when type = 'RETURN' then nvl(amount,0) else 0 end +
                      case when type = 'CANCELLATION' then nvl(amount,0) else 0 end +
                      case when type = 'RETRO_DISCOUNT' then nvl(amount,0) else 0 end) AMOUNT
          from
          (select to_Date(sol.created) date
                  ,'GROSS' as type
                  ,sum(sol.gross_Amt) AMOUNT
          from sales_order_line sol join sales_order so on so.order_id = sol.order_id
          where channel_id = 1
          and to_date(sol.created) > '2018-06-15'
          group by 1,2
          union
          select to_Date(r.created) date
                  ,'RETURN' as type
                  ,-sum(rl.gross_Amt) AMOUNT
          from return_order_line rl join return_order r on rl.return_order_id = r.return_order_id
          where r.channel_id = 1
          and to_date(r.created) > '2018-06-15'
          and r.status <> 'CANCELLED'
          group by 1,2
          union
          select to_Date(c.cancelled) date
                  ,'CANCELLATION' as type
                  ,-sum(c.GROSS_Amt) AMOUNT
          from cancelled_order c
          where c.channel_id = 1
          and to_date(c.cancelled) > '2018-06-15'
          group by 1,2
          union
          select to_Date(rd.created) date
                  ,'RETRO_DISCOUNT' as type
                  ,-sum(rd.amount) AMOUNT
          from retroactive_discount rd
          where to_date(rd.created) > '2018-06-15'
          group by 1,2)
          group by 1

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
        label:  "RETURN"
      }
      when: {
        sql:${TABLE}.type = 'CANCELLATION' ;;
        label:  "CANCELLATION"
      }
      when: {
        sql:${TABLE}.type = 'RETRO_DISCOUNT' ;;
        label:  "RETRO_DISCOUNT"
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

  measure: amount {
    type: sum
    sql: ${TABLE}.amount ;;
  }
}
