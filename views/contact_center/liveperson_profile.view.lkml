view: liveperson_profile {
  sql_table_name: "LIVEPERSON"."PROFILE"
    ;;
  drill_fields: [profile_id]

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: assigned_to_lpa {
    label: "Assigned to LPA"
    description: "Profile flagged as LivePerson Administrators"
    type: yesno
    sql: ${TABLE}."ASSIGNED_TO_LPA" ;;
  }

  dimension: deleted {
    label: "Deleted"
    description: "Flags profiles that are marked as deleted."
    type: yesno
    sql: ${TABLE}."DELETED" ;;
  }

  dimension: description {
    label: "Description"
    description: "Profile's description."
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: name {
    label: "Profile Name"
    description: "Name of profile."
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## DATE DIMENSIONS

  dimension_group: insert_ts {
    type: time
    timeframes: [
      raw,
      time,
      date,
      # week,
      month,
      # quarter,
      year
    ]
    hidden: yes
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: modified {
    label: "Modified"
    type: time
    timeframes: [
      raw,
      time,
      date,
      # week,
      month,
      # quarter,
      year
    ]
    sql: CAST(${TABLE}."MODIFIED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: update_ts {
    type: time
    timeframes: [
      raw,
      time,
      date,
      # week,
      month,
      # quarter,
      year
    ]
    hidden: yes
    sql: CAST(${TABLE}."UPDATE_TS" AS TIMESTAMP_NTZ) ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## IDs

  dimension: profile_id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}."PROFILE_ID" ;;
  }

  dimension: role_type_id {
    type: number
    hidden: yes
    sql: ${TABLE}."ROLE_TYPE_ID" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## MEASURES

  measure: count {
    type: count
    hidden: yes
    drill_fields: [profile_id, name]
  }
}
