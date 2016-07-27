class Answer < ActiveRecord::Base
  START_MESSAGE_ID = 1
  NO_CLASSIFIED_MESSAGE_ID = 27
  TRANSITION_CONTEXT_CONTACT_ID = 16
  STOP_CONTEXT_ID = 1000
  ASK_GUEST_NAME_ID = 1001
  COMPLETE_CONTACT_ID = 1004

  enum translate_to: { contact: 'contact' }
end
