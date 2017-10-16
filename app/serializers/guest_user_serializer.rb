class GuestUserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :guest_key
end
