module Pre
  class CacheStore
    class Null
      def read key
      end
      def write key, val
      end
      def fetch key
        yield
      end
    end
  end
end
