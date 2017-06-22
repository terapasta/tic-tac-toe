class BotSerializer < ActiveModel::Serializer
  attributes :id, :name, :classify_failed_message, :start_message, :image, :learning_status, :learning_status_changed_at
end
