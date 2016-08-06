class ContactAnswer < ActiveRecord::Base
  TRANSITION_CONTEXT_CONTACT_ID = 8
  STOP_CONTEXT_ID = 6
  ASK_GUEST_NAME_ID = 1
  ASK_EMAIL_ID = 2
  ASK_BODY_ID = 3
  ASK_COMPLETE_ID = 4
  ASK_ERROR_ID = 7
  ASK_CONFIRM_ID = 5

  def context
    'contact'
  end
end
