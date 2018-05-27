class WantsController < ApplicationController
  before_action :check_logging_in
  before_action :check_partner

  def index
    @wants = (current_user.wants).or(partner.wants).order(created_at: :desc)
  end

  def new
    @want = Want.new
  end

  def create
    @want = Want.new(want_params)
    if @want.save
      redirect_to wants_path, notice: "新しい欲しいものリストを追加しました。"
    else
      render new
    end
  end

  private
  def want_params
    params.require(:want).permit(:name, :memo).merge(user_id: current_user.id)
  end
end
