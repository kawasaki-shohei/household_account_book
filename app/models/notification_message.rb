# ## Schema Information
#
# Table name: `notification_messages`
#
# ### Columns
#
# Name          | Type               | Attributes
# ------------- | ------------------ | ---------------------------
# **`id`**      | `bigint(8)`        | `not null, primary key`
# **`act`**     | `string`           |
# **`func`**    | `string`           |
# **`msg_id`**  | `integer`          |
#
# ### Indexes
#
# * `index_notification_messages_on_msg_id` (_unique_):
#     * **`msg_id`**
#

class NotificationMessage < ApplicationRecord
end
