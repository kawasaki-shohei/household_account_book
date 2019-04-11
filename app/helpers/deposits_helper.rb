module DepositsHelper
  #fixme: N+1問題。カップルテーブルを作って、コールバックで合計額を自動計算するようにして、アソシエーションで取得できるようにしたほうがいい。
  def couples_total_amount
    action_name == 'withdraw' ? Deposit.all.where(user_id: [current_user.id, partner.id]).total_amount : 9999999999
  end
end