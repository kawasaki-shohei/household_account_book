module CommonDecorator
  def get_edit_link
    self_name = self.class.table_name.singularize
    icon = raw("<i class=\"fa fa-lg fa-pencil-square-o text-red\"></i>")
    if user == current_user
      link_to icon, self.send("edit_#{self_name}_path",self)
    else
      ''
    end
  end

  def date_as_string
    date.strftime("%Y/%m/%d")
  end

  def delimited_amount
    amount.to_s(:delimited)
  end

  def truncated_memo
    memo.truncate(5, omission: "..")
  end
end
