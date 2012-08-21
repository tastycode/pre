require 'resolv'
module Pre
  module Validators
    module Domain
      def valid_domain?(resolution_provider = Resolv::DNS.new)
        resolution_provider.getresources(domain, Resolv::DNS::Resource::IN::MX).any?
      end
    end
  end
end
