
  view: v_agent_state {
    sql_table_name: CUSTOMER_CARE.v_agent_state ;;

    dimension: reported {
      type: date
      sql: ${TABLE}."reported" ;;
    }

    dimension: agent_id {
      type: string
      sql: ${TABLE}."agent_id" ;;
    }

    dimension: total {
      type: number
      value_format_name: "usd"
      sql: ${TABLE}."total" ;;
    }

    dimension: assigned_project {
      type: number
      value_format_name: decimal_2
      sql: ${TABLE}."assigned_project" ;;
    }
    dimension: available {
      type: number
      value_format_name: decimal_2
      sql: ${TABLE}."available" ;;
    }
    dimension: break{
      type: number
      value_format_name: decimal_2
      sql: ${TABLE}."break" ;;
    }
    dimension: callback_pending{
      type: number
      value_format_name: decimal_2
      sql: ${TABLE}."callback_pending" ;;
    }
    dimension: consult_pending {
      type: number
      value_format_name: decimal_2
      sql: ${TABLE}."consult_pending" ;;
    }
    dimension: follow_up {
      type: number
      value_format_name: decimal_2
      sql: ${TABLE}."follow_up" ;;
    }
    dimension: handle {
      type: number
      value_format_name: decimal_2
      sql: ${TABLE}."handle" ;;
    }
    dimension: held_party_abandoned {
      type: number
      value_format_name: decimal_2
      sql: ${TABLE}."held_party_abandoned" ;;
    }
    dimension: inbound_pending {
      type: number
      value_format_name: decimal_2
      sql: ${TABLE}."inbound_pending" ;;
    }


    dimension: lunch {
      type: number
      value_format_name: decimal_2
      sql: ${TABLE}."lunch" ;;
    }
    dimension: meeting {
      type: number
      value_format_name: decimal_2
      sql: ${TABLE}."meeting" ;;
    }
    dimension: outbound_pending {
      type: number
      value_format_name: decimal_2
      sql: ${TABLE}."outbound_pending" ;;
    }
    dimension: personal {
      type: number
      value_format_name: decimal_2
      sql: ${TABLE}."personal" ;;
    }
    dimension: promise_pending {
      type: number
      value_format_name: decimal_2
      sql: ${TABLE}."promise_pending" ;;
    }
    dimension: refused {
      type: number
      value_format_name: decimal_2
      sql: ${TABLE}."refused" ;;
    }
    dimension: showroom {
      type: number
      value_format_name: decimal_2
      sql: ${TABLE}."showroom" ;;
    }
    dimension: training {
      type: number
      value_format_name: decimal_2
      sql: ${TABLE}."training" ;;
    }
    dimension: transfer_pending {
      type: number
      value_format_name: decimal_2
      sql: ${TABLE}."transfer_pending" ;;
    }
    dimension: unavailable {
      type: number
      value_format_name: decimal_2
      sql: ${TABLE}."unavailable" ;;
    }
    dimension: wrap_up {
      type: number
      value_format_name: decimal_2
      sql: ${TABLE}."wrap_up" ;;
    }

    dimension: zendesk_chat {
      type: number
      value_format_name: decimal_2
      sql: ${TABLE}."zendesk_chat" ;;
    }
    dimension: occupancy {
      type: number
      value_format_name: decimal_2
      sql: ${TABLE}."occupancy" ;;
    }
    dimension: true_occupancy {
      type: number
      value_format_name: decimal_2
      sql: ${TABLE}."true_occupancy" ;;
    }
    dimension: working_rate {
      type: number
      value_format_name: decimal_2
      sql: ${TABLE}."working_rate" ;;
    }





    measure: count {
      type: count
      drill_fields: [agent_id]
    }
  }