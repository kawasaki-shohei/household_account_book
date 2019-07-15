module CommonDecorator
  def get_edit_link
    self_name = self.class.table_name.singularize
    icon = raw("<i class=\"fa fa-lg fa-pencil-square-o text-redpepper\"></i>")
    if user == current_user
      link_to icon, self.send("edit_#{self_name}_path",self)
    else
      ''
    end
  end

  def default_date
    action_name == 'edit' ? date : Date.current
  end

  def date_as_string
    date.strftime("%Y/%m/%d")
  end

  def delimited_amount
    amount.to_s(:delimited)
  end

  def red_amount
    amount_str = "-" + amount.abs.to_s(:delimited)
    make_it_red(amount_str)
  end

  def truncated_memo
    memo.truncate(5, omission: "..")
  end

  def make_it_red(str)
    content_tag(:span, str, class: "text-redpepper")
  end
end
