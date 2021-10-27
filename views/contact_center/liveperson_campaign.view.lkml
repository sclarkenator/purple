view: liveperson_campaign {
  sql_table_name: liveperson.campaign ;;

  dimension: campaign_id {
    label: "Campaign ID"
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: campaign_name {
    label: "Campaign Name"
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: campaign_type {
    label: "Campaign Type"
    description: "Designates conversations as Proactive or Passive."
    type: string
    sql: case when campaign_name ilike '%proactive%' then 'Proactive' else 'Passive' end ;;
  }
}
