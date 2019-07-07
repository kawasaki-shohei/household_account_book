SELECT repeat_expenses_a.id,
      repeat_expenses_a.amount,
      repeat_expenses_a.s_date,
      repeat_expenses_a.e_date,
      repeat_expenses_a.r_date,
      repeat_expenses_a.memo,
      repeat_expenses_a.category_id,
      repeat_expenses_a.user_id,
      repeat_expenses_a.is_for_both,
      repeat_expenses_a.mypay,
      repeat_expenses_a.partnerpay,
      repeat_expenses_a.percent,
      repeat_expenses_a.created_at,
      repeat_expenses_a.updated_at,
      repeat_expenses_a.item_id,
      repeat_expenses_a.item_sub_id,
      repeat_expenses_a.updated_period,
      repeat_expenses_a.deleted_at
FROM repeat_expenses AS repeat_expenses_a
  INNER JOIN (SELECT
                item_id,
                MAX(item_sub_id) AS max_item_sub_id
              FROM
                repeat_expenses
              GROUP BY
                item_id)
  AS repeat_expenses_b
  ON repeat_expenses_a.item_id = repeat_expenses_b.item_id
  AND repeat_expenses_a.item_sub_id = repeat_expenses_b.max_item_sub_id
WHERE repeat_expenses_a.deleted_at is null;