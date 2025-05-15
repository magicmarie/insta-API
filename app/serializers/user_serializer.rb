class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :bio, :avatar_url

  def avatar_url
    Rails.application.routes.url_helpers.url_for(object.avatar) if object.avatar.attached?
  end
end
