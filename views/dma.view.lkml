#-------------------------------------------------------------------
# Owner - Russ Macbeth
# Designated Marketing Area - Taking zip codes and grouping them into
#   groups for easier display and tracking.
#-------------------------------------------------------------------

view: dma {
  sql_table_name: analytics.marketing.V_DMA_FIPS_LKP ;;

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.primary_key ;;
  }

  dimension: dma_name {
    view_label: "Geography"
    group_label: "Advanced"
    label: "DMA"
    description: "Designated Marketing Area - derived from zipcode. Source:nielson.v_dma_fips_lkp"
    map_layer_name: dma_layer
    type: string
    sql: ${TABLE}.dma_name ;;
  }

  # Dimensions below are for joining reasons
  dimension: country {
    type: string
    hidden: yes
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: dma {
    type: string
    hidden: yes
    sql: ${TABLE}.dma_ID ;;
  }

  dimension: dma_mfrm {
    type: yesno
    hidden: no
    view_label: "Geography"
    group_label: "Advanced"
    label: "MFRM DMA?"
    description: "Locations of Mattress Firm Stores. Source: looker.calculation"
    sql: ${TABLE}.dma_mfrm ;;
  }
  # Disabling Geo-Holdout as it appears to be time sensitive and not useful anymore.
  # dimension: geo_condition {
  #   hidden: no
  #   label: "Assigned condition"
  #   view_label: "Geography"
  #   description: "Tweaked condition grouping for various treatments in 2019 Q4 geo-holdout test. Source: looker.calculation"
  #   group_label: "Geo-holdout test"
  #   type: string
  #   case: {

  #     when: {
  #       sql: ${dma} in (514,554,642,675,678,743,760,765,839) ;;
  #       label: "1"
  #     }
  #     when: {
  #       sql: ${dma} in (516,557,570,598,616,619,638,773,800,810) ;;
  #       label: "2"
  #     }
  #     when: {
  #       sql: ${dma} in (506,529,551,600,606,609,611,691,752,767) ;;
  #       label: "3"
  #     }
  #     when: {
  #       sql: ${dma} in (503,524,563,627,644,744) ;;
  #       label: "4"
  #     }
  #     when: {
  #       sql: ${dma} in (522,526,533,566,588,647,652,656,698,736) ;;
  #       label: "5"
  #     }
  #     when: {
  #       sql: ${dma} in (509,537,539,550,555,560,571,631,717,881) ;;
  #       label: "6"
  #     }
  #     when: {
  #       sql: ${dma} in (520,547,558,612,624,673,764) ;;
  #       label: "7"
  #     }
  #     when: {
  #       sql: ${dma} in (501,519,530,536,565,686,755,789,804) ;;
  #       label: "8"
  #     }
  #     when: {
  #       sql: ${dma} in (510,528,543,581,634,659,679,754,762,798) ;;
  #       label: "9"
  #     }
  #     when: {
  #       sql: ${dma} in (534,542,575,597,640,650,662,711,746,801) ;;
  #       label: "10"
  #     }
  #     when: {
  #       sql: ${dma} in (512,523,532,574,633,658,702,749,756,862) ;;
  #       label: "11"
  #     }
  #     when: {
  #       sql: ${dma} in (507,567,582,605,613,669,693,725,771,828) ;;
  #       label: "12"
  #     }
  #     when: {
  #       sql: ${dma} in (502,518,548,671,682,709,758,803,813) ;;
  #       label: "13"
  #     }
  #     when: {
  #       sql: ${dma} in (559,583,623,632,649,676,705,759,866) ;;
  #       label: "14"
  #     }
  #     when: {
  #       sql: ${dma} in (505,517,525,531,546,630,651,692,716,802) ;;
  #       label: "15"
  #     }
  #     when: {
  #       sql: ${dma} in (576,592,618,622,637,641,670,710,737,766) ;;
  #       label: "16"
  #     }
  #     when: {
  #       sql: ${dma} in (508,544,564,584,603,628,643,718,724,745) ;;
  #       label: "17"
  #     }
  #     when: {
  #       sql: ${dma} in (541,569,610,657,722,734,740,757,790) ;;
  #       label: "18"
  #     }
  #     when: {
  #       sql: ${dma} in (500,527,540,549,553,561,604,687) ;;
  #       label: "19"
  #     }
  #     when: {
  #       sql: ${dma} in (538,552,596,626,636,661,747,770,807,811,825,855) ;;
  #       label: "OUTLIER"
  #     }

  #     else: "OTHER"}
  # }

  # dimension: extra_tv {
  #   hidden: no
  #   label: "Markets with 2x TV"
  #   view_label: "Geography"
  #   description: "Social prospecting spend group for Q4 geo-holdout test. Source: looker.calculation"
  #   group_label: "Geo-holdout test"
  #   type: string
  #   case: {
  #     when: {
  #       sql: ${dma} in (650,641,535,567,527,839) ;;
  #       label: "2x"
  #     }
  #     else: "Standard"
  #   }
  # }


  # dimension: social_prospecting_amt {
  #   hidden: no
  #   label: "FB/Insta pt spend"
  #   view_label: "Geography"
  #   description: "Social prospecting spend group for Q4 geo-holdout test. Source: looker.calculation"
  #   group_label: "Geo-holdout test"
  #   type: string
  #   case: {
  #     when: {
  #       sql: ${dma} in (504,506,507,512,514,516,523,529,532,534,542,545,551,554,557,567,570,574,575,582,597,598,600,605,606,609,611,613,616,619,633,638,640,642,650,658,662,669,675,678,691,693,702,711,725,743,746,749,751,752,756,760,765,767,771,773,800,801,810,828,839,862) ;;
  #       label: "0%"
  #     }
  #     when: {
  #       sql: ${dma} in (502,503,505,509,511,513,517,518,522,524,525,526,531,533,537,539,546,548,550,555,559,560,563,566,571,583,588,617,623,627,630,631,632,635,639,644,647,648,649,651,652,656,671,676,682,692,698,705,709,716,717,736,744,758,759,802,803,813,821,866,868,881) ;;
  #       label: "50%"
  #     }
  #     when: {
  #       sql: ${dma} in (500,501,508,510,515,519,520,521,527,528,530,535,536,538,540,541,543,544,547,549,552,553,556,558,561,564,565,569,573,576,577,581,584,592,596,602,603,604,610,612,618,622,624,625,626,628,634,636,637,641,643,657,659,661,670,673,679,686,687,710,718,722,724,734,737,740,745,747,753,754,755,757,762,764,766,770,789,790,798,804,807,811,819,820,825,855) ;;
  #       label: "100%"
  #     }
  #     else: "OTHER"
  #   }
  # }

  # dimension: youtube_prospecting_amt {
  #   hidden: no
  #   label: "YouTube pt spend"
  #   view_label: "Geography"
  #   description: "YouTube prospecting spend group for Q4 geo-holdout test. Source: looker.calculation"
  #   group_label: "Geo-holdout test"
  #   type: string
  #   case: {
  #     when: {
  #       sql: ${dma} in (502,503,514,518,520,524,534,542,545,547,548,554,556,558,563,575,576,577,592,597,612,618,622,624,627,635,637,639,640,641,642,644,648,650,662,670,671,673,675,678,682,709,710,711,737,743,744,746,751,758,760,764,765,766,801,803,813,820,821,839,868) ;;
  #       label: "0%"
  #     }
  #     when: {
  #       sql: ${dma} in (501,504,508,511,512,513,515,516,519,522,523,526,530,532,533,536,544,557,559,564,565,566,570,574,583,584,588,598,603,616,617,619,623,628,632,633,638,643,647,649,652,656,658,676,686,698,702,705,718,724,736,745,749,753,755,756,759,773,789,800,804,810,862,866) ;;
  #       label: "50%"
  #     }
  #     when: {
  #       sql: ${dma} in (500,505,506,507,509,510,517,521,525,527,528,529,531,535,537,538,539,540,541,543,546,549,550,551,552,553,555,560,561,567,569,571,573,581,582,596,600,602,604,605,606,609,610,611,613,625,626,630,631,634,636,651,657,659,661,669,679,687,691,692,693,716,717,722,725,734,740,747,752,754,757,762,767,770,771,790,798,802,807,811,819,825,828,855,881) ;;
  #       label: "100%"
  #     }
  #     else: "OTHER"
  #   }
  # }

  # dimension: social_retargeting_amt {
  #   hidden: no
  #   label: "FB/Insta rt spend"
  #   view_label: "Geography"
  #   description: "FB and Instagram retargeting spend group for Q4 geo-holdout test. Source: looker.calculation"
  #   group_label: "Geo-holdout test"
  #   type: string
  #   case: {
  #     when: {
  #       sql: ${dma} in (501,512,513,514,515,519,523,530,532,535,536,541,554,559,565,569,574,583,602,610,617,623,632,633,642,649,657,658,675,676,678,686,702,705,722,734,740,743,749,751,755,756,757,759,760,765,789,790,804,839,862,866) ;;
  #       label: "0%"
  #     }
  #     when: {
  #       sql: ${dma} in (502,504,507,516,518,520,547,548,556,557,558,567,570,582,598,605,612,613,616,619,624,638,639,669,671,673,682,693,709,725,758,764,771,773,800,803,810,813,820,828) ;;
  #       label: "50%"
  #     }
  #     when: {
  #       sql: ${dma} in (500,506,509,510,521,527,528,529,537,538,539,540,543,549,550,551,552,553,555,560,561,571,573,576,577,581,592,596,600,604,606,609,611,618,622,625,626,631,634,636,637,641,659,661,670,679,687,691,710,717,737,747,752,754,762,766,767,770,798,807,811,819,825,855,881) ;;
  #       label: "100%"
  #     }
  #     when: {
  #       sql: ${dma} in (503,505,508,511,517,522,524,525,526,531,533,534,542,544,545,546,563,564,566,575,584,588,597,603,627,628,630,635,640,643,644,647,648,650,651,652,656,662,692,698,711,716,718,724,736,744,745,746,753,801,802,821,868) ;;
  #       label: "150%"
  #     }
  #     else: "OTHER"
  #   }
  # }

  # dimension: youtube_retartgeting_amt {
  #   hidden: no
  #   label: "YouTube rt spend"
  #   view_label: "Geography"
  #   description: "YouTube retargeting spend group for Q4 geo-holdout test. Source: looker.calculation"
  #   group_label: "Geo-holdout test"
  #   type: string
  #   case: {
  #     when: {
  #       sql: ${dma} in (504,508,514,516,535,541,544,554,557,564,569,570,576,577,584,592,598,602,603,610,616,618,619,622,628,637,638,641,642,643,657,670,675,678,710,718,722,724,734,737,740,743,745,751,753,757,760,765,766,773,790,800,810,839) ;;
  #       label: "0%"
  #     }
  #     when: {
  #       sql: ${dma} in (506,510,511,512,521,522,523,526,528,529,532,533,534,542,543,545,551,566,574,575,581,588,597,600,606,609,611,625,633,634,640,647,650,652,656,658,659,662,679,691,698,702,711,736,746,749,752,754,756,762,767,798,801,862) ;;
  #       label: "50%"
  #     }
  #     when: {
  #       sql: ${dma} in (500,501,502,507,515,518,519,520,527,530,536,538,540,547,548,549,552,553,556,558,561,565,567,573,582,596,604,605,612,613,624,626,636,639,661,669,671,673,682,686,687,693,709,725,747,755,758,764,770,771,789,803,804,807,811,813,819,820,825,828,855) ;;
  #       label: "100%"
  #     }
  #     when: {
  #       sql: ${dma} in (503,505,509,513,517,524,525,531,537,539,546,550,555,559,560,563,571,583,617,623,627,630,631,632,635,644,648,649,651,676,692,705,716,717,744,759,802,821,866,868,881) ;;
  #       label: "150%"
  #     }
  #     else: "OTHER"
  #   }
  # }

  # dimension: search_spend_amt {
  #   hidden: no
  #   label: "Brand search spend"
  #   view_label: "Geography"
  #   description: "Branded search spend group for Q4 geo-holdout test. Source: looker.calculation"
  #   group_label: "Geo-holdout test"
  #   type: string
  #   case: {
  #     when: {
  #       sql: ${dma} in (501,502,507,508,509,514,515,518,519,530,536,537,539,544,548,550,554,555,560,564,565,567,571,582,584,603,605,613,628,631,639,642,643,669,671,675,678,682,686,693,709,717,718,724,725,743,745,751,753,755,758,760,765,771,789,803,804,813,828,839,881) ;;
  #       label: "0%"
  #     }
  #     when: {
  #       sql: ${dma} in (503,504,505,510,512,516,517,521,523,524,525,528,531,532,543,546,557,563,570,574,576,577,581,592,598,616,618,619,622,625,627,630,633,634,635,637,638,641,644,648,651,658,659,670,679,692,702,710,716,737,744,749,754,756,762,766,773,798,800,802,810,821,862,868) ;;
  #       label: "50%"
  #     }
  #     when: {
  #       sql: ${dma} in (500,506,511,513,520,522,526,527,529,533,534,535,538,540,541,542,545,547,549,551,552,553,556,558,559,561,566,569,573,575,583,588,596,597,600,602,604,606,609,610,611,612,617,623,624,626,632,636,640,647,649,650,652,656,657,661,662,673,676,687,691,698,705,711,722,734,736,740,746,747,752,757,759,764,767,770,790,801,807,811,819,820,825,855,866) ;;
  #       label: "100%"
  #     }
  #     else: "OTHER"
  #   }
  # }


  dimension: dma_name2 {
    type: string
    hidden: yes
    sql: ${TABLE}.dma_full_name ;;
  }

  dimension: zip {
    type: zipcode
    hidden: yes
    sql: ${TABLE}.zipcode ;;
  }

  dimension: County {
    view_label: "Geography"
    group_label: "Advanced"
    description:"Name of the County the Zipcode is in.  Source: nielson.v_dma_fips_lkp"
    type: string
    hidden: no
    sql: ${TABLE}.county ;;
  }

  dimension: FIPS {
    view_label: "Geography"
    group_label: "Advanced"
    label: "FIPS Code"
    description: "The County FIPS number (combination of a state ID and County ID.  Source:nielson.v_dma_fips_lkp"
    type: string
    map_layer_name: us_counties_fips
    hidden: no
    sql: ${TABLE}.FIPS ;;
  }

  dimension: Class {
    description: "A technical classification of the county see more here https://www2.census.gov/geo/pdfs/reference/ClassCodes.pdf.  Source: nielson.v_dma_fips_lkp"
    type: string
    hidden: yes
    sql: ${TABLE}.Class ;;
  }


  measure: count {
    type: count
    hidden: yes
    drill_fields: [dma_name]
  }

}
