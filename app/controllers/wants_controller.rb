class WantsController < ApplicationController
  after_action :create_notification, only:[:create, :update]

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

  def edit
    @want = Want.find(params[:id])
  end

  def update
    @want = Want.find(params[:id])
    if @want.update(want_params)
      redirect_to wants_path, notice: "新しい欲しいものリストを編集しました。"
    else
      render edit
    end
  end

  def destroy
    @want = Want.find(params[:id])
    @want.destroy
    redirect_to wants_path, notice: "新しい欲しいものリストを削除しました。"
  end

  private
  def want_params
    params.require(:want).permit(:name, :memo).merge(user_id: current_user.id)
  end

  def create_notification
    Notification.create(user_id: @want.user_id,
      notification_message_id: notification_msg,
      notified_by_id: @want.id,
      record_meta: @want.to_json
    )
  end
end
