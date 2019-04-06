module DepositDecorator
  include CommonDecorator
  def amount_with_plus_or_minus
    if is_withdrawn
      "▲" + amount.to_s(:delimited)
    else
      amount.to_s(:delimited)
    end
  end

  #todo: エラーにはならないけど、dateのデータ型をdateに変更したら.to_dateはいらない
  def default_date
    action_name == 'edit' ? date.to_date : Date.current
  end
end
