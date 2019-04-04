module DepositDecorator
  def amount_with_plus_or_minus
    if is_withdrawn
      "▲" + amount.to_s(:delimited)
    else
      amount.to_s(:delimited)
    end
  end

  def converted_date
    date.strftime("%Y/%m/%d")
  end

  def truncated_memo
    truncate(memo, length: 10)
  end

  def amount_link_with_plus_or_minus
    make_link_tag(amount_with_plus_or_minus)
  end

  def date_with_link
    make_link_tag(converted_date)
  end

  def username_with_link
    make_link_tag(user.name)
  end

  def memo_with_link
    make_link_tag(truncated_memo)
  end

  def make_link_tag(str)
    link_to str, edit_deposit_path(self), style: "text-decoration: underline;"
  end

  #todo: エラーにはならないけど、dateのデータ型をdateに変更したら.to_dateはいらない
  def default_date
    action_name == 'edit' ? date.to_date : Date.current
  end
end
