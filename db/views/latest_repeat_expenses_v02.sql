SELECT repeat_expenses_a.*
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