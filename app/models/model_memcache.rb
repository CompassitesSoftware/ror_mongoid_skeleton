module ModelMemcache
  extend ActiveSupport::Concern
  included do
    after_save :update_model_memcache
    after_update :update_model_memcache
    after_destroy :expire_model_memcache

  end

  module ClassMethods
    def by_id_cache_key(id)
      "#{self.name.camelize}_by_id=#{id}"
    end

    def find(*args)
      if args.length == 1 && (args[0].is_a?(String) || args[0].is_a?(Moped::BSON::ObjectId))
        a = self.relations.keep_if{|key, value| value.relation == Mongoid::Relations::Referenced::Many}.map { |k,v| v}
        a.each do |rel_name|
          eval(rel_name.class_name)
        end
        Rails.cache.fetch(self.by_id_cache_key(args[0].to_s)) { super(*args) }
        #super(*args)
      else
        super(*args)
      end
    end
  end

  protected

  def update_model_memcache
    Rails.cache.fetch(self.class.by_id_cache_key(self.id), force: true){self}
  end

  def expire_model_memcache
    Rails.cache.fetch(self.class.by_id_cache_key(self.id), force: true){nil}
  end
end