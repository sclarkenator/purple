#-------------------------------------------------------------------
# Owner - Tim Schultz
# Entity from netsuite staging to link id merged netsuite user fields
#-------------------------------------------------------------------

view: entity {
  sql_table_name: analytics_stage.netsuite.entity ;;

  dimension: entity_id {
    primary_key: yes
    label: "Entity ID"
    hidden: yes
    sql: ${TABLE}.entity_id ;;}

  dimension: full_name {
    hidden: yes
    label: "Full Name"
    sql: ${TABLE}.full_name ;;}

  dimension: email {
    hidden: yes
    sql: ${TABLE}.email ;;}
}