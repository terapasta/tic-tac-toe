class Answer < ActiveRecord::Base
  START_MESSAGE_ID = 1
  NO_CLASSIFIED_MESSAGE_ID = 27
  TRANSITION_CONTEXT_CONTACT_ID = 16
  STOP_CONTEXT_ID = 28
  ASK_GUEST_NAME_ID = 29
  ASK_EMAIL_ID = 30
  ASK_BODY_ID = 31
  ASK_COMPLETE_ID = 32

  # TODO 共通化したい
  enum context: { normal: 'normal', contact: 'contact' }
end
