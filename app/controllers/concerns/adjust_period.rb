module AdjustPeriod
  private
  def period_params
    if params[:period].nil?
      return Date.current.to_s_as_period
    elsif params[:period].is_invalid_period?
      raise 'error'
    else
      params[:period]
    end
  end
end