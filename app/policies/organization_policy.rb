class OrganizationPolicy < ApplicationPolicy
  def permitted_attributes
    [
      :name,
      :image,
      :remove_image,
      :description,
      :plan,
      user_memberships_attributes: [
        :id,
        :user_id,
        :_destroy
      ],
      bot_ownerships_attributes: [
        :id,
        :bot_id,
        :_destroy
      ]
    ]
  end
end
