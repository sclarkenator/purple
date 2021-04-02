view: order_flag {

  derived_table: {
    sql:
    SELECT ORDER_ID
      ,case when MATTRESS_FLG > 0 then 1 else 0 end mattress_flg
      ,case when HYBRID_MATTRESS_FLG > 0 then 1 else 0 end hybrid_mattress_flg
      ,case when CUSHION_FLG > 0 then 1 else 0 end cushion_flg
      ,case when CUSHION_FLG_sansback > 0 then 1 else 0 end CUSHION_flg_sansback
      ,case when SHEETS_FLG > 0 then 1 else 0 end sheets_flg
      ,case when PROTECTOR_FLG > 0 then 1 else 0 end protector_flg
      ,case when BASE_FLG > 0 then 1 else 0 end base_flg
      ,case when POWERBASE_FLG > 0 then 1 else 0 end powerbase_flg
      ,case when REVERIE_POWERBASE_FLG > 0 then 1 else 0 end reverie_powerbase_flg
      ,case when ASCENT_POWERBASE_FLG > 0 then 1 else 0 end ascent_powerbase_flg
      ,case when PLATFORM_FLG > 0 then 1 else 0 end platform_flg
      ,case when sumo > 0 then 1 else 0 end sumo_flg
      ,case when FOUNDATION_FLG > 0 then 1 else 0 end foundation_flg
      ,case when PILLOW_FLG > 0 then 1 else 0 end pillow_flg
      ,case when BLANKET_FLG > 0 then 1 else 0 end blanket_flg
      ,CASE WHEN MATTRESS_ORDERED > 1 THEN 1 ELSE 0 END MM_FLG
      ,case when PILLOW_ORDERED > 1 then 1 else 0 end mp_flg
      ,case when split_king > 0 then 1 else 0 end sk_flg
      ,case when harmony > 0 then 1 else 0 end harmony_pillow_flg
      ,case when plush > 0 then 1 else 0 end plush_pillow_flg
      ,case when purple_pillow > 0 then 1 else 0 end purple_pillow_flg
      ,case when gravity_mask > 0 then 1 else 0 end gravity_mask_flg
      ,case when gravity_blanket > 0 then 1 else 0 end gravity_blanket_flg
      ,case when EYE_MASK_FLG > 0 then 1 else 0 end eye_mask_flg
      ,case when PET_BED_fLG > 0 then 1 else 0 end pet_bed_flg
      ,case when duvet > 0 then 1 else 0 end duvet_flg
      ,case when (ff_bundle_pt1 + ff_bundle_pt2 + ff_bundle_pt3 >= 3) OR ff_bundle_pt4 > 0 then 1 else 0 end ff_bundle_flg
      ,case when (pdULTpt1>=2 and pdANYpt2=1) then 1 else 0 end pdULT_flg
      ,case when (pdDELpt1>=2 and pdANYpt2=1) then 1 else 0 end pdDEL_flg
      ,case when (pdESSpt1>=2 and pdANYpt2=1) then 1 else 0 end pdESS_flg
      ,case when (weight2pt1=1 and weight2pt2 >=2) then 1 else 0 end weightedtwo_flg
      , mattress_ordered
      , mattress_sales
      , gross_sales
      ,case when buymsm1 > 0 then 1 else 0 end buymsm
      ,case when med_mask > 0 then 1 else 0 end medical_mask_flg
      ,case when pillow_booster > 0 then 1 else 0 end pillow_booster_flg


      -- adding for ecommerce bundles
     ,case when ( harmony_ORDERED > 1 ) then 1 else 0 end harmonytwobund_flg
     ,case when ( harmony_ORDERED = 1 ) then 1 else 0 end singleharmony_flg
     ,case when ( softstretch_ORDERED > 1 ) then 1 else 0 end softstretchtwobund_flg
     ,case when ( plush_ORDERED > 1 ) then 1 else 0 end plushtwobund_flg
     ,case when ( purplepillow_ORDERED > 1 ) then 1 else 0 end purplepillowtwobund_flg
     ,case when ( boostertwobund >0 ) then 1 else 0 end boostertwobund_flg
     ,case when ( sleepmasktwobund >0 ) then 1 else 0 end sleepmasktwobund_flg
     ,case when ( royalcushtwobund >0 ) then 1 else 0 end royalcushtwobund_flg
     ,case when ( simplycushtwobund >0 ) then 1 else 0 end simplycushtwobund_flg
     ,case when ( portcushtwobund >0 ) then 1 else 0 end portcushtwobund_flg
     ,case when ( everywherecushtwobund >0 ) then 1 else 0 end everywherecushtwobund_flg
     ,case when ( ultimate_cushion >0 ) then 1 else 0 end ultimate_cushion_flg
     ,case when ( double_cushion >0 ) then 1 else 0 end double_cushion_flg
     ,case when ( back_cushion >0 ) then 1 else 0 end back_cushion_flg
     ,case when ( original_sheets >0 ) then 1 else 0 end original_sheets_flg
     ,case when ( softstretch_sheets >0 ) then 1 else 0 end softstretch_sheets_flg
     ,case when ( royal_cushion >0 ) then 1 else 0 end royal_cushion_flg
     ,case when ( simply_cushion >0 ) then 1 else 0 end simply_cushion_flg
     ,case when ( portable_cushion >0 ) then 1 else 0 end portable_cushion_flg
     ,case when ( everywhere_cushion >0 ) then 1 else 0 end everywhere_cushion_flg
     ,case when ( lite_cushion >0 ) then 1 else 0 end lite_cushion_flg
-- bundles
     ,case when ( harmony_ORDERED > 1 and original_sheets > 0 and protector_flg >0) then 1 else 0 end bundle1_flg
     ,case when ( double_cushion >0 and simply_cushion >0) then 1 else 0 end bundle2_flg
     ,case when ( double_cushion > 0 and purple_pillow_flg >0) then 1 else 0 end bundle3_flg
     ,case when ( duvet > 0 and plush_pillow_flg >0) then 1 else 0 end bundle4_flg
     ,case when ( gravity_blanket > 0 and sleepmasktwobund >0) then 1 else 0 end bundle5_flg
     ,case when ( everywhere_cushion_flg > 0 and simply_cushion >0) then 1 else 0 end bundle6_flg
     ,case when ( plush_ORDERED > 1) then 1 else 0 end bundle7_flg
     ,case when ( royal_cushion_flg > 0 and purple_pillow_flg >0) then 1 else 0 end bundle8_flg
     ,case when ( duvet > 0 and sleepmasktwobund >0) then 1 else 0 end bundle9_flg
     ,case when ( simply_cushion > 0 and back_cushion_flg >0) then 1 else 0 end bundle10_flg
     ,case when ( harmony_ORDERED > 1 and sleepmasktwobund >0) then 1 else 0 end bundle11_flg
     ,case when ( purplepillow_ORDERED > 1 and softstretch_sheets >0) then 1 else 0 end bundle12_flg
     ,case when ( purplepillow_ORDERED > 1) then 1 else 0 end bundle13_flg
     ,case when ( foundation_flg > 0 and protector_flg > 0 and softstretch_sheets > 0 and harmony_ORDERED >1) then 1 else 0 end bundle14_flg
     ,case when ( harmony_ORDERED > 1 and softstretch_sheets > 0 and protector_flg >0) then 1 else 0 end bundle15_flg

      --big 5 og sheets bundles
     ,case when (harmony_ORDERED = 1 and original_sheets > 0 and PROTECTOR_FLG > 0) then 1 else 0 end big5_singleharmony_ogsheets_flg
      --bundle 1 is the 2 harmonies, og sheets, protector bundle
     ,case when (purplepillow_ORDERED > 1 and original_sheets > 0 and PROTECTOR_FLG > 0) then 1 else 0 end  big5_twopurppillow_ogsheets_flg
     ,case when (plush_ORDERED > 1 and original_sheets > 0 and PROTECTOR_FLG > 0) then 1 else 0 end  big5_twoplush_ogsheets_flg
     --big 5 og sheets with base bundles
     ,case when (big5_singleharmony_ogsheets_flg > 0 and BASE_FLG > 0) then 1 else 0 end big5_singleharmony_ogsheets_barb_flg
     ,case when (bundle1_flg >0 and BASE_FLG > 0) then 1 else 0 end big5_twoharmony_ogsheets_barb_flg
     ,case when (big5_twopurppillow_ogsheets_flg >0 and BASE_FLG > 0) then 1 else 0 end big5_twopurppillow_ogsheets_barb_flg
     ,case when (big5_twoplush_ogsheets_flg >0 and BASE_FLG > 0) then 1 else 0 end big5_twoplush_ogsheets_barb_flg

     --big 5 SS sheets bundles
     ,case when (harmony_ORDERED = 1 and softstretch_sheets > 0 and PROTECTOR_FLG > 0) then 1 else 0 end big5_singleharmony_sssheets_flg
     --bundle 15 is the 2 harmonies, SS sheets, protector bundle
     ,case when (purplepillow_ORDERED > 1 and softstretch_sheets > 0 and PROTECTOR_FLG > 0) then 1 else 0 end  big5_twopurppillow_sssheets_flg
     ,case when (plush_ORDERED > 1 and softstretch_sheets > 0 and PROTECTOR_FLG > 0) then 1 else 0 end  big5_twoplush_sssheets_flg
     --big 5 ss sheets with base bundles
     ,case when (big5_singleharmony_sssheets_flg > 0 and BASE_FLG > 0) then 1 else 0 end big5_singleharmony_sssheets_barb_flg
     ,case when (bundle15_flg >0 and BASE_FLG > 0) then 1 else 0 end big5_twoharmony_sssheets_barb_flg
     ,case when (big5_twopurppillow_sssheets_flg >0 and BASE_FLG > 0) then 1 else 0 end big5_twopurppillow_sssheets_barb_flg
     ,case when (big5_twoplush_sssheets_flg >0 and BASE_FLG > 0) then 1 else 0 end big5_twoplush_sssheets_barb_flg

     ,case when ( original_sheets > 0 and lite_cushion >0) then 1 else 0 end bundle16_flg
     ,case when ( original_sheets > 0 and purple_pillow_flg >0) then 1 else 0 end bundle17_flg
     ,case when ( softstretch_sheets > 0 and lite_cushion >0) then 1 else 0 end bundle18_flg
     ,case when ( softstretch_sheets > 0 and purple_pillow_flg >0) then 1 else 0 end bundle19_flg

    --BAR / BARB
     ,case when small_mattress > 0 then 1 else 0 end small_mattress_flg
     ,case when large_mattress > 0 then 1 else 0 end large_mattress_flg
    -- ,case when anytwopillows > 0 then 1 else 0 end anytwopillows_flg
     ,case when anyonepillow > 0 then 1 else 0 end anyonepillow_flg
     ,case when (large_mattress > 0 and mp_flg > 0 and SHEETS_FLG >0 and PROTECTOR_FLG >0 ) then 1 else 0 end bar_large
     ,case when (small_mattress > 0 and anyonepillow > 0 and SHEETS_FLG >0 and PROTECTOR_FLG >0 ) then 1 else 0 end bar_small
     ,case when ((bar_small + bar_large > 0) and BASE_FLG > 0 ) then 1 else 0 end barb_flg

    -- Hybrid Matress Sizes and Purple Mattress
     ,case when hybrid2 > 0 then 1 else 0 end hybrid2_flg
     ,case when hybrid3 > 0 then 1 else 0 end hybrid3_flg
     ,case when hybrid4 > 0 then 1 else 0 end hybrid4_flg
     ,case when purple_mattress >0 then 1 else 0 end purple_mattres_flg

    -- Room Set Completion
     ,case when MATTRESS_FLG + SHEETS_FLG + PROTECTOR_FLG + BASE_FLG + PILLOW_FLG > 0 then MATTRESS_FLG + SHEETS_FLG + PROTECTOR_FLG + BASE_FLG + PILLOW_FLG else 0 end room_set

    -- For flagging an order based on UPT --
     ,case when qty > 0 then qty else 0 end upt_dim

    -- finishing up item flags --
     ,case when light_duvet > 0 then 1 else 0 end light_duvet_flg
     ,case when kidbed > 0 then 1 else 0 end kid_bed_flg
     ,case when purpleplusbed > 0 then 1 else 0 end purple_plus_flg
     ,case when kidpillow > 0 then 1 else 0 end kid_pillow_flg
     ,case when allseasons_duvet > 0 then 1 else 0 end all_seasons_duvet_flg
     ,case when kidsheets > 0 then 1 else 0 end kid_sheets_flg
     ,case when lifeline > 0 then 1 else 0 end lifeline_flg
     ,case when sj_pajamas > 0 then 1 else 0 end sj_pajama_flg
    ,case when sj_pajamas > 1 then 1 else 0 end sj_pajama_two_flg
     ,case when bmsm > 1 then bmsm else 0 end bmsm_flg
    ,case when mini_bed_squishy > 0 then 1 else 0 end mini_bed_squishy_flg

    FROM(
      select sol.order_id
        ,sum(sol.gross_amt) GROSS_SALES
        ,sum(case when (category = 'MATTRESS' and line <> 'COVER') or (description like '%-SPLIT KING%' and line = 'KIT') THEN 1 ELSE 0 END) MATTRESS_FLG
        ,sum(case when line = 'COIL' or (description like '%HYBRID%' and line = 'KIT') THEN 1 ELSE 0 END) HYBRID_MATTRESS_FLG
        ,SUM(CASE WHEN category = 'SEATING' THEN 1 ELSE 0 END) CUSHION_FLG
        ,SUM(CASE WHEN line = 'SHEETS' THEN 1 ELSE 0 END) SHEETS_FLG
        ,SUM(CASE WHEN line = 'PROTECTOR' THEN 1 ELSE 0 END) PROTECTOR_FLG
        ,SUM(CASE WHEN category = 'BASE' THEN 1 ELSE 0 END) BASE_FLG
        ,SUM(CASE WHEN line = 'POWERBASE' THEN 1 ELSE 0 END) POWERBASE_FLG
        ,SUM(CASE WHEN line = 'POWERBASE' and model = 'REVERIE' THEN 1 ELSE 0 END) REVERIE_POWERBASE_FLG
        ,SUM(CASE WHEN line = 'POWERBASE' and model = 'ASCENT POWERBASE' THEN 1 ELSE 0 END) ASCENT_POWERBASE_FLG
        ,SUM(CASE WHEN model = 'METAL' or model = 'CLIP METAL' THEN 1 ELSE 0 END) PLATFORM_FLG
        ,SUM(case when sku_id in ('10-38-12822','10-38-12815','10-38-12846','10-38-12893','10-38-12892') then 1 else 0 end) sumo
        ,SUM(CASE WHEN model = 'FOUNDATION' THEN 1 ELSE 0 END) FOUNDATION_FLG
        ,SUM(CASE WHEN line = 'PILLOW' THEN 1 ELSE 0 END) PILLOW_FLG
        ,SUM(CASE WHEN line = 'BLANKET' THEN 1 ELSE 0 END) BLANKET_FLG
        ,SUM(CASE WHEN line = 'EYE MASK' THEN 1 ELSE 0 END) EYE_MASK_FLG
        ,SUM(CASE WHEN line = 'PET BED' THEN 1 ELSE 0 END) PET_BED_fLG
        ,SUM(CASE WHEN (category = 'MATTRESS' and line <> 'COVER') or (description like '%-SPLIT KING%' and line = 'KIT') THEN ORDERED_QTY ELSE 0 END) MATTRESS_ORDERED
        ,SUM(CASE WHEN (category = 'MATTRESS' and line <> 'COVER') or (description like '%-SPLIT KING%' and line = 'KIT') THEN SOL.GROSS_AMT ELSE 0 END) MATTRESS_SALES
        ,SUM(CASE WHEN (line = 'PILLOW' and line <> 'BOOSTER') THEN ORDERED_QTY ELSE 0 END) PILLOW_ORDERED
        ,sum(case when description like 'POWERBASE-SPLIT KING' then 1 else 0 end) split_king
        ,sum(case when sku_id in ('AC-10-31-12890','AC-10-31-12895','10-31-12890','10-31-12895','10-31-12891','10-31-12900','10-31-12896','10-31-12905') then 1 else 0 end) harmony
        ,sum(case when sku_id in ('AC-10-31-12860','AC-10-31-12857','10-31-12860','10-31-12857','10-31-12862') then 1 else 0 end) plush
        ,sum(case when sku_id in ('AC-10-31-12854','AC-10-31-12855','10-31-12854','10-31-12855','10-31-12863') then 1 else 0 end) purple_pillow
        ,sum(case when sku_id in ('AC-10-21-68268','10-21-68268') then 1 else 0 end) gravity_mask
        ,sum(case when sku_id in ('10-38-13050') then 1 else 0 end) gravity_blanket
        ,sum(case when sku_id in ('AC-10-38-13015','AC-10-38-13010','AC-10-38-13005','AC-10-38-13030','AC-10-38-13025','AC-10-38-13020',
                                  '10-38-13015','10-38-13010','10-38-13005','10-38-13030','10-38-13025','10-38-13020') then 1 else 0 end) duvet
        ,sum(case when (line = 'PROTECTOR' AND discount_amt=50*sol.ORDERED_QTY) THEN 1 ELSE 0 END) ff_bundle_pt1
        ,sum(case when (line = 'SHEETS' AND discount_amt=50*sol.ORDERED_QTY) then 1 else 0 end) ff_bundle_pt2
        ,sum(case when (line = 'PILLOW' AND discount_amt=50*sol.ORDERED_QTY) then 1 else 0 end) ff_bundle_pt3
        ,sum(case when s.memo ilike ('%flashbundle%') AND s.memo ilike ('%2019%') then 1 else 0 end) ff_bundle_pt4
        ,sum(case when (PRODUCT_DESCRIPTION ilike '%harmony%' and sol.created::date between '2020-01-21' and '2020-02-15') THEN sol.ORDERED_QTY ELSE 0 END) pdULTpt1
        ,sum(case when (PRODUCT_DESCRIPTION ilike '%pillow 2.0%' and sol.created::date between '2020-01-21' and '2020-02-15') THEN sol.ORDERED_QTY ELSE 0 END) pdDELpt1
        ,sum(case when (PRODUCT_DESCRIPTION ilike '%plush%' and sol.created::date between '2020-01-21' and '2020-02-15') THEN sol.ORDERED_QTY ELSE 0 END) pdESSpt1
        ,sum(case when (PRODUCT_DESCRIPTION ilike '%duvet%' AND sol.ORDERED_QTY>=1 and sol.created::date between '2020-01-21' and '2020-02-15') THEN 1 ELSE 0 END) pdANYpt2
        ,sum(case when (PRODUCT_DESCRIPTION ilike '%gravity%' AND line = 'BLANKETS' and sol.created::date between '2020-01-21' and '2020-02-15') THEN 1 ELSE 0 END) weight2pt1
        ,sum(case when (PRODUCT_DESCRIPTION ilike '%gravity%' AND line = 'EYE MASK' and sol.created::date between '2020-01-21' and '2020-02-15') THEN sol.ORDERED_QTY ELSE 0 END) weight2pt2
        ,sum(case when (((item.CATEGORY_name = 'BEDDING' and item.line not ilike ('BLANKET')) OR item.category_name = 'PET' OR item.category_name = 'SEATING')
          ) THEN 1 else 0 end) buymsm1
        ,sum(case when sku_id in ('10-47-20000','10-47-20002','10-47-20001') then 1 else 0 end) med_mask
        ,sum(case when sku_id in ('10-31-12863','10-31-13100') then 1 else 0 end) pillow_booster
        ,sum(case when sku_id in ('10-90-10072','10-90-10071','10-90-10073','10-90-10074','10-90-10076','10-90-10075','10-90-10077',
        '10-90-10078','10-90-10080','10-90-10079','10-90-10082','10-90-10083','10-90-10086','10-90-10085','10-90-10084','10-90-10081') then 1 else 0 end) sj_pajamas

        --adding for ecommerce bundles

        -- new item flags
         ,sum(case when (PRODUCT_DESCRIPTION ilike '%ultimate%cushion%') THEN 1 ELSE 0 END) ultimate_cushion
         ,sum(case when (PRODUCT_DESCRIPTION ilike '%double%cushion%') THEN 1 ELSE 0 END) double_cushion
         ,sum(case when (PRODUCT_DESCRIPTION ilike '%back%cushion%') THEN 1 ELSE 0 END) back_cushion
         ,sum(case when (model = 'ORIGINAL SHEETS') THEN 1 ELSE 0 END) original_sheets
         ,sum(case when (model = 'SOFTSTRETCH' ) THEN 1 ELSE 0 END) softstretch_sheets
         ,sum(case when (PRODUCT_DESCRIPTION ilike '%royal%') THEN 1 ELSE 0 END) royal_cushion
         ,sum(case when (PRODUCT_DESCRIPTION ilike '%simply%') THEN 1 ELSE 0 END) simply_cushion
         ,sum(case when (PRODUCT_DESCRIPTION ilike '%portable%') THEN 1 ELSE 0 END) portable_cushion
         ,sum(case when (PRODUCT_DESCRIPTION ilike '%everywhere%cushion%') THEN 1 ELSE 0 END) everywhere_cushion
         ,sum(case when sku_id in ('10-41-12526') THEN 1 ELSE 0 END) lite_cushion
         ,sum(case when (model = 'LIGHT DUVET' ) THEN 1 ELSE 0 END) light_duvet
         ,sum(case when (model = 'KIDS BED' ) THEN 1 ELSE 0 END) kidbed
         ,sum(case when (model = 'PURPLE PLUS' ) THEN 1 ELSE 0 END) purpleplusbed
         ,sum(case when (model = 'KID PILLOW' ) THEN 1 ELSE 0 END) kidpillow
         ,sum(case when (model = 'ALL SEASONS DUVET' ) THEN 1 ELSE 0 END) allseasons_duvet
         ,sum(case when (model = 'KID SHEETS' ) THEN 1 ELSE 0 END) kidsheets
         ,sum(case when model in ('LIFELINE MATTRESS') then 1 else 0 end) lifeline
         ,SUM(CASE WHEN category = 'SEATING' and model not in ('BACK') THEN 1 ELSE 0 END) CUSHION_FLG_sansback
        -- 2's
         ,SUM(CASE WHEN (line = 'PILLOW' and model = 'HARMONY') THEN ORDERED_QTY ELSE 0 END) harmony_ORDERED
         ,SUM(CASE WHEN (line = 'SHEETS' and model = 'SOFTSTRETCH') THEN ORDERED_QTY ELSE 0 END) softstretch_ORDERED
         ,sum(case when (line = 'PILLOW' and model = 'PLUSH') THEN ORDERED_QTY ELSE 0 END) plush_ORDERED
         ,sum(case when (line = 'PILLOW' and model = 'PILLOW 2.0') THEN ORDERED_QTY ELSE 0 END) purplepillow_ORDERED
         ,sum(case when (PRODUCT_DESCRIPTION ilike '%pillow%booster%' and sol.ORDERED_QTY>=2) THEN 1 ELSE 0 END) boostertwobund
         ,sum(case when (PRODUCT_DESCRIPTION ilike '%weighted%eye%' and sol.ORDERED_QTY>=2) THEN 1 ELSE 0 END) sleepmasktwobund
         ,sum(case when (PRODUCT_DESCRIPTION ilike '%royal%' and sol.ORDERED_QTY>=2) THEN 1 ELSE 0 END) royalcushtwobund
         ,sum(case when (PRODUCT_DESCRIPTION ilike '%simply%' and sol.ORDERED_QTY>=2) THEN 1 ELSE 0 END) simplycushtwobund
         ,sum(case when (PRODUCT_DESCRIPTION ilike '%portable%' and sol.ORDERED_QTY>=2) THEN 1 ELSE 0 END) portcushtwobund
         ,sum(case when (PRODUCT_DESCRIPTION ilike '%everywhere%cushion%' and sol.ORDERED_QTY>=2) THEN 1 ELSE 0 END) everywherecushtwobund
         ,sum(case when sku_id in ('10-41-12526') and sol.ORDERED_QTY >=2 THEN 1 ELSE 0 END) litecushtwobund

        -- BAR / BARB
         ,SUM(CASE WHEN category = 'MATTRESS' and item.size in ('Twin','Twin XL') THEN 1 ELSE 0 END) small_mattress
         ,SUM(CASE WHEN category = 'MATTRESS' and item.size in ('Cal King','SPLIT KING','King','Queen','Full') and line <> 'COVER' THEN 1 ELSE 0 END) large_mattress
     --    ,sum(case when (line = 'PILLOW' and sol.ORDERED_QTY>=2) THEN 1 ELSE 0 END) anytwopillows
         ,sum(case when (line = 'PILLOW' and sol.ORDERED_QTY=1) THEN 1 ELSE 0 END) anyonepillow

        -- Hybrid Mattresses and Purple Mattress
         ,SUM(CASE WHEN line = 'COIL' and model ilike '%HYBRID%2%'  THEN 1 ELSE 0 END) hybrid2
         ,SUM(CASE WHEN line = 'COIL' and model ilike '%HYBRID%3%'  THEN 1 ELSE 0 END) hybrid3
         ,SUM(CASE WHEN line = 'COIL' and model ilike '%HYBRID%4%'  THEN 1 ELSE 0 END) hybrid4
         ,sum(case when model in ('THE PURPLE MATTRESS W/ OG COVER','THE PURPLE MATTRESS','ORIGINAL PURPLE MATTRESS') then 1 else 0 end) purple_mattress
        ,sum(case when product_description ilike '%MINI BED SQUISHY%' then 1 else 0 end) mini_bed_squishy

    -- For flagging an order based on UPT --
             ,sum(case when (sol.ORDERED_QTY>0) THEN ORDERED_QTY ELSE 0 END) qty

    -- Buy More Save More --
         ,sum(case when (category not in('MATTRESS','BASE')) then ordered_qty else 0 end) bmsm

      from analytics.sales.sales_order_line sol
      left join analytics.sales.item on item.item_id = sol.item_id
      left join analytics.sales.sales_order s on s.order_id = sol.order_id and s.system = sol.system
      GROUP BY 1) ;;

    }

  dimension: order_id {
    primary_key: yes
    hidden: yes
    type:  number
    sql: ${TABLE}.order_id ;; }

  measure: mattress_orders {
    group_label: "Total Orders with:"
    label: "a Mattress"
    description: "1/0 per order; 1 if there was a mattress in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.mattress_flg ;; }

  dimension: gross_sales{
    hidden: yes
    sql: ${TABLE}.gross_sales  ;;
  }

  dimension: mattress_sales {
    hidden: yes
    sql: ${TABLE}.mattress_sales  ;;
  }

  measure: mattress_orders_non_zero_amt {
    hidden:  yes
    description: "1/0 per order; 1 if there was a mattress in the order and gross amt > 0. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql: case when ${mattress_sales}>0 then ${TABLE}.mattress_flg end ;; }

  measure: cushion_orders {
    group_label: "Total Orders with:"
    label: "a Cushion - Any"
    description: "1/0 per order; 1 if there was a cushion in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.cushion_flg ;; }

  measure: cushion_orders_sansback {
    group_label: "Total Orders with:"
    label: "a Cushion - Any except Back"
    description: "1/0 per order; 1 if there was a cushion other than a back cushion in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    hidden: yes
    sql:  ${TABLE}.CUSHION_flg_sansback ;; }

  measure: sheets_orders {
    group_label: "Total Orders with:"
    label: "Sheets - Any"
    description: "1/0 per order; 1 if there were sheets in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.sheets_flg ;; }

  measure: protector_orders {
    group_label: "Total Orders with:"
    label: "a Mattress Protector"
    description: "1/0 per order; 1 if there was a mattress protector in the order. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.protector_flg ;; }

  measure: pillow_orders {
    group_label: "Total Orders with:"
    label: "a Pillow"
    description: "1/0 per order; 1 if there was a pillow in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.pillow_flg ;; }

  measure: harmony_orders {
    group_label: "Total Orders with:"
    label: "a Harmony Pillow"
    hidden: no
    description: "1/0 per order; 1 if there was a Harmony pillow in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.harmony_pillow_flg ;; }

  measure: plush_orders {
    group_label: "Total Orders with:"
    label: "a Plush Pillow"
    hidden: yes
    description: "1/0 per order; 1 if there was a Plush pillow in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.plush_pillow_flg ;; }

  measure: base_orders {
    hidden:  no
    group_label: "Total Orders with:"
    label: "a Base"
    description: "1/0 per order; 1 if there was a base in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.base_flg ;; }

  measure: powerbase_orders {
    group_label: "Total Orders with:"
    label: "a Powerbase"
    description: "1/0 per order; 1 if there was a powerbase in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.powerbase_flg ;; }

  measure: platform_orders {
    group_label: "Total Orders with:"
    label: "a Platform Base"
    description: "1/0 per order; 1 if there was a platform base (Metal/Clip Metal) in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.platform_flg ;; }

  measure: sumo_orders{
    group_label: "Total Orders with:"
    label: "a Sumo Metal Base"
    description: "1/0 per order; 1 if there was a platform base (Metal) in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.sumo_flg ;; }

  measure: foundation_orders {
    hidden: no
    group_label: "Total Orders with:"
    label: "a Foundation"
    description: "1/0 per order; 1 if there was a Foundation in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.foundation_flg ;; }

  measure: blanket_orders {
    hidden:  no
    group_label: "Total Orders with:"
    label: "a Blanket"
    description: "1/0 per order; 1 if there was a blanket in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.blanket_flg ;; }

  measure: mm_orders {
    group_label: "Total Orders with:"
    label: "Multiple Mattresses"
    description: "1/0 per order; 1 if there was more than 1 mattress in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.mm_flg ;; }

  measure: split_king_orders {
    group_label: "Total Orders with:"
    label: "a Split King"
    description: "1/0 per order; 1 if multiple twin XL mattresses purchased in this order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type: sum
    sql: ${TABLE}.sk_flg ;; }

  measure: duvet_orders {
    hidden: yes
    group_label: "Total Orders with:"
    label: "a Duvet"
    description: "1/0 per order; 1 if there was a duvet in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.duvet_flg ;; }

  measure: gravity_blanket_orders {
    hidden: no
    group_label: "Total Orders with:"
    label: "a Gravity Blanket"
    description: "1/0 per order; 1 if there was a gravity blanket in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.gravity_blanket_flg ;; }

  measure: gravity_mask_orders {
    hidden: yes
    group_label: "Total Orders with:"
    label: "a Gravity Mask"
    description: "1/0 per order; 1 if there was a gravity mask in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.gravity_mask_flg ;; }

  measure: kid_bed_orders {
    hidden: no
    group_label: "Total Orders with:"
    label: "a Kid Bed"
    description: "1/0 per order; 1 if there was a kid bed in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.kid_bed_flg ;; }

  measure: kid_pillow_orders{
    hidden: no
    group_label: "Total Orders with:"
    label: "a Kid Pillow"
    description: "1/0 per order; 1 if there was a kid pillow in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.kid_pillow_flg ;; }

  measure: kid_sheets_orders {
    hidden: no
    group_label: "Total Orders with:"
    label: "a Kid Sheet"
    description: "1/0 per order; 1 if there was a kid sheet in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.kid_sheets_flg ;; }

  dimension: mattress_flg {
    group_label: "    * Orders has:"
    label: "a Mattress"
    description: "1/0; 1 if there is a mattress in this order. Source:looker.calculation"
    type:  yesno
    sql: ${TABLE}.mattress_flg = 1 ;; }

  dimension: hybird_mattress_flg {
    group_label: "    * Orders has:"
    label: "a Hybrid Mattress"
    description: "1/0; 1 if there is a hybrid or hybrid premier mattress in this order. Source:looker.calculation"
    type:  yesno
    sql: ${TABLE}.hybrid_mattress_flg = 1 ;; }

  dimension: cushion_flg {
    group_label: "    * Orders has:"
    label: "a Cushion - Any"
    description: "1/0; 1 if there is a cushion in this order. Source:looker.calculation"
    type:  yesno
    sql: ${TABLE}.cushion_flg = 1 ;; }

  dimension: CUSHION_FLaG_sansback {
    group_label: "    * Orders has:"
    label: "a Cushion - Any except Back"
    description: "1/0; 1 if there is a cushion other than a back cushion in this order. Source:looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.CUSHION_flg_sansback = 1 ;; }

  dimension: sheets_flg {
    group_label: "    * Orders has:"
    label: "Sheets - Any"
    description: "1/0; 1 if there are sheets in this order. Source:looker.calculation"
    type:  yesno
    sql: ${TABLE}.sheets_flg = 1 ;; }

  dimension: protector_flg {
    group_label: "    * Orders has:"
    label: "a Mattress Protector"
    description: "1/0; 1 if there is a mattress protector in this order. Source:looker.calculation"
    type:  yesno
    sql: ${TABLE}.protector_flg = 1 ;; }

  dimension: base_flg {
    hidden: no
    group_label: "    * Orders has:"
    label: "a Base"
    description: "1/0; 1 if there is a base in this order. Source:looker.calculation"
    type:  yesno
    sql: ${TABLE}.base_flg = 1 ;; }

  dimension: powerbase_flg {
    group_label: "    * Orders has:"
    label: "an Adjustable Base"
    description: "1/0; 1 if there is a powerbase or acsent in this order. Source:looker.calculation"
    type:  yesno
    sql: ${TABLE}.powerbase_flg = 1 ;; }

  dimension: reverie_powerbase_flg {
    group_label: "    * Orders has:"
    label: "a Reverie Base"
    #hidden: yes
    description: "1/0; 1 if there is a powerbase or acsent in this order. Source:looker.calculation"
    type:  yesno
    sql: ${TABLE}.reverie_powerbase_flg = 1 ;; }

  dimension: ascent_powerbase_flg {
    group_label: "    * Orders has:"
    label: "an Ascent Base"
    #hidden: yes
    description: "1/0; 1 if there is a powerbase or acsent in this order. Source:looker.calculation"
    type:  yesno
    sql: ${TABLE}.ascent_powerbase_flg = 1 ;; }

  dimension: platform_flg {
    group_label: "    * Orders has:"
    label: "a Platform Base"
    description: "1/0; 1 if there is a platform base (Metal/Clip Metal) in this order. Source:looker.calculation"
    type:  yesno
    sql: ${TABLE}.platform_flg = 1 ;; }

  dimension: foundation_flg {
    group_label: "    * Orders has:"
    label: "a Foundation Base"
    description: "1/0; 1 if there is a Foundation Base in this order. Source:looker.calculation"
    type: yesno
    sql: ${TABLE}.foundation_flg = 1 ;; }

  dimension: pillow_flg {
    group_label: "    * Orders has:"
    label: "a Pillow"
    description: "1/0; 1 if there is a pillow in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.pillow_flg = 1 ;; }

  dimension: mp_orders_flg {
    group_label: "    * Orders has:"
    label: "Multiple Pillows"
    description: "1/0; 1 if there is more than 1 pillow in the order. Source: looker.calculation"
    hidden: no
    type:  yesno
    sql: ${TABLE}.mp_flg = 1 ;; }

  dimension: blanket_flg {
    hidden:  yes
    group_label: "    * Orders has:"
    label: "a Blanket"
    description: "1/0; 1 if there is a blanket in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.blanket_flg = 1 ;; }

  dimension: split_flg {
    group_label: "    * Orders has:"
    label: "a Split King"
    description: "1/0; 1 if there is are multiple twin XL mattresses purchased in this order. Source: looker.calculation"
    type: yesno
    sql: ${TABLE}.sk_flg > 0 ;; }

  dimension: mm_orders_flg {
    group_label: "    * Orders has:"
    label: "Multiple Mattresses"
    description: "1/0; 1 if there is more than 1 mattress in the order. Source:looker.calculation"
    type:  yesno
    sql:  ${TABLE}.mm_flg = 1 ;; }

  dimension: mini_bed_squishy_flg {
    group_label: "    * Orders has:"
    label: "a Mini bed squishy"
    description: "1/0; 1 if there is a squishy purchased in the order. Source:looker.calculation"
    type:  yesno
    sql:  ${TABLE}.mini_bed_squishy_flg = 1 ;; }

  dimension: mattress_count {
    group_label: " Advanced"
    description: "Number of mattresses in the order. Source: looker.calculation"
    type: number
    sql: ${TABLE}.mattress_ordered ;;
  }

  dimension: pillow_count {
    group_label: " Advanced"
    hidden: yes
    description: "Number of pillows in the order. Source: looker.calculation"
    type: number
    sql: ${TABLE}.pillow_ordered ;;
  }

  dimension: harmony_flg {
    hidden: yes
    group_label: "    * Orders has:"
    label: "a Harmony Pillow"
    description: "1/0; 1 if there is a Harmony Pillow in this order. Source: looker.calculation"
    type: yesno
    sql: ${TABLE}.harmony_pillow_flg > 0 ;; }

  dimension: plush_flg {
    hidden:  yes
    group_label: "    * Orders has:"
    label: "a Plush Pillow"
    description: "1/0; 1 if there is a Plush Pillow in this order. Source: looker.calculation"
    type: yesno
    sql: ${TABLE}.plush_pillow_flg > 0 ;; }

  dimension: purple_pillow_flg {
    hidden: yes
    group_label: "    * Orders has:"
    label: "a Purple Pillow"
    description: "1/0; 1 if there is a Purple Pillow (Purple 2.0, has only purple grid) in this order. Source: looker.calculation"
    type: yesno
    sql: ${TABLE}.purple_pillow_flg > 0 ;; }

  dimension: gravity_mask_flg {
    hidden: yes
    group_label: "    * Orders has:"
    label: "a Gavity Mask"
    description: "1/0; 1 if there is a Gravity Mask in this order. Source: looker.calculation"
    type: yesno
    sql: ${TABLE}.gravity_mask_flg > 0 ;; }

  dimension: gravity_blanket_flg {
    hidden: no
    group_label: "    * Orders has:"
    label: "a Gravity Blanket"
    description: "1/0; 1 if there is a Gravity Blanket in this order. Source: looker.calculation"
    type: yesno
    sql: ${TABLE}.gravity_blanket_flg > 0 ;; }

  dimension: duvet_flg {
    hidden: yes
    group_label: "    * Orders has:"
    label: "a Duvet"
    description: "1/0; 1 if there is a Duvet in this order. Source: looker.calculation"
    type: yesno
    sql: ${TABLE}.duvet_flg > 0 ;; }

  dimension: eye_mask_flg {
    hidden: yes
    group_label: "    * Orders has:"
    label: "a Eye Mask"
    description: "1/0; 1 if there is a Eye Mask in this order. Source: looker.calculation"
    type: yesno
    sql: ${TABLE}.eye_mask_flg > 0 ;; }

  dimension: pet_bed_flg {
    hidden: no
    group_label: "    * Orders has:"
    label: "a Pet Bed"
    description: "1/0; 1 if there is a Pet Bed in this order. Source: looker.calculation"
    type: yesno
    sql: ${TABLE}.pet_bed_flg >0 ;; }

  dimension: ff_bundle_flg {
    hidden:  yes
    group_label: "    * Orders has:"
    label: "a Fall Flash Bundle"
    description: "1/0; 1 if there is a Fall Flash BUndle in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.ff_bundle_flg = 1 ;; }

  dimension: pdULT_flg {
    hidden:  yes
    group_label: "    * Orders has:"
    description: "yesno; yes if there is a pillow-duvet ultimate bundle in this order (1/21/2020-2/14/2020). Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.pdULT_flg = 1 ;; }

  dimension: pdDEL_flg {
    hidden:  yes
    group_label: "    * Orders has:"
    description: "yesno; yes if there is a pillow-duvet deluxe bundle in this order (1/21/2020-2/14/2020). Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.pdDEL_flg = 1 ;; }

  dimension: pdESS_flg {
    hidden:  yes
    group_label: "    * Orders has:"
    description: "yesno; yes if there is a pillow-duvet essential bundle in this order (1/21/2020-2/14/2020). Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.pdESS_flg = 1 ;; }

  dimension: weightedtwo_flg {
    hidden:  yes
    group_label: "    * Orders has:"
    description: "yesno; yes if there is a discounted gravity blanket and 2 free masks in this order (1/21/2020-2/14/2020). Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.weightedtwo_flg = 1 ;; }

  dimension: buymoresavemore {
    hidden:  yes
    group_label: "    * Orders has:"
    description: "yesno; yes if the order qualifies for the 'Buy More Save More' promotion (1/21/2020-2/14/2020). Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.buymsm = 1 ;; }

  dimension: medical_masks{
    group_label: "    * Orders has:"
    label: "a Face Mask"
    description: "1/0 per order; 1 if there was a Medical Face Mask in the order. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.medical_mask_flg =1 ;; }

  dimension: pillow_booster_flag{
    group_label: "    * Orders has:"
    label: "a Pillow Booster"
    description: "1/0 per order; 1 if there was a Pillow Booster in the order. Source:looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.pillow_booster_flg =1 ;; }

  measure: average_mattress_order_size {
    label: "AMOV ($)"
    view_label: "Sales Order"
    description: "Average total mattress order amount, excluding tax. Source:looker.calculation"
    type: average
    sql_distinct_key: ${sales_order.order_system} ;;
    value_format: "$#,##0"
    sql: case when ${order_flag.mattress_flg} = 1 AND ${sales_order.gross_amt}>0 then ${sales_order.gross_amt} end ;;
  }

  measure: average_accessory_order_size {
    label: "NAMOV ($)"
    view_label: "Sales Order"
    description: "Average total accessory order amount, excluding tax. Source:looker.calculation"
    type: average
    sql_distinct_key: ${sales_order.order_system} ;;
    value_format: "$#,##0"
    sql: case when ${order_flag.mattress_flg} = 0 AND ${sales_order.gross_amt}>0 then ${sales_order.gross_amt} end ;;
  }

#creating AAAV - Jared
  measure: total_attached_accessory_value {
    hidden: yes
    description: "Amount of attached accessories (AMOV orders less the mattress $ amount), excluding tax. Source:looker.calculation"
    type: sum
    value_format: "$#,##0"
    sql: case when ${mattress_sales} > 0 then (${gross_sales}-${mattress_sales}) else 0 end;;
  }

  measure: average_attached_accessory_value {
    hidden: no
    label: "AAAV ($)"
    view_label: "Sales Order"
    description: "Average amount of attached accessories (AMOV orders less the mattress $ amount), excluding tax. Source:looker.calculation"
    type: number
    value_format: "$#,##0"
    sql: coalesce(${total_attached_accessory_value}/nullif(${mattress_orders_non_zero_amt},0),0);;
  }

#  adding for ecommerce categories and same update
  measure: ultimate_cushion_orders {
    group_label: "Total Orders with:"
    label: "a Cushion - Ultimate"
    description: "1/0 per order; 1 if the order contains an Ultimate Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.ultimate_cushion_flg  ;; }

  measure: double_cushion_orders {
    group_label: "Total Orders with:"
    label: "a Cushion - Double"
    description: "1/0 per order; 1 if the order contains a Double Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.double_cushion_flg ;; }

  measure: back_cushion_orders {
    group_label: "Total Orders with:"
    label: "a Cushion - Back"
    description: "1/0 per order; 1 if the order contains a Back Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.back_cushion_flg ;; }

  measure: original_sheets_orders {
    group_label: "Total Orders with:"
    label: "Sheets - Original"
    description: "1/0 per order; 1 if the order contains a set of Original Sheets. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.original_sheets_flg ;; }

  measure: softstretch_sheets_orders {
    group_label: "Total Orders with:"
    label: "Sheets - Softstretch"
    description: "1/0 per order; 1 if the order contains a set of Softstretch Sheets. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.softstretch_sheets_flg ;; }

  measure: royal_cushion_orders {
    group_label: "Total Orders with:"
    label: "a Cushion - Royal"
    description: "1/0 per order; 1 if the order contains a Royal Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.royal_cushion_flg ;; }

  measure: simply_cushion_orders {
    group_label: "Total Orders with:"
    label: "a Cushion - Simply"
    description: "1/0 per order; 1 if the order contains a Simply Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.simply_cushion_flg ;; }

  measure: portable_cushion_orders {
    group_label: "Total Orders with:"
    label: "a Cushion - Portable"
    description: "1/0 per order; 1 if the order contains a Portable Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.portable_cushion_flg ;; }

  measure: everywhere_cushion_orders {
    group_label: "Total Orders with:"
    label: "a Cushion - Everywhere"
    description: "1/0 per order; 1 if the order contains an Everywhere Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.everywhere_cushion_flg ;; }

  measure: lite_cushion_orders {
    group_label: "Total Orders with:"
    label: "a Cushion - Lite"
    description: "1/0 per order; 1 if the order contains a Lite Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.lite_cushion_flg ;; }

  dimension: ultimate_cushion_flag {
    group_label: "    * Orders has:"
    label: "a Cushion - Ultimate"
    description: "1/0 per order; 1 if the order contains an Ultimate Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.ultimate_cushion_flg =1  ;; }

  dimension: double_cushion_flag {
    group_label: "    * Orders has:"
    label: "a Cushion - Double"
    description: "1/0 per order; 1 if the order contains a Double Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.double_cushion_flg =1 ;; }

  dimension: back_cushion_flag {
    group_label: "    * Orders has:"
    label: "a Cushion - Back"
    description: "1/0 per order; 1 if the order contains a Back Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.back_cushion_flg=1 ;; }

  dimension: original_sheets_flag {
    group_label: "    * Orders has:"
    label: "Sheets - Original"
    description: "1/0 per order; 1 if the order contains a set of Original Sheets. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.original_sheets_flg =1;; }

  dimension: softstretch_sheets_flag {
    group_label: "    * Orders has:"
    label: "Sheets - Softstretch"
    description: "1/0 per order; 1 if the order contains a set of Softstretch Sheets. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.softstretch_sheets_flg=1 ;; }

  dimension: royal_cushion_flag {
    group_label: "    * Orders has:"
    label: "a Cushion - Royal"
    description: "1/0 per order; 1 if the order contains a Royal Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.royal_cushion_flg=1 ;; }

  dimension: simply_cushion_flag {
    group_label: "    * Orders has:"
    label: "a Cushion - Simply"
    description: "1/0 per order; 1 if the order contains a Simply Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.simply_cushion_flg=1 ;; }

  dimension: portable_cushion_flag {
    group_label: "    * Orders has:"
    label: "a Cushion - Portable"
    description: "1/0 per order; 1 if the order contains a Portable Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.portable_cushion_flg=1 ;; }

  dimension: everywhere_cushion_flag {
    group_label: "    * Orders has:"
    label: "a Cushion - Everywhere"
    description: "1/0 per order; 1 if the order contains an Everywhere Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.everywhere_cushion_flg =1 ;; }

  dimension: lite_cushion_flag {
    group_label: "    * Orders has:"
    label: "a Cushion - Lite"
    description: "1/0 per order; 1 if the order contains a Lite Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.lite_cushion_flg =1 ;; }

# Bundle flags and measures
  dimension: bundle1_flag {
    group_label: "eComm Bundle Flags"
    label: " Bundle 1"
    description: "1/0 per order; 1 if the order contains at least (2) Harmony Pillows (1) Purple Sheets (1) Mattress Protector. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle1_flg=1 ;; }

  dimension: bundle2_flag {
    group_label: "eComm Bundle Flags"
    label: " Bundle 2"
    description: "1/0 per order; 1 if the order contains at least (1) Double Cushion (1) Simply Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle2_flg =1;; }

  dimension: bundle3_flag {
    group_label: "eComm Bundle Flags"
    label: " Bundle 3"
    description: "1/0 per order; 1 if the order contains at least (1) Double Cushion (1) Purple Pillow. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle3_flg=1 ;; }

  dimension: bundle4_flag {
    group_label: "eComm Bundle Flags"
    label: " Bundle 4"
    description: "1/0 per order; 1 if the order contains at least (1) Duvet (1) Plush Pillow. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle4_flg=1 ;; }

  dimension: bundle5_flag {
    group_label: "eComm Bundle Flags"
    label: " Bundle 5"
    description: "1/0 per order; 1 if the order contains at least (1) Weighted Blanket (2) Sleep Masks. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle5_flg=1 ;; }

  dimension: bundle6_flag {
    group_label: "eComm Bundle Flags"
    label: " Bundle 6"
    description: "1/0 per order; 1 if the order contains at least (1) Everywhere Cushion (1) Simply Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle6_flg=1 ;; }

  dimension: bundle7_flag {
    group_label: "eComm Bundle Flags"
    label: " Bundle 7"
    description: "1/0 per order; 1 if the order contains at least (2) Plush Pillows. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle7_flg=1 ;; }

  dimension: bundle8_flag {
    group_label: "eComm Bundle Flags"
    label: " Bundle 8"
    description: "1/0 per order; 1 if the order contains at least (1) Royal Cushion (1) Purple Pillow. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle8_flg=1 ;; }

  dimension: bundle9_flag {
    group_label: "eComm Bundle Flags"
    label: " Bundle 9"
    description: "1/0 per order; 1 if the order contains at least (1) Duvet  (2) Sleep Masks. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle9_flg=1 ;; }

  dimension: bundle10_flag {
    group_label: "eComm Bundle Flags"
    label: "Bundle 10"
    description: "1/0 per order; 1 if the order contains at least (1) Simply Cushion (1) Back Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle10_flg=1 ;; }

  dimension: bundle11_flag {
    group_label: "eComm Bundle Flags"
    label: "Bundle 11"
    description: "1/0 per order; 1 if the order contains at least (2) Harmony Pillows (2) Sleep Masks. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle11_flg=1 ;; }

  dimension: bundle12_flag {
    group_label: "eComm Bundle Flags"
    label: "Bundle 12"
    description: "1/0 per order; 1 if the order contains at least (2) Purple Pillows (1) Softstretch Sheets. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle12_flg=1 ;; }

  dimension: bundle13_flag {
    group_label: "eComm Bundle Flags"
    label: "Bundle 13"
    description: "1/0 per order; 1 if the order contains at least (2) Purple Pillows. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle13_flg=1 ;; }

  dimension: bundle14_flag {
    group_label: "eComm Bundle Flags"
    label: "Bundle 14"
    description: "1/0 per order; 1 if the order contains at least (1) Foundation (1) Mattress Protector (1) SoftStretch Sheets (2) Harmony Pillows. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle14_flg=1 ;; }

  dimension: bundle15_flag {
    group_label: "eComm Bundle Flags"
    label: "Bundle 15"
    description: "1/0 per order; 1 if the order contains at least (2) Harmony Pillows (1) SoftstretchSheets (1) Mattress Protector. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle15_flg=1 ;; }

  dimension: bundle16_flag {
    group_label: "eComm Bundle Flags"
    label: "Bundle 16"
    description: "1/0 per order; 1 if the order contains at least (1) Purple Sheets (1) Lite Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle16_flg=1 ;; }

  dimension: bundle17_flag {
    group_label: "eComm Bundle Flags"
    label: "Bundle 17"
    description: "1/0 per order; 1 if the order contains at least (1) Purple Sheets (1) Purple Pillow. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle17_flg=1 ;; }

  dimension: bundle18_flag {
    group_label: "eComm Bundle Flags"
    label: "Bundle 18"
    description: "1/0 per order; 1 if the order contains at least (1) SoftStretch Sheets (1) Lite Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle18_flg=1 ;; }

  dimension: bundle19_flag {
    group_label: "eComm Bundle Flags"
    label: "Bundle 19"
    description: "1/0 per order; 1 if the order contains at least (1) SoftStretch Sheets (1) Purple Pillow. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bundle19_flg=1 ;; }

# measures
  measure: bundle1_orders {
    group_label: "eComm Bundle Order Counts"
    label: " Bundle 1"
    description: "Orders that contain at least (2) Harmony Pillows (1) Purple Sheets (1) Mattress Protector. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle1_flg ;; }

  measure: bundle2_orders {
    group_label: "eComm Bundle Order Counts"
    label: " Bundle 2"
    description: "Orders that contain at least (1) Double Cushion (1) Simply Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle2_flg ;; }

  measure: bundle3_orders {
    group_label: "eComm Bundle Order Counts"
    label: " Bundle 3"
    description: "Orders that contain at least (1) Double Cushion (1) Purple Pillow. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle3_flg ;; }

  measure: bundle4_orders {
    group_label: "eComm Bundle Order Counts"
    label: " Bundle 4"
    description: "Orders that contain at least (1) Duvet (1) Plush Pillow. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle4_flg ;; }

  measure: bundle5_orders {
    group_label: "eComm Bundle Order Counts"
    label: " Bundle 5"
    description: "Orders that contain at least (1) Weighted Blanket (2) Sleep Masks. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle5_flg ;; }

  measure: bundle6_orders {
    group_label: "eComm Bundle Order Counts"
    label: " Bundle 6"
    description: "Orders that contain at least (1) Everywhere Cushion (1) Simply Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle6_flg ;; }

  measure: bundle7_orders {
    group_label: "eComm Bundle Order Counts"
    label: " Bundle 7"
    description: "Orders that contain at least (2) Plush Pillows. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle7_flg ;; }

  measure: bundle8_orders {
    group_label: "eComm Bundle Order Counts"
    label: " Bundle 8"
    description: "Orders that contain at least (1) Royal Cushion (1) Purple Pillow. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle8_flg ;; }

  measure: bundle9_orders {
    group_label: "eComm Bundle Order Counts"
    label: " Bundle 9"
    description: "Orders that contain at least (1) Duvet  (2) Sleep Masks. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle9_flg ;; }

  measure: bundle10_orders {
    group_label: "eComm Bundle Order Counts"
    label: "Bundle 10"
    description: "Orders that contain at least (1) Simply Cushion (1) Back Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle10_flg ;; }

  measure: bundle11_orders {
    group_label: "eComm Bundle Order Counts"
    label: "Bundle 11"
    description: "Orders that contain at least (2) Harmony Pillows (2) Sleep Masks. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle11_flg ;; }

  measure: bundle12_orders {
    group_label: "eComm Bundle Order Counts"
    label: "Bundle 12"
    description: "Orders that contain at least (2) Purple Pillows (1) Softstretch Sheets. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle12_flg ;; }

  measure: bundle13_orders {
    group_label: "eComm Bundle Order Counts"
    label: "Bundle 13"
    description: "Orders that contain at least (2) Purple Pillows. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle13_flg ;; }

  measure: bundle14_orders {
    group_label: "eComm Bundle Order Counts"
    label: "Bundle 14"
    description: "Orders that contain at least (1) Foundation (1) Mattress Protector (1) SoftStretch Sheets (2) Harmony Pillows. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle14_flg ;; }

  measure: bundle15_orders {
    group_label: "eComm Bundle Order Counts"
    label: "Bundle 15"
    description: "Orders that contain at least (2) Harmony Pillows (1) SoftstretchSheets (1) Mattress Protector. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle15_flg ;; }

  measure: bundle16_orders {
    group_label: "eComm Bundle Order Counts"
    label: "Bundle 16"
    description: "Orders that contain at least (1) Purple Sheets (1) Lite Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle16_flg ;; }

  measure: bundle17_orders {
    group_label: "eComm Bundle Order Counts"
    label: "Bundle 17"
    description: "Orders that contain at least (1) Purple Sheets (1) Purple Pillow. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle17_flg ;; }

  measure: bundle18_orders {
    group_label: "eComm Bundle Order Counts"
    label: "Bundle 18"
    description: "Orders that contain at least (1) SoftStretch Sheets (1) Lite Cushion. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle18_flg ;; }

  measure: bundle19_orders {
    group_label: "eComm Bundle Order Counts"
    label: "Bundle 19"
    description: "Orders that contain at least (1) SoftStretch Sheets (1) Purple Pillow. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bundle19_flg ;; }

  # BAR / BARB
  measure: bar_orders {
    group_label: "Total Orders with:"
    label: "a BAR Bundle"
    description: "1/0 per order; 1 if the order contains a Full or larger size mattress, 2+ pillows, sheets, and a protector;
    or if the order contains a Twin XL/Twin mattress, 1 pillow, sheets, a protector. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.bar_large +  ${TABLE}.bar_small ;; }

  dimension: bar_flag {
    group_label: "    * Orders has:"
    label: "a BAR Bundle"
    description: "1/0 per order; 1 if the order contains a Full or larger size mattress (including split king), 2+ pillows, sheets, and a protector;
    or if the order contains a Twin XL/Twin mattress, 1 pillow, sheets, a protector. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.bar_small + ${TABLE}.bar_large > 0  ;; }


  measure: barb_orders {
    group_label: "Total Orders with:"
    label: "a BARB Bundle"
    description: "1/0 per order; 1 if the order contains a Full or larger size mattress, 2+ pillows, sheets, a protector, and a base;
    or if the order contains a Twin XL/Twin mattress, 1 pillow, sheets, a protector, a base. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  sum
    sql:  ${TABLE}.barb_flg ;; }

  dimension: barb_flag {
    group_label: "    * Orders has:"
    label: "a BARB Bundle"
    description: "1/0 per order; 1 if the order contains a Full or larger size mattress (including split king), 2+ pillows, sheets, protector, and a base;
    or if the order contains a Twin XL/Twin mattress, 1 pillow, sheets, a protector, a base. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.barb_flg = 1  ;; }

  dimension: hybrid2_flag {
    group_label: "    * Orders has:"
    label: "a Hybrid 2"
    description: "1/0; 1 if there is a Hybrid 2 Mattress in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.hybrid2_flg = 1 ;; }

  dimension: hybrid3_flag {
    group_label: "    * Orders has:"
    label: "a Hybrid 3"
    description: "1/0; 1 if there is a Hybrid 3 Mattress in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.hybrid3_flg = 1 ;; }

  dimension: hybrid4_flag {
    group_label: "    * Orders has:"
    label: "a Hybrid 4"
    description: "1/0; 1 if there is a Hybrid 4 Mattress in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.hybrid4_flg = 1 ;; }

  measure: hybird_mattress_orders {
    group_label: "Total Orders with:"
    label: "a Hybrid Mattress"
    description: "Count of Orders with a Hybrid 3 Mattress. Source: looker.calculation"
    type:  sum
    sql: ${TABLE}.hybrid_mattress_flg ;; }

 measure: hybrid2_orders {
    group_label: "Total Orders with:"
    label: "a Hybrid 2"
    description: "Count of Orders with a Hybrid 2 Mattress. Source: looker.calculation"
    type:  sum
    sql: ${TABLE}.hybrid2_flg ;; }

  measure: hybrid3_orders {
    group_label: "Total Orders with:"
    label: "a Hybrid 3"
    description: "Count of Orders with a Hybrid 3 Mattress. Source: looker.calculation"
    type:  sum
    sql: ${TABLE}.hybrid3_flg ;; }

  measure: hybrid4_orders {
    group_label: "Total Orders with:"
    label: "a Hybrid 4"
    description: "Count of Orders with a Hybrid 4 Mattress. Source: looker.calculation"
    type:  sum
    sql: ${TABLE}.hybrid4_flg ;; }

  dimension: purple_mattress_flag {
    group_label: "    * Orders has:"
    label: "a Purple Mattress"
    description: "1/0; 1 if there is a The Purple Mattress in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.purple_mattres_flg = 1 ;; }

  measure: purple_mattress_orders {
    group_label: "Total Orders with:"
    label: "a Purple Mattress"
    description: "Count of Orders with a The Purple Mattress. Source: looker.calculation"
    type:  sum
    sql: ${TABLE}.purple_mattres_flg ;; }

  dimension: room_set_num {
    hidden: yes
    group_label: "    * Orders has:"
    label: "Bedset Completion Number"
    description: "1-5; 1 if there is 1 bedset category in this order, 5 if all bedset categories are in it (Mattress, Sheets, Protector, Base, Pillow). Source: looker.calculation"
    type:  number
    sql: ${TABLE}.room_set ;; }

  dimension: portcushtwobund_flag {
    group_label: "eComm Bundle Flags"
    label: " Bundle 20"
    description: "1/0 per order; 1 if the order contains at least (2) Portable Cushions. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  yesno
    sql:  ${TABLE}.portcushtwobund_flg=1 ;; }

  dimension: upt_filter {
    group_label: "    * Orders has:"
    label: " UPT - Filter "
    description: "Filters to a specific UPT. Source: looker.calculation"
    drill_fields: [sales_order_line.sales_order_details*]
    type:  number
    sql:  ${TABLE}.upt_dim ;; }

  dimension: light_duvet_flag {
    group_label: "    * Orders has:"
    label: "a Light Duvet"
    description: "1/0; 1 if there is a Lightweight Duvet in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.light_duvet_flg = 1 ;; }


  ## new block ##



  dimension: kid_bed_flag {
    group_label: "    * Orders has:"
    label: "a Kid Bed"
    description: "1/0; 1 if there is a Kid Bed in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.kid_bed_flg = 1 ;; }

  dimension: purple_plus_flag {
    group_label: "    * Orders has:"
    label: "a Purple Plus Mattress"
    description: "1/0; 1 if there is a Purple Plus Mattress in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.purple_plus_flg = 1 ;; }

  dimension: kid_pillow_flag {
    group_label: "    * Orders has:"
    label: "a Kid Pillow"
    description: "1/0; 1 if there is a Kid Pillow in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.kid_pillow_flg = 1 ;; }

  dimension: all_seasons_duvet_flag {
    group_label: "    * Orders has:"
    label: "an All Seasons Duvet"
    description: "1/0; 1 if there is an All Seasons Duvet in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.all_seasons_duvet_flg = 1 ;; }

  dimension: kid_sheets_flag {
    group_label: "    * Orders has:"
    label: "a Kid Sheets"
    description: "1/0; 1 if there is a Kid Sheets in this order. Source: looker.calculation"
    type:  yesno
    sql: ${TABLE}.kid_sheets_flg = 1 ;; }

  dimension: lifeline_flag {
    group_label: "    * Orders has:"
    label: "a Lifeline Mattress"
    description: "1/0; 1 if there is a Lifeline Mattress in this order. Source: looker.calculation"
    hidden: yes
    type:  yesno
    sql: ${TABLE}.lifeline_flg = 1 ;; }

  dimension: harmonytwobund_flag {
    group_label: "    * Orders has:"
    label: "multiple Harmony Pillows"
    description: "1/0; 1 if there are at least (2) Harmony Pillows in this order. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.harmonytwobund_flg = 1 ;; }

  dimension: purplepillowtwobund_flg {
    group_label: "    * Orders has:"
    label: "multiple Purple Pillows"
    description: "1/0; 1 if there are at least (2) Purple Pillows in this order. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.purplepillowtwobund_flg = 1 ;; }

  dimension: plushtwobund_flg {
    group_label: "    * Orders has:"
    label: "multiple Purple Pillows"
    description: "1/0; 1 if there are at least (2) Plush Pillows in this order. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.plushtwobund_flg = 1 ;; }

  dimension: softstretchtwobund_flag {
    group_label: "    * Orders has:"
    label: "multiple Softstretch Sheets"
    description: "1/0; 1 if there are at least (2) Softstretch Sheets in this order. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.softstretchtwobund_flg = 1 ;; }

  dimension: singleharmony_flag {
    group_label: "    * Orders has:"
    label: "a Single Harmony Pillow"
    description: "1/0; 1 if there is exactly 1 Harmony Pillow in this order. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.singleharmony_flg = 1 ;; }

  dimension: sj_pajama_flag {
   group_label: "    * Orders has:"
    label: "a Sleepy Jones Pajamas"
    description: "1/0; 1 if there is at least 1 Sleepy Jones Pajamas in this order. Source: looker.calculation"
    type:  yesno
    hidden: no
    sql: ${TABLE}.sj_pajama_flg = 1 ;;
    }

  dimension: sj_pajama_two_flag {
    group_label: "    * Orders has:"
    label: "two Sleepy Jones Pajamas"
    description: "1/0; 1 if there is at least 2 Sleepy Jones Pajamas in this order. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.sj_pajama_two_flg = 1 ;;
  }

# big 5 bundles
  dimension: big5_singleharmony_ogsheets_flag {
    group_label: "eComm Bundle Flags"
    label: "Big 5: 1 Harmony, OG Sheets, a Protector"
    description: "1/0; 1 if the order contains at least (1) Harmony, (1) Purple Sheets, (1) Protector. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.big5_singleharmony_ogsheets_flg = 1 ;; }

  dimension: big5_twopurppillow_ogsheets_flag {
    group_label: "eComm Bundle Flags"
    label: "Big 5: 2 Purple Pillows, OG Sheets, a Protector"
    description: "1/0; 1 if the order contains at least (2) Purple Pillows, (1) Purple Sheets, (1) Protector. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.big5_twopurppillow_ogsheets_flg = 1 ;; }

  dimension: big5_twoplush_ogsheets_flag {
    group_label: "eComm Bundle Flags"
    label: "Big 5: 2 Plush, OG Sheets, a Protector"
    description: "1/0; 1 if the order contains at least (2) Plush Pillows, (1) Purple Sheets, (1) Protector. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.big5_twoplush_ogsheets_flg = 1 ;; }

  dimension: big5_singleharmony_ogsheets_barb_flag {
    group_label: "eComm Bundle Flags"
    label: "Big 5: 1 Harmony, OG Sheets, a Protector, any base"
    description: "1/0; 1 if the order contains at least (1) Harmony, (1) Purple Sheets, (1) Protector, any base. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.big5_singleharmony_ogsheets_barb_flg = 1 ;; }

  dimension: big5_twoharmony_ogsheets_barb_flg {
    group_label: "eComm Bundle Flags"
    label: "Big 5: 2 Harmony, OG Sheets, a Protector, any base"
    description: "1/0; 1 if the order contains at least (2) Harmony, (1) Purple Sheets, (1) Protector, any base. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.big5_twoharmony_ogsheets_barb_flg = 1 ;; }

  dimension: big5_twopurppillow_ogsheets_barb_flag {
    group_label: "eComm Bundle Flags"
    label: "Big 5: 2 Purple Pillows, OG Sheets, a Protector, any base"
    description: "1/0; 1 if the order contains at least (2) Purple Pillows, (1) Purple Sheets, (1) Protector, any base. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.big5_twopurppillow_ogsheets_barb_flg = 1 ;; }

  dimension: big5_twoplush_ogsheets_barb_flag {
    group_label: "eComm Bundle Flags"
    label: "Big 5: 2 Plush, OG Sheets, a Protector, any base"
    description: "1/0; 1 if the order contains at least (2) Plush Pillows, (1) Purple Sheets, (1) Protector, any base. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.big5_twoplush_ogsheets_barb_flg = 1 ;; }

# big 5 bundles w/ softstretch upgrade
  dimension: big5_singleharmony_sssheets_flag {
    group_label: "eComm Bundle Flags"
    label: "Big 5: 1 Harmony, SoftStretch Sheets, a Protector"
    description: "1/0; 1 if the order contains at least (1) Harmony, (1) SoftStretch Sheets, (1) Protector. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.big5_singleharmony_sssheets_flg = 1 ;; }

  dimension: big5_twopurppillow_sssheets_flag {
    group_label: "eComm Bundle Flags"
    label: "Big 5: 2 Purple Pillows, SoftStretch Sheets, a Protector"
    description: "1/0; 1 if the order contains at least (2) Purple Pillows, (1) SoftStretch Sheets, (1) Protector. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.big5_twopurppillow_sssheets_flg = 1 ;; }

  dimension: big5_twoplush_sssheets_flag {
    group_label: "eComm Bundle Flags"
    label: "Big 5: 2 Plush, SoftStretch Sheets, a Protector"
    description: "1/0; 1 if the order contains at least (2) Plush Pillows, (1) SoftStretch Sheets, (1) Protector. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.big5_twoplush_sssheets_flg = 1 ;; }

  dimension: big5_singleharmony_sssheets_barb_flag {
    group_label: "eComm Bundle Flags"
    label: "Big 5: 1 Harmony, SoftStretch Sheets, a Protector, any base"
    description: "1/0; 1 if the order contains at least (1) Harmony, (1) SoftStretch Sheets, (1) Protector, any base. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.big5_singleharmony_sssheets_barb_flg = 1 ;; }

  dimension: big5_twoharmony_sssheets_barb_flag {
    group_label: "eComm Bundle Flags"
    label: "Big 5: 2 Harmony, SoftStretch Sheets, a Protector, any base"
    description: "1/0; 1 if the order contains at least (2) Harmony, (1) SoftStretch Sheets, (1) Protector, any base. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.big5_twoharmony_sssheets_barb_flg = 1 ;; }

  dimension: big5_twopurppillow_sssheets_barb_flag {
    group_label: "eComm Bundle Flags"
    label: "Big 5: 2 Purple Pillows, SoftStretch Sheets, a Protector, any base"
    description: "1/0; 1 if the order contains at least (2) Purple Pillows, (1) SoftStretch Sheets, (1) Protector, any base. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.big5_twopurppillow_sssheets_barb_flg = 1 ;; }

  dimension: big5_twoplush_sssheets_barb_flag {
    group_label: "eComm Bundle Flags"
    label: "Big 5: 2 Plush, SoftStretch Sheets, a Protector, any base"
    description: "1/0; 1 if the order contains at least (2) Plush Pillows, (1) SoftStretch Sheets, (1) Protector, any base. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.big5_twoplush_sssheets_barb_flg = 1 ;; }

  dimension: bmsm_flag {
    group_label: "eComm Bundle Flags"
    label: "Buy More Save More Tier"
    description: "Indicates the Buy More Save More tier of an order (2, 3, 4+ or null). Excludes mattress and base units. Source: looker.calculation"
    type:  string
    hidden: yes
    sql: case when ${TABLE}.bmsm_flg = 2 then 'Tier 2'
              when ${TABLE}.bmsm_flg = 3 then 'Tier 3'
              when ${TABLE}.bmsm_flg > 3 then 'Tier 4+' else null end ;; }

  dimension: purplepillowtwobund_flag {
    group_label: "    * Orders has:"
    label: "multiple Purple Pillows"
    description: "1/0; 1 if there are at least (2) Purple Pillows in this order. Source: looker.calculation"
    type:  yesno
    hidden: yes
    sql: ${TABLE}.purplepillowtwobund_flg = 1 ;; }

}
