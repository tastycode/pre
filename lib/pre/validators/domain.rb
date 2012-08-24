require 'pry'
require 'resolv'
module Pre
  module Validators
    module Domain
      def self.expiry
        3600
      end

      def cache_key key
        "resolv_dns_result_#{key}"
      end

      def valid_domain?(resolution_provider = Resolv::DNS.new)
        cache_fetch cache_key(domain) do
          resolution_provider.getresources(domain, Resolv::DNS::Resource::IN::MX).any?
        end
      end
    end
  end
end
