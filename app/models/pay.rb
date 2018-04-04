class Pay < ApplicationRecord
  belongs_to :user

  validates :pamount, :date, presence: true

  scope :newer, -> {order(date: :desc, created_at: :desc)}

  def self.all_payments(current_user, partner)
    current_user.pays.or(partner.pays).newer
  end

  def self.balance_of_gross(current_user, partner)
    my_expenses = current_user.expenses.both_t.sum(:mypay) + partner.expenses.both_t.sum(:partnerpay)
    current_user_payments = current_user.pays.sum(:pamount)
    partner_payments = partner.pays.sum(:pamount)
    balance = partner_payments - my_expenses - current_user_payments
    return balance

    # 自分が払っているお金 + 相手が払っているお金 - 自分が払わなければいけないお金 - 相手が手渡したお金
    # 相手がはらわなければいけないお金 - 相手が手渡したお金 = 0
    # 相手がはらわなければいけないお金 - 自分が手渡したお金 = 0
    # (自分が払っているお金 + パートナーが手渡したお金 + 自分が手渡したお金) - 総額
    # (自分が払っているお金 + パートナーが手渡したお金 + 自分が手渡したお金) - (自分が払っているお金 + 相手が払っているお金)
    # 自分が手渡すお金 = 自分が払わなければいけないお金 - 自分が払っているお金 - 自分が手渡してきたお金 -
    #
    # my_expenses = current_user.expenses.both_t.sum(:mypay) + partner.expenses.both_t.sum(:partnerpay)
    # current_user_payments = current_user.pays.sum(:pamount)
    # partner_payments = partner.pays.sum(:pamount)
    # balance = current_user_payments - my_expenses - partner_payments
    # return balance
  end

end
