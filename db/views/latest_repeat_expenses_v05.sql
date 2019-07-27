SELECT repeat_expenses_a.*
FROM (
    repeat_expenses repeat_expenses_a
    JOIN (
        SELECT repeat_expenses.item_id, repeat_expenses.user_id, max(repeat_expenses.item_sub_id) AS max_item_sub_id
        FROM repeat_expenses
        GROUP BY user_id, repeat_expenses.item_id
    ) repeat_expenses_b
    ON (
        (
            (repeat_expenses_a.user_id = repeat_expenses_b.user_id) AND
            (repeat_expenses_a.item_id = repeat_expenses_b.item_id) AND
            (repeat_expenses_a.item_sub_id = repeat_expenses_b.max_item_sub_id)
        )
    )
)
WHERE (repeat_expenses_a.deleted_at IS NULL);