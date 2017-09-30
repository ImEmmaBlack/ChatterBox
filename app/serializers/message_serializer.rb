class MessageSerializer < ActiveModel::Serializer
  attributes :id, :body, :url, :type_id, :metadata, :user_id, :created_at
  belongs_to :user
end

