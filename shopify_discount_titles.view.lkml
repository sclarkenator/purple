view: shopify_discount_titles {
  derived_table: {
    sql:
      select n.order_id
          , max(case when title ilike ('%flash%') and title ilike ('%sale%') then 1 else 0 end) as flash
          , max(case when (title ilike ('%bundle%') and title not ilike ('%flash%'))
               or title ilike ('Free Sleep Mask w/ Weighted Blanket Purchase%') then 1 else 0 end) as bundle
          , max(case when title ilike ('%bundle%') and title ilike ('%ultimate%') then 1 else 0 end) as bundle_ultimate
          , max(case when title ilike ('%bundle%') and title ilike ('%deluxe%') then 1 else 0 end) as bundle_deluxe
          , max(case when title ilike ('%bundle%') and title ilike ('%essential%') then 1 else 0 end) as bundle_essential
          , max(case when title ilike ('Free Sleep Mask w/ Weighted Blanket Purchase%') then 1 else 0 end) as bundle_weighted
          , max(case when title ilike ('Free Pillow w/ Mattress%') then 1 else 0 end) as free_pillow_w_mattress
          , max(case when title ilike ('$200 Off Purple Hybrid Premier Mattress%') then 1 else 0 end) as hybrid_mattress_200_off
          , max(case when title ilike ('$150 Off Purple Hybrid Mattress%') then 1 else 0 end) as hybrid_mattress_150_off
          , max(case when title ilike ('$100 Off Purple Hybrid Premier Mattress%') then 1 else 0 end) as hybrid_mattress_100_off
          , max(case when title ilike ('$50 Off The Purple Mattress%') then 1 else 0 end) as purple_mattress_50_off
          , max(case when title in ('$50 off Twin & Twin XL Purple Mattress','$50 Off The Purple Mattress Twin/TwinXL') then 1 else 0 end) as purple_twin_mattress_50_off
          , max(case when title ilike ('Free Purple Pillow w/ mattress%') then 1 else 0 end) as pillow_w_mattress
          , max(case when title ilike ('$50 off Two Plush Pillows w/ Mattress%') then 1 else 0 end) as plush_pillow_50_off_2
          , max(case when title ilike ('$50 off a Harmony Pillow w/ Mattress%') then 1 else 0 end) as harmony_pillow_50_off
          , max(case when title ilike ('$100 off Two Harmony Pillows w/ Mattress%') then 1 else 0 end) as harmony_pillow_100_off_2
          , max(case when title ilike ('$50 off Sheets w/ Mattress%') then 1 else 0 end) as sheets_50_off
          , max(case when title ilike ('$50 off Mattress Protector w/ Mattress%') then 1 else 0 end) as protector_50_off
          , max(case when title ilike ('20% Off Powerbase with Mattress%') then 1 else 0 end) as powerbase_20per_off
          , max(case when title ilike ('%DSC%') and title ilike ('%black%') and title ilike ('%friday%') then 1 else 0 end) as dsc_blackfriday
          , max(case when title ilike ('%DSC%') and title ilike ('%labor%') then 1 else 0 end) as dsc_labor
      from analytics_stage.shopify_us_ft.discount_application a
      left join analytics_stage.shopify_us_ft."ORDER" o on o.id = a.order_id
      left join (
        select ETAIL_ORDER_ID
            , created
            , order_id
            , row_number () over (partition by etail_order_id order by created) row_num
        from analytics.sales.sales_order
        ) n on n.etail_order_id = o.id::string and n.row_num = 1
      group by n.order_id
  ;; }

  dimension: order_id {
    hidden: yes
    primary_key: yes
    type: string
    sql: ${TABLE}.order_id::string ;;}

  dimension: flash {
    hidden: yes
    sql: ${TABLE}.flash ;; }

  dimension: bundle {
    hidden: yes
    sql: ${TABLE}.bundle ;; }

  dimension: bundle_ultimate {
    hidden: yes
    sql: ${TABLE}.bundle_ultimate ;; }

  dimension: bundle_deluxe {
    hidden: yes
    sql: ${TABLE}.bundle_deluxe ;; }

  dimension: bundle_essential {
    hidden: yes
    sql: ${TABLE}.bundle_essential ;; }

  dimension: bundle_weighted {
    hidden: yes
    sql: ${TABLE}.bundle_weighted ;; }

  dimension: free_pillow_w_mattress {
    hidden: yes
    sql: ${TABLE}.free_pillow_w_mattress ;; }

  dimension: hybrid_mattress_200_off {
    hidden: yes
    sql: ${TABLE}.hybrid_mattress_200_off ;; }

  dimension: hybrid_mattress_100_off {
    hidden: yes
    sql: ${TABLE}.hybrid_mattress_100_off ;; }

  dimension: purple_mattress_50_off {
    hidden: yes
    sql: ${TABLE}.purple_mattress_50_off ;; }

  dimension: purple_twin_mattress_50_off {
    hidden: yes
    sql: ${TABLE}.purple_twin_mattress_50_off ;; }

  dimension: pillow_w_mattress {
    hidden: yes
    sql: ${TABLE}.pillow_w_mattress ;; }

  dimension: plush_pillow_50_off_2 {
    hidden: yes
    sql: ${TABLE}.plush_pillow_50_off_2 ;; }

  dimension: harmony_pillow_50_off {
    hidden: yes
    sql: ${TABLE}.harmony_pillow_50_off ;; }

  dimension: harmony_pillow_100_off_2 {
    hidden: yes
    sql: ${TABLE}.harmony_pillow_100_off_2 ;; }

  dimension: sheets_50_off {
    hidden: yes
    sql: ${TABLE}.sheets_50_off ;; }

  dimension: protector_50_off {
    hidden: yes
    sql: ${TABLE}.protector_50_off ;; }

  dimension: powerbase_20per_off {
    hidden: yes
    sql: ${TABLE}.powerbase_20per_off ;; }

  dimension: dsc_blackfriday {
    hidden: yes
    sql: ${TABLE}.dsc_blackfriday ;; }

  dimension: dsc_labor {
    hidden: yes
    sql: ${TABLE}.dsc_labor ;; }

}
