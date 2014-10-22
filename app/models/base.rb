require_dependency 'cache_persistence'

class Base
  include CachePersistence
  include ActiveModel::Model
  include ActiveModel::SerializerSupport
end