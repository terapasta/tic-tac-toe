class MemberMessageSerializer < MessageSerializer
 
  def reply_log
    object.reply_log
  end
end
