module Pre
  class Cache
    module Fake
      def cache
        @cache ||= {}
      end
      def cache_read key
        cache[key]
      end
      def cache_write key, value
        cache[key] = value
      end
      def cache_fetch key, &block
        cache[key] ||= block.call
      end
    end
  end
end
