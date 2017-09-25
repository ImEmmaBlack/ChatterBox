class MessageSerializer < ActiveModel::Serializer
  attributes :id, :body, :url, :type, :metadata, :user_id, :created_at
end

