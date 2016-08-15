module ContextHoldable
  extend ActiveSupport::Concern

  CONTEXTS = { normal: 'normal', contact: 'contact' }
end
