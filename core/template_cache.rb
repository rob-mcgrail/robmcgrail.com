# Move this module out once it's paying its way.
# otherwise bake in to TemplateCache

module CacheTools
  # Removes some hash items - the least recently used.
  # I tend to clear out about a third (see value x/3) when
  # the cache gets full...
  def lru_cleanup(hash)
    x = hash.length
    by_time = hash.sort do |a,b|
      a[1][:time].to_i <=> b[1][:time].to_i
    end
    by_time = by_time[0..(x/3)]
    by_time.each {|v| hash.delete(v[0])}
    hash
  end

  # Recalculates the size of the hash.
  def resize(hash)
    x = 0
    hash.each {|k,v| x += v[:data].bytesize}
    x
  end
end

class TemplateCache
  class << self
    include CacheTools

    @@h = {}
    @@size = 0

    # Retrieve a template from the cache.
    def get(key)
      if @@h[key].nil?
        nil
      else
        # add new read time
        @@h[key][:time] = Time.new
        @@h[key][:data]
      end
    end


    def store(key, data)
      @@h[key] = {:data => data, :time => Time.new}
      # Increase the cache size
      @@size += data.bytesize
      # Check that we haven't exceeded the maximum
      if @@size > TEMPLATE_CACHE_MAX
        lru_cleanup(@@h)
        @@size = resize(@@h)
      end
    end
  end
end

