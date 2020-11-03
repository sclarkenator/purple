- dashboard: business_user_training
  title: Business User Training
  layout: newspaper
  elements:
  - title: Orders
    name: Orders
    model: main
    explore: sales_order_line
    type: single_value
    fields: [sales_order.total_orders]
    filters:
      sales_order.channel: DTC,Wholesale,Owned Retail
      sales_order.is_exchange_upgrade_warranty: ''
    limit: 500
    query_timezone: America/Denver
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen: {}
    row: 4
    col: 5
    width: 9
    height: 6
  - name: Business User Training Exercises
    type: text
    title_text: Business User Training Exercises
    subtitle_text: ''
    body_text: |-
      There are six types of exercises we will work through during the Business User Training. We will do a guided and practice exercise for each.

      The steps to create these visuals are outlined in the [Business User Training](https://docs.google.com/presentation/d/1-8b2Dx7LnspCbghMzYSP8PE9ce0YnPzLRBYpNLti7Ns/edit#slide=id.p101) slides.
    row: 0
    col: 0
    width: 24
    height: 4
  - name: Measures
    type: text
    title_text: Measures
    row: 4
    col: 0
    width: 5
    height: 6
  - name: Measures and Dimensions
    type: text
    title_text: Measures and Dimensions
    row: 10
    col: 0
    width: 5
    height: 6
  - name: Time Dimensions & Filters
    type: text
    title_text: Time Dimensions & Filters
    row: 16
    col: 0
    width: 5
    height: 6
  - name: Pivots
    type: text
    title_text: Pivots
    row: 22
    col: 0
    width: 5
    height: 6
  - title: Average Order Value
    name: Average Order Value
    model: main
    explore: sales_order_line
    type: single_value
    fields: [sales_order.average_order_size]
    filters:
      sales_order.channel: DTC,Wholesale,Owned Retail
      sales_order.is_exchange_upgrade_warranty: ''
    limit: 500
    query_timezone: America/Denver
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#7363A9"
    single_value_title: Average Order Value
    defaults_version: 1
    listen: {}
    row: 4
    col: 14
    width: 10
    height: 6
  - title: Top 5 Categories by Orders
    name: Top 5 Categories by Orders
    model: main
    explore: sales_order_line
    type: looker_column
    fields: [sales_order.total_orders, item.category_name]
    filters:
      sales_order.channel: DTC,Wholesale,Owned Retail
      sales_order.is_exchange_upgrade_warranty: ''
    sorts: [sales_order.total_orders desc]
    limit: 5
    query_timezone: America/Denver
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: bottom, series: [{axisId: sales_order.total_orders,
            id: sales_order.total_orders, name: Total Unique Orders}], showLabels: false,
        showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen: {}
    row: 10
    col: 5
    width: 9
    height: 6
  - title: Top 10 Products by Gross Sales
    name: Top 10 Products by Gross Sales
    model: main
    explore: sales_order_line
    type: looker_bar
    fields: [item.product_description, sales_order_line.total_gross_Amt]
    filters:
      sales_order.channel: DTC,Wholesale,Owned Retail
      sales_order.is_exchange_upgrade_warranty: ''
    sorts: [sales_order_line.total_gross_Amt desc]
    limit: 10
    query_timezone: America/Denver
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: bottom, series: [{axisId: sales_order.total_orders,
            id: sales_order.total_orders, name: Total Unique Orders}], showLabels: false,
        showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen: {}
    row: 10
    col: 14
    width: 10
    height: 6
  - title: Gross Sales by Day
    name: Gross Sales by Day
    model: main
    explore: sales_order_line
    type: looker_line
    fields: [sales_order_line.total_gross_Amt, sales_order_line.created_date]
    fill_fields: [sales_order_line.created_date]
    filters:
      sales_order.channel: DTC,Wholesale,Owned Retail
      sales_order_line.created_date: 30 days
      sales_order.is_exchange_upgrade_warranty: 'No'
    sorts: [sales_order_line.created_date desc]
    limit: 500
    query_timezone: America/Denver
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: sales_order_line.total_gross_Amt,
            id: sales_order_line.total_gross_Amt, name: Gross Sales ($0.k)}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    x_axis_datetime_label: ''
    reference_lines: [{reference_type: line, line_value: mean, range_start: max, range_end: min,
        margin_top: deviation, margin_value: mean, margin_bottom: deviation, label_position: right,
        color: "#000000"}]
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen: {}
    row: 16
    col: 5
    width: 9
    height: 6
  - title: Mattresses Ordered by Month
    name: Mattresses Ordered by Month
    model: main
    explore: sales_order_line
    type: looker_column
    fields: [sales_order.total_orders, sales_order_line.created_month]
    fill_fields: [sales_order_line.created_month]
    filters:
      sales_order.channel: DTC,Wholesale,Owned Retail
      sales_order_line.created_date: 12 months
      item.category_name: MATTRESS
      sales_order.is_exchange_upgrade_warranty: 'No'
    sorts: [sales_order_line.created_month desc]
    limit: 500
    query_timezone: America/Denver
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: sales_order.total_orders,
            id: sales_order.total_orders, name: Total Unique Orders}], showLabels: false,
        showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    x_axis_datetime_label: "%b %y"
    reference_lines: [{reference_type: line, line_value: mean, range_start: max, range_end: min,
        margin_top: deviation, margin_value: mean, margin_bottom: deviation, label_position: right,
        color: "#000000"}]
    show_dropoff: true
    show_null_points: true
    interpolation: linear
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen: {}
    row: 16
    col: 14
    width: 10
    height: 6
  - title: Orders by Category
    name: Orders by Category
    model: main
    explore: sales_order_line
    type: looker_column
    fields: [sales_order.total_orders, sales_order_line.created_month, item.category_name]
    pivots: [item.category_name]
    fill_fields: [sales_order_line.created_month]
    filters:
      sales_order.channel: DTC,Wholesale,Owned Retail
      sales_order_line.created_date: 12 months
      sales_order.is_exchange_upgrade_warranty: ''
    sorts: [sales_order_line.created_month desc, item.category_name]
    limit: 500
    query_timezone: America/Denver
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: right
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: sales_order.total_orders,
            id: sales_order.total_orders, name: Total Unique Orders}], showLabels: false,
        showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    x_axis_datetime_label: "%b %y"
    show_null_points: true
    interpolation: linear
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen: {}
    row: 22
    col: 14
    width: 10
    height: 6
  - title: Gross Sales by Channel
    name: Gross Sales by Channel
    model: main
    explore: sales_order_line
    type: looker_line
    fields: [sales_order_line.total_gross_Amt_non_rounded, sales_order_line.created_date,
      sales_order.channel2]
    pivots: [sales_order.channel2]
    fill_fields: [sales_order_line.created_date]
    filters:
      sales_order.channel: DTC,Wholesale,Owned Retail
      sales_order_line.created_date: 30 days
      sales_order.is_exchange_upgrade_warranty: 'No'
    sorts: [sales_order_line.created_date desc, sales_order.channel2]
    limit: 500
    query_timezone: America/Denver
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: right
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: DTC - sales_order_line.total_gross_Amt_non_rounded,
            id: DTC - sales_order_line.total_gross_Amt_non_rounded, name: DTC}, {
            axisId: Employee Store - sales_order_line.total_gross_Amt_non_rounded,
            id: Employee Store - sales_order_line.total_gross_Amt_non_rounded, name: Employee
              Store}, {axisId: General - sales_order_line.total_gross_Amt_non_rounded,
            id: General - sales_order_line.total_gross_Amt_non_rounded, name: General},
          {axisId: Owned Retail - sales_order_line.total_gross_Amt_non_rounded, id: Owned
              Retail - sales_order_line.total_gross_Amt_non_rounded, name: Owned Retail},
          {axisId: Wholesale - sales_order_line.total_gross_Amt_non_rounded, id: Wholesale
              - sales_order_line.total_gross_Amt_non_rounded, name: Wholesale}], showLabels: false,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    x_axis_datetime_label: ''
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen: {}
    row: 22
    col: 5
    width: 9
    height: 6
  - title: Percent of Units Returned by Month
    name: Percent of Units Returned by Month
    model: main
    explore: sales_order_line
    type: looker_column
    fields: [sales_order_line.total_units, return_order_line.units_returned, sales_order_line.created_month]
    fill_fields: [sales_order_line.created_month]
    filters:
      sales_order.channel: DTC,Wholesale,Owned Retail
      sales_order_line.created_date: 12 months
      sales_order.is_exchange_upgrade_warranty: ''
    sorts: [sales_order_line.created_month desc]
    limit: 500
    dynamic_fields: [{table_calculation: percent_of_units_returned, label: Percent
          of Units Returned, expression: "${return_order_line.units_returned}/${sales_order_line.total_units}",
        value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: America/Denver
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: right
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: DTC - sales_order_line.total_gross_Amt_non_rounded,
            id: DTC - sales_order_line.total_gross_Amt_non_rounded, name: DTC}, {
            axisId: Employee Store - sales_order_line.total_gross_Amt_non_rounded,
            id: Employee Store - sales_order_line.total_gross_Amt_non_rounded, name: Employee
              Store}, {axisId: General - sales_order_line.total_gross_Amt_non_rounded,
            id: General - sales_order_line.total_gross_Amt_non_rounded, name: General},
          {axisId: Owned Retail - sales_order_line.total_gross_Amt_non_rounded, id: Owned
              Retail - sales_order_line.total_gross_Amt_non_rounded, name: Owned Retail},
          {axisId: Wholesale - sales_order_line.total_gross_Amt_non_rounded, id: Wholesale
              - sales_order_line.total_gross_Amt_non_rounded, name: Wholesale}], showLabels: false,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    x_axis_datetime_label: "%b %y"
    show_dropoff: false
    show_null_points: true
    interpolation: linear
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hidden_fields: [sales_order_line.total_units, return_order_line.units_returned]
    listen: {}
    row: 28
    col: 14
    width: 10
    height: 6
  - title: Percent of Total Sales by Product Line for Seating
    name: Percent of Total Sales by Product Line for Seating
    model: main
    explore: sales_order_line
    type: looker_bar
    fields: [item.line_raw, sales_order_line.total_gross_Amt_non_rounded]
    filters:
      sales_order.channel: DTC,Wholesale,Owned Retail
      sales_order_line.created_date: 12 months
      item.category_name: SEATING
      sales_order.is_exchange_upgrade_warranty: 'No'
    sorts: [sales_order_line.total_gross_Amt_non_rounded desc]
    limit: 500
    total: true
    dynamic_fields: [{table_calculation: percent_of_total, label: Percent of Total,
        expression: "${sales_order_line.total_gross_Amt_non_rounded}/${sales_order_line.total_gross_Amt_non_rounded:total}",
        value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: America/Denver
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: right
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: bottom, series: [{axisId: percent_of_units_returned,
            id: percent_of_units_returned, name: Percent of Units Returned}], showLabels: false,
        showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    x_axis_datetime_label: "%b %y"
    show_dropoff: false
    show_null_points: true
    interpolation: linear
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hidden_fields: [sales_order_line.total_gross_Amt_non_rounded]
    listen: {}
    row: 34
    col: 5
    width: 9
    height: 6
  - name: Table Calculations
    type: text
    title_text: Table Calculations
    subtitle_text: Percent
    row: 28
    col: 0
    width: 5
    height: 6
  - name: Table Calculations (2)
    type: text
    title_text: Table Calculations
    subtitle_text: Percent of Total
    row: 34
    col: 0
    width: 5
    height: 6
  - title: Percent of Units Returned
    name: Percent of Units Returned
    model: main
    explore: sales_order_line
    type: single_value
    fields: [sales_order_line.total_units, return_order_line.units_returned]
    filters:
      sales_order.channel: DTC,Wholesale,Owned Retail
      sales_order_line.created_date: 12 months
      sales_order.is_exchange_upgrade_warranty: ''
    limit: 500
    dynamic_fields: [{table_calculation: percent_of_units_returned, label: Percent
          of Units Returned, expression: "${return_order_line.units_returned}/${sales_order_line.total_units}",
        value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: America/Denver
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: right
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: DTC - sales_order_line.total_gross_Amt_non_rounded,
            id: DTC - sales_order_line.total_gross_Amt_non_rounded, name: DTC}, {
            axisId: Employee Store - sales_order_line.total_gross_Amt_non_rounded,
            id: Employee Store - sales_order_line.total_gross_Amt_non_rounded, name: Employee
              Store}, {axisId: General - sales_order_line.total_gross_Amt_non_rounded,
            id: General - sales_order_line.total_gross_Amt_non_rounded, name: General},
          {axisId: Owned Retail - sales_order_line.total_gross_Amt_non_rounded, id: Owned
              Retail - sales_order_line.total_gross_Amt_non_rounded, name: Owned Retail},
          {axisId: Wholesale - sales_order_line.total_gross_Amt_non_rounded, id: Wholesale
              - sales_order_line.total_gross_Amt_non_rounded, name: Wholesale}], showLabels: false,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    x_axis_datetime_label: "%b %y"
    show_dropoff: false
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields: [sales_order_line.total_units, return_order_line.units_returned]
    listen: {}
    row: 28
    col: 5
    width: 9
    height: 6
  - title: Percent of Total Foam Mattress Cancellations
    name: Percent of Total Foam Mattress Cancellations
    model: main
    explore: sales_order_line
    type: looker_bar
    fields: [cancelled_order.orders_cancelled, item.model_raw]
    filters:
      sales_order.channel: DTC,Wholesale,Owned Retail
      sales_order_line.created_date: 12 months
      item.category_name: MATTRESS
      item.line_raw: FOAM
      sales_order.is_exchange_upgrade_warranty: ''
    sorts: [cancelled_order.orders_cancelled desc]
    limit: 500
    total: true
    dynamic_fields: [{table_calculation: percent_of_total, label: Percent of Total,
        expression: "${cancelled_order.orders_cancelled}/${cancelled_order.orders_cancelled:total}",
        value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: America/Denver
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: right
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: bottom, series: [{axisId: percent_of_units_returned,
            id: percent_of_units_returned, name: Percent of Units Returned}], showLabels: false,
        showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    x_axis_datetime_label: "%b %y"
    show_dropoff: false
    show_null_points: true
    interpolation: linear
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hidden_fields: [cancelled_order.orders_cancelled]
    listen: {}
    row: 34
    col: 14
    width: 10
    height: 6
