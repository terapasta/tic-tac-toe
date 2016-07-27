class Answer < ActiveRecord::Base
  START_MESSAGE_ID = 1
  NO_CLASSIFIED_MESSAGE_ID = 27
  TRANSITION_CONTEXT_CONTACT_ID = 16
  STOP_CONTEXT_ID = 1000
  ASK_GUEST_NAME_ID = 1001
  ASK_EMAIL_ID = 1002
  ASK_BODY_ID = 1003
  ASK_COMPLETE_ID = 1004
  ASK_ERROR_ID = 1005

  # TODO 共通化したい
  enum context: { normal: 'normal', contact: 'contact' }
  enum translate_to: { contact: 'contact' }
end
