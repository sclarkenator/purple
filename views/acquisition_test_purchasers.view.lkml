view: acquisition_test_purchasers {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql:



--- Orders on or after 6/2 that qualify people to be part of the test
  WITH a AS (
    SELECT
    CASE WHEN 'yes' = 'yes' THEN customer_table.email ELSE '**********' || '@' || SPLIT_PART (customer_table.email, '@', 2) END AS "EMAIL"
    , MIN(SALES_ORDER.CREATED) "CREATED"
  FROM
    SALES.SALES_ORDER_LINE AS SALES_ORDER_LINE
    LEFT JOIN SALES.ITEM AS ITEM ON sales_order_line.ITEM_ID = item.ITEM_ID
    LEFT JOIN SALES.FULFILLMENT AS FULFILLMENT ON(
      sales_order_line.item_id || '-' || sales_order_line.order_id || '-' || sales_order_line.system
    ) = (
      CASE WHEN fulfillment.parent_item_id = 0
      OR fulfillment.parent_item_id IS NULL THEN fulfillment.item_id ELSE fulfillment.parent_item_id END
    )|| '-' || fulfillment.order_id || '-' || fulfillment.system
    LEFT JOIN SALES.SALES_ORDER AS SALES_ORDER ON(
      sales_order_line.order_id || '-' || sales_order_line.system
    ) = (
      sales_order.order_id || '-' || sales_order.system
    ) FULL
    OUTER JOIN SALES.WARRANTY_ORDER AS WARRANTY_ORDER ON sales_order.ORDER_ID = warranty_order.ORDER_ID
    AND sales_order.SYSTEM = warranty_order.ORIGINAL_SYSTEM
    LEFT JOIN analytics_stage.netsuite.CUSTOMERS AS customer_table ON (
      customer_table.customer_id::INT
    ) = sales_order.CUSTOMER_ID
    LEFT JOIN SALES.CANCELLED_ORDER AS CANCELLED_ORDER ON(
      sales_order_line.item_id || '-' || sales_order_line.order_id || '-' || sales_order_line.system
    ) =(
      cancelled_order.item_id || '-' || cancelled_order.order_id || '-' || cancelled_order.system
    )
    LEFT JOIN SALES.EXCHANGE_ORDER_LINE AS EXCHANGE_ORDER_LINE ON sales_order_line.ORDER_ID = (exchange_order_line."ORDER_ID")
    AND sales_order_line.ITEM_ID = (exchange_order_line."ITEM_ID")
    AND sales_order_line.SYSTEM = (exchange_order_line."SYSTEM")
  WHERE
    (((to_timestamp_ntz(sales_order_line.Created)) >= ((DATEADD('day', 0, '2020-06-02'::DATE)))
        AND(to_timestamp_ntz(sales_order_line.Created)) < (CURRENT_DATE()::DATE))
    )
    AND (((CASE WHEN item.merchandise = 1 THEN 1 ELSE 0 END ) = 0)
    AND (item.bi_update = 1)
    )
    AND (
      (
        (
          CASE WHEN --split king mattress kits and split king powerbase kits
          item.ITEM_ID IN (
            '9815', '9824', '9786', '9792', '9818',
            '9803', '4412', '4413', '4409', '4410',
            '4411', '3573'
          ) -- then 'FG'
          -- adds metal frame bases to finished goods
          OR item.line = 'FRAME'
          OR (
            item.category = 'SEATING'
            AND (
              item.product_description ilike '%4 PK'
              OR item.product_description ilike '%6 PK'
            )
          ) THEN 'FG' ELSE item.classification_new END
        ) = 'FG'
      )
      AND (
        (item.line) IN (
          'COIL', 'FOAM', 'PROTECTOR', 'POWERBASE',
          'FOUNDATION', 'SHEETS', 'PILLOW'
        )
        AND (
          CASE WHEN sales_order.CHANNEL_id = 1 THEN 'DTC' WHEN sales_order.CHANNEL_id = 2 THEN 'Wholesale' WHEN sales_order.CHANNEL_id = 3 THEN 'General' WHEN sales_order.CHANNEL_id = 4 THEN 'Employee Store' WHEN sales_order.CHANNEL_id = 5 THEN 'Owned Retail' ELSE 'Other' END
        ) = 'DTC'
      )
    )
    AND (
      (
        (
          CASE WHEN sales_order.IS_UPGRADE = 'T' THEN 1 ELSE 0 END
        ) = 0
      )
      AND (
        (
          (
            CASE WHEN sales_order.EXCHANGE = 'T' THEN 1 ELSE 0 END
          ) = 0
        )
        AND (
          (
            CASE WHEN sales_order.WARRANTY_CLAIM_ID IS NOT NULL
            OR sales_order.warranty = 'T' THEN 1 ELSE 0 END
          ) = 0
        )
      )
      AND (
        (
          (
            CASE WHEN (
              TO_CHAR(
                TO_DATE(
                  to_timestamp_ntz(cancelled_order.CANCELLED)
                ),
                'YYYY-MM-DD'
              )
            ) IS NOT NULL THEN 1 ELSE 0 END
          ) = 0
        )
        AND (
          (
            (
              CASE WHEN warranty_order.CREATED IS NOT NULL THEN 1 ELSE 0 END
            ) = 0
          )
          AND (
            (
              CASE WHEN exchange_order_line.CREATED IS NOT NULL THEN 1 ELSE 0 END
            ) = 0
          )
        )
      )
    )
  GROUP BY
    1
)

-- ORDERS PLACED AFTER A QUALIFIED ORDER FROM TABLE A

, b AS (

    SELECT
    CASE WHEN 'yes' = 'yes' THEN customer_table.email ELSE '**********' || '@' || SPLIT_PART (customer_table.email, '@', 2) END AS "EMAIL"
    , SALES_ORDER.CREATED
    , SALES_ORDER.RELATED_TRANID
    , SALES_ORDER.ORDER_ID
    , SALES_ORDER.SYSTEM
    , SALES_ORDER.WARRANTY
  FROM
    SALES.SALES_ORDER_LINE AS SALES_ORDER_LINE
    LEFT JOIN SALES.ITEM AS ITEM ON sales_order_line.ITEM_ID = item.ITEM_ID
    LEFT JOIN SALES.FULFILLMENT AS FULFILLMENT ON(
      sales_order_line.item_id || '-' || sales_order_line.order_id || '-' || sales_order_line.system
    ) = (
      CASE WHEN fulfillment.parent_item_id = 0
      OR fulfillment.parent_item_id IS NULL THEN fulfillment.item_id ELSE fulfillment.parent_item_id END
    )|| '-' || fulfillment.order_id || '-' || fulfillment.system
    LEFT JOIN SALES.SALES_ORDER AS SALES_ORDER ON(
      sales_order_line.order_id || '-' || sales_order_line.system
    ) = (
      sales_order.order_id || '-' || sales_order.system
    ) FULL
    OUTER JOIN SALES.WARRANTY_ORDER AS WARRANTY_ORDER ON sales_order.ORDER_ID = warranty_order.ORDER_ID
    AND sales_order.SYSTEM = warranty_order.ORIGINAL_SYSTEM
    LEFT JOIN analytics_stage.netsuite.CUSTOMERS AS customer_table ON (
      customer_table.customer_id::INT
    ) = sales_order.CUSTOMER_ID
    LEFT JOIN SALES.CANCELLED_ORDER AS CANCELLED_ORDER ON(
      sales_order_line.item_id || '-' || sales_order_line.order_id || '-' || sales_order_line.system
    ) =(
      cancelled_order.item_id || '-' || cancelled_order.order_id || '-' || cancelled_order.system
    )
    LEFT JOIN SALES.EXCHANGE_ORDER_LINE AS EXCHANGE_ORDER_LINE ON sales_order_line.ORDER_ID = (exchange_order_line."ORDER_ID")
    AND sales_order_line.ITEM_ID = (exchange_order_line."ITEM_ID")
    AND sales_order_line.SYSTEM = (exchange_order_line."SYSTEM")
  WHERE sales_order_line.gross_amt > 0 AND
    (((to_timestamp_ntz(sales_order_line.Created)) >= ((DATEADD('day', 0, '2020-06-02'::DATE)))
        AND(to_timestamp_ntz(sales_order_line.Created)) < (CURRENT_DATE()::DATE))
    )
    AND (((CASE WHEN item.merchandise = 1 THEN 1 ELSE 0 END ) = 0)
    AND (item.bi_update = 1)
    )
    AND (
      (
        (
          CASE WHEN --split king mattress kits and split king powerbase kits
          item.ITEM_ID IN (
            '9815', '9824', '9786', '9792', '9818',
            '9803', '4412', '4413', '4409', '4410',
            '4411', '3573'
          ) -- then 'FG'
          -- adds metal frame bases to finished goods
          OR item.line = 'FRAME'
          OR (
            item.category = 'SEATING'
            AND (
              item.product_description ilike '%4 PK'
              OR item.product_description ilike '%6 PK'
            )
          ) THEN 'FG' ELSE item.classification_new END
        ) = 'FG'
      )
      AND (

        (
          CASE WHEN sales_order.CHANNEL_id = 1 THEN 'DTC' WHEN sales_order.CHANNEL_id = 2 THEN 'Wholesale' WHEN sales_order.CHANNEL_id = 3 THEN 'General' WHEN sales_order.CHANNEL_id = 4 THEN 'Employee Store' WHEN sales_order.CHANNEL_id = 5 THEN 'Owned Retail' ELSE 'Other' END
        ) = 'DTC'
      )
    )
    AND (
      (
        (
          CASE WHEN sales_order.IS_UPGRADE = 'T' THEN 1 ELSE 0 END
        ) = 0
      )
      AND (
        (
          (
            CASE WHEN sales_order.EXCHANGE = 'T' THEN 1 ELSE 0 END
          ) = 0
        )
        AND (
          (
            CASE WHEN sales_order.WARRANTY_CLAIM_ID IS NOT NULL
            OR sales_order.warranty = 'T' THEN 1 ELSE 0 END
          ) = 0
        )
      )
      AND (
        (
          (
            CASE WHEN (
              TO_CHAR(
                TO_DATE(
                  to_timestamp_ntz(cancelled_order.CANCELLED)
                ),
                'YYYY-MM-DD'
              )
            ) IS NOT NULL THEN 1 ELSE 0 END
          ) = 0
        )
        AND (
          (
            (
              CASE WHEN warranty_order.CREATED IS NOT NULL THEN 1 ELSE 0 END
            ) = 0
          )
          AND (
            (
              CASE WHEN exchange_order_line.CREATED IS NOT NULL THEN 1 ELSE 0 END
            ) = 0
          )
        )
      )
    )
)

SELECT b.EMAIL, b.RELATED_TRANID,b.ORDER_ID,b.SYSTEM, b.warranty
FROM a JOIN b ON a.EMAIL = b.EMAIL
WHERE b.CREATED > a.CREATED
  AND a.CREATED::DATE >= '2020-06-02'
  AND b.warranty = 'F'


UNION

-- THE BELOW QUERY IS FOR ANYONE THAT PURCHASED BEFORE 6/2 AND AGAIN AFTER 6/2
SELECT EMAIL
    ,RELATED_TRANID
    ,ORDER_ID
    ,SYSTEM
    ,warranty
FROM  analytics.sales.sales_order S
WHERE TRANDATE >= '2020-06-02'::DATE
  AND warranty = 'F'
  AND gross_amt > 0
  AND EMAIL IN (
  SELECT
    CASE WHEN 'yes' = 'yes' THEN customer_table.email ELSE '**********' || '@' || SPLIT_PART (customer_table.email, '@', 2) END AS "EMAIL"
  FROM
    SALES.SALES_ORDER_LINE AS SALES_ORDER_LINE
    LEFT JOIN SALES.ITEM AS ITEM ON sales_order_line.ITEM_ID = item.ITEM_ID
    LEFT JOIN SALES.FULFILLMENT AS FULFILLMENT ON(
      sales_order_line.item_id || '-' || sales_order_line.order_id || '-' || sales_order_line.system
    ) = (
      CASE WHEN fulfillment.parent_item_id = 0
      OR fulfillment.parent_item_id IS NULL THEN fulfillment.item_id ELSE fulfillment.parent_item_id END
    )|| '-' || fulfillment.order_id || '-' || fulfillment.system
    LEFT JOIN SALES.SALES_ORDER AS SALES_ORDER ON(
      sales_order_line.order_id || '-' || sales_order_line.system
    ) = (
      sales_order.order_id || '-' || sales_order.system
    ) FULL
    OUTER JOIN SALES.WARRANTY_ORDER AS WARRANTY_ORDER ON sales_order.ORDER_ID = warranty_order.ORDER_ID
    AND sales_order.SYSTEM = warranty_order.ORIGINAL_SYSTEM
    LEFT JOIN analytics_stage.netsuite.CUSTOMERS AS customer_table ON (
      customer_table.customer_id::INT
    ) = sales_order.CUSTOMER_ID
    LEFT JOIN SALES.CANCELLED_ORDER AS CANCELLED_ORDER ON(
      sales_order_line.item_id || '-' || sales_order_line.order_id || '-' || sales_order_line.system
    ) =(
      cancelled_order.item_id || '-' || cancelled_order.order_id || '-' || cancelled_order.system
    )
    LEFT JOIN SALES.EXCHANGE_ORDER_LINE AS EXCHANGE_ORDER_LINE ON sales_order_line.ORDER_ID = (exchange_order_line."ORDER_ID")
    AND sales_order_line.ITEM_ID = (exchange_order_line."ITEM_ID")
    AND sales_order_line.SYSTEM = (exchange_order_line."SYSTEM")
  WHERE
    (((to_timestamp_ntz(sales_order_line.Created)) >= ((DATEADD('day', -100, '2020-05-28'::DATE)))
        AND(to_timestamp_ntz(sales_order_line.Created)) <= ('2020-05-28'::DATE))
    )
    AND (((CASE WHEN item.merchandise = 1 THEN 1 ELSE 0 END ) = 0)
    AND (item.bi_update = 1)
    )
    AND (
      (
        (
          CASE WHEN --split king mattress kits and split king powerbase kits
          item.ITEM_ID IN (
            '9815', '9824', '9786', '9792', '9818',
            '9803', '4412', '4413', '4409', '4410',
            '4411', '3573'
          ) -- then 'FG'
          -- adds metal frame bases to finished goods
          OR item.line = 'FRAME'
          OR (
            item.category = 'SEATING'
            AND (
              item.product_description ilike '%4 PK'
              OR item.product_description ilike '%6 PK'
            )
          ) THEN 'FG' ELSE item.classification_new END
        ) = 'FG'
      )
      AND (
        (item.line) IN (
          'COIL', 'FOAM', 'PROTECTOR', 'POWERBASE',
          'FOUNDATION', 'SHEETS', 'PILLOW'
        )
        AND (
          CASE WHEN sales_order.CHANNEL_id = 1 THEN 'DTC' WHEN sales_order.CHANNEL_id = 2 THEN 'Wholesale' WHEN sales_order.CHANNEL_id = 3 THEN 'General' WHEN sales_order.CHANNEL_id = 4 THEN 'Employee Store' WHEN sales_order.CHANNEL_id = 5 THEN 'Owned Retail' ELSE 'Other' END
        ) = 'DTC'
      )
    )
    AND (
      (
        (
          CASE WHEN sales_order.IS_UPGRADE = 'T' THEN 1 ELSE 0 END
        ) = 0
      )
      AND (
        (
          (
            CASE WHEN sales_order.EXCHANGE = 'T' THEN 1 ELSE 0 END
          ) = 0
        )
        AND (
          (
            CASE WHEN sales_order.WARRANTY_CLAIM_ID IS NOT NULL
            OR sales_order.warranty = 'T' THEN 1 ELSE 0 END
          ) = 0
        )
      )
      AND (
        (
          (
            CASE WHEN (
              TO_CHAR(
                TO_DATE(
                  to_timestamp_ntz(cancelled_order.CANCELLED)
                ),
                'YYYY-MM-DD'
              )
            ) IS NOT NULL THEN 1 ELSE 0 END
          ) = 0
        )
        AND (
          (
            (
              CASE WHEN warranty_order.CREATED IS NOT NULL THEN 1 ELSE 0 END
            ) = 0
          )
          AND (
            (
              CASE WHEN exchange_order_line.CREATED IS NOT NULL THEN 1 ELSE 0 END
            ) = 0
          )
        )
      )
    )
  GROUP BY
    1
  ORDER BY 1)
      ;;
   }

  dimension: email {
    type: string
    hidden: yes
    sql: ${TABLE}.email ;;
    description: "email address of people that have purchased as part of the acquisition test"
  }
  measure:  email_count{
    type:  count_distinct
    group_label: " Advanced"
    label: "Distinct email count"
    sql: ${TABLE}.email ;;
    description: "Distinct count of email addresses for acquisition test purchasers"
  }

  # dimension: email_primary_key{
  #   primary_key: yes
  #   hidden: yes
  #   sql: ${TABLE}.email||${TABLE}.related_tranid ;;
  # }

  dimension: order_system {
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.order_id||'-'||${TABLE}.system ;;
  }

  dimension: related_tranid{
    primary_key: no
    hidden: yes
    sql: ${TABLE}.related_tranid ;;
  }

  dimension: test_purchase {
    group_label: " Advanced"
    label: "     * Made Purchase"
    description: "The customer in the A/B test made a purchase. Source: looker.calculation"
    type: yesno
    sql: ${TABLE}.order_id||${TABLE}.system is not NULL ;;
  }

}
