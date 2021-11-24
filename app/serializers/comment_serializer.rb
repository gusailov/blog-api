class CommentSerializer < ActiveModel::Serializer
  # TODO: if you serializer a date/datetime - use iso8601 format please
  attributes :id, :user_id, :body, :created_at
end
