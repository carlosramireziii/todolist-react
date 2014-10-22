module CachePersistence
  extend ActiveSupport::Concern

  included do
    include CachePersistence::CRUD
    include CachePersistence::Finders
  end

  module CRUD
    extend ActiveSupport::Concern

    included do
      
      attr_reader :id

      def ==(other)
        id == other.id if other.respond_to?(:id)
      end

      def to_param
        id.to_s
      end

      def persisted?
        id.presence
      end

    end

    def save
      return unless valid?
      database = CacheDatabase.new(self.class)
      @id ||= database.next_id
      database.commit(self.id, self)
    end
    alias_method :save!, :save

    def update(params)
      return unless valid?
      params.each do |name, value|
        self.send("#{name}=", value)
      end
      database = CacheDatabase.new(self.class.to_s)
      database.commit(self.id, self)
    end

    def destroy
      database = CacheDatabase.new(self.class.to_s)
      database.commit(self.id, nil)
    end

    def valid?
      true
    end

    module ClassMethods

      def find(id)
        database = CacheDatabase.new(self.to_s)
        database.fetch(id)
      end

      def all
        database = CacheDatabase.new(self.to_s)
        database.fetch_all
      end

      def destroy_all
        database = CacheDatabase.new(self.to_s)
        database.fetch_all.each do |record|
          record.destroy
        end
      end

      def count
        database = CacheDatabase.new(self.to_s)
        database.fetch_all.size
      end

    end

    # NOTE: this will probably suffer from multithreading problems
    class CacheDatabase

      def initialize(klass)
        @cache_key = "#{klass.to_s}/all"
      end

      def fetch(id)
        records_hash[id.to_i] or raise Errors::RecordNotFound.new("Record with id #{id} not found")
      end

      def fetch_all
        records_hash.values
      end

      def commit(id, record)
        records_hash[id.to_i] = record
        records_hash.delete(id) if record.nil?
        rewrite_records_hash
      end

      def next_id
        records_hash.keys.max.to_i + 1
      end

      private

      def records_hash
        @records_hash ||= fetch_records_hash
      end

      def fetch_records_hash
        Rails.cache.read(@cache_key) || {}
      end

      def rewrite_records_hash
        Rails.cache.write(@cache_key, records_hash)
      end

    end
  end

  module Finders
    extend ActiveSupport::Concern

    module ClassMethods

      def where(attrs = {})
        records = self.all
        attrs.each do |name, value|
          records.reject! { |r| r.send(name) != value }
        end
        records
      end

      def find_by(attrs = {})
        where(attrs).first
      end

      def limit(num)
        self.all.take(num)
      end

      def first
        self.all.first
      end

      def last
        self.all.last
      end

    end

  end

  module Errors
    class RecordNotFound < StandardError; end
  end
end