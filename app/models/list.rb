require_dependency 'cache_persistence'

class List
  include CachePersistence
  include ActiveModel::Model

  attr_accessor :name
end
