class LoggerUtility
  @logger = Rails.logger
  def self.output_info_log(**args)
    class_name = args.fetch(:class_name, nil)
    method = args.fetch(:method, nil)
    if class_name && method
     location = "#{class_name}\##{method}"
    end
    user = args.fetch(:user)
    message = args.fetch(:message)
    @logger.info "========================================================================"
    if location && user && message
      begin
        @logger.info "#{location} : user => id: #{user.id}, name: #{user.name}"
        @logger.info "#{location} : message => #{message}"
      rescue => e
        @logger.info "failed to output log"
        @logger.info e.message
      end
    end
    @logger.info "========================================================================"
  end

  def self.output_bc_log(balance_calculator)
    @logger.info "========================================================================"
    @logger.info "******** BALANCE_CALCULATOR_SUMMARY ********"
    attributes = BalanceHelper::BalanceCalculator.attributes
    attributes.each do |attr|
      message = "#{attr.to_s}: #{balance_calculator.try(attr)}"
      if balance_calculator.try(attr).is_a?(User)
        message = "#{attr.to_s}: #{balance_calculator.try(attr).name}"
      end
      @logger.info message
    end
    @logger.info "========================================================================"
  end

  def self.output_balance_lists(balance_lists)
    return unless balance_lists
    lists = balance_lists
    @logger.info "========================================================================"
    @logger.info "******** BALANCE_LISTS ********"
    lists.each do |list|
      @logger.info "-------------------------------------"
      @logger.info "user : id: #{list[:user].id}, name: #{list[:user].name}"
      @logger.info "period: #{list[:period]}"
      @logger.info "amount: #{list[:amount]}"
      @logger.info "-------------------------------------"
    end
    @logger.info "========================================================================"
  end

  def self.inform_unrelated_to_balance(object)
    @logger.info "========================================================================"
    @logger.info "#{object.class.name} id: #{object.id} is unrelated to balance"
    @logger.info "========================================================================"

  end
end