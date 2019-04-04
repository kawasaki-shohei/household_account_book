module DepositsHelper
  #fixme: コントローラでsqlは引いておく。
  def couples_total_amount
    action_name == 'withdraw' ? Deposit.all.where(user_id: [current_user.id, partner.id]).total_amount : 9999999999
  end
end