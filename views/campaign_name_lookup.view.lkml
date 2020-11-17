view: campaign_name_lookup {

    derived_table: {
      explore_source: daily_adspend {
        column: campaign_id {}
        column: campaign_name {}
        filters: {
          field: daily_adspend.campaign_id
          value: "-0"
        }
      }
    }
    dimension: campaign_id {}
    dimension: campaign_name {}
  }
