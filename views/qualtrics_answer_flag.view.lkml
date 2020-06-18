view: qualtrics_answer_flag {
   # Or, you could make this view a derived table, like this:
   derived_table: {
     sql: select
            response_id,
            max(case when answer = 'Very certain' then 1 else 0 end) as Very_certain,
            max(case when answer = 'Moderately certain' then 1 else 0 end) as Moderately_certain,
            max(case when answer = 'Not certain at all' then 1 else 0 end) as Not_certain_at_all,
            max(case when answer = 'Extremely certain' then 1 else 0 end) as Extremely_certain,
            max(case when answer = 'Slightly certain' then 1 else 0 end) as Slightly_certain
        from analytics.MARKETING.QUALTRICS_ANSWER
        where survey_id = 'SV_0N8fnSAtL50XifP'
        group by 1
       ;;
   }

  dimension: response_id {
    hidden: yes
    primary_key: yes
    description: "Source: looker.calculation"
    type: string
    sql: ${TABLE}."RESPONSE_ID" ;;
  }

  dimension: Very_certain { group_label: "Answer Flags" description: "Source: looker.calculation" type: yesno sql: ${TABLE}."VERY_CERTAIN" ;; }
  dimension: Moderately_certain { group_label: "Answer Flags" description: "Source: looker.calculation" type: yesno sql: ${TABLE}."MODERATELY_CERTAIN" ;; }
  dimension: Not_certain_at_all { group_label: "Answer Flags" description: "Source: looker.calculation" type: yesno sql: ${TABLE}."NOT_CERTAIN_AT_ALL" ;; }
  dimension: Extremely_certain { group_label: "Answer Flags" description: "Source: looker.calculation" type: yesno sql: ${TABLE}."EXTREMELY_CERTAIN" ;; }
  dimension: Slightly_certain { group_label: "Answer Flags" description: "Source: looker.calculation" type: yesno sql: ${TABLE}."SLIGHTLY_CERTAIN" ;; }

 }
