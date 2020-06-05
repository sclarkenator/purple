view: promotions_combined {
  derived_table: {sql:
    select
    wd.date,
    listagg(p.id, ', ') as id,
    listagg(p.name, ', ') as name,
    listagg(p.description, '; ') as description,
    listagg(p."TYPE", ', ') as "type"
from analytics.util.warehouse_date wd
inner join analytics.marketing.promotion p on p."START" <= wd.date AND p."END" >= wd.date
group by 1
order by wd.date ;;  }

  dimension: promotion_date {
    hidden: yes
    label: "Promotion Date"
    description: "The Start Date of the Promotion. Source: 2020 Marketing Calendar & Tracker.promotion"
    group_label: " Advanced"
    type: date
    sql: ${TABLE}.date ;; }

  dimension: combined_promotion_ids {
    hidden: yes
    label: "Promotion IDs"
    description: "Promotion IDs Combined by Date. Source: 2020 Marketing Calendar & Tracker.promotion"
    group_label: " Advanced"
    type: string
    sql: ${TABLE}.id ;;  }

  dimension: combined_promotion_names {
    label: "Promotion Names"
    description: "Promotion Names Combined by Date. Source: 2020 Marketing Calendar & Tracker.promotion"
    group_label: " Advanced"
    type: string
    sql: ${TABLE}.name ;;  }

  dimension: combined_promotion_descriptions {
    label: "Promotion Descriptions"
    description: "Promotion Descriptions Combined by Date. Source: 2020 Marketing Calendar & Tracker.promotion"
    group_label: " Advanced"
    type: string
    sql: ${TABLE}.description ;;  }

  dimension: combined_promotion_types {
    label: "Promotion Types"
    description: "Promotion Types Combined by Date. Source: 2020 Marketing Calendar & Tracker.promotion"
    group_label: " Advanced"
    type: string
    sql: ${TABLE}."type" ;;  }
}
