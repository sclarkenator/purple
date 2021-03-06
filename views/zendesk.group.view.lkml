view: group {
  sql_table_name: (select * from "ANALYTICS_STAGE"."ZENDESK"."GROUP"
                    --filtering out groups that are not meaningful to customer care. Will need to be added back if other groups need them.
                    where lower(name) != 'comms dept'
                      or lower(name) != 'leadership'
                      or lower(name) != 'chat' ) ;;


  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    type: number
    primary_key: yes
    sql: ${TABLE}."ID" ;;
  }

  dimension: name {
    type: string
    label: "Group Name"
    sql: ${TABLE}."NAME" ;;
  }

  dimension_group: created_at {
    type: time
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension_group: updated_at {
    type: time
    sql: ${TABLE}."UPDATED_AT" ;;
  }

  dimension: url {
    type: string
    sql: ${TABLE}."URL" ;;
  }

  dimension: _fivetran_deleted {
    type: string
    sql: ${TABLE}."_FIVETRAN_DELETED" ;;
  }

  dimension_group: _fivetran_synced {
    type: time
    sql: ${TABLE}."_FIVETRAN_SYNCED" ;;
  }

  set: detail {
    fields: [
      id,
      name,
      created_at_time,
      updated_at_time,
      url,
      _fivetran_deleted,
      _fivetran_synced_time
    ]
  }
}
