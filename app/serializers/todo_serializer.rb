class TodoSerializer < ActiveModel::Serializer
  attributes :id, :list_id, :title, :finished
end
