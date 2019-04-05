module ApplicationHelper
  include SessionsHelper, UsersHelper

  def submit_btn_letters
    case action_name
    when 'new', 'withdraw'
      return '入力'
    when 'edit'
      return '編集'
    else
      return '送信'
    end
  end
  
  def get_edit_link(object)
    object_name = object.class.table_name.singularize
    icon = raw("<i class=\"fa fa-lg fa-pencil-square-o text-red\"></i>")
    if object.user == current_user
      link_to icon, self.send("edit_#{object_name}_path",object)
    else
      ''
    end
  end
end
