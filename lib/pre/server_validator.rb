require 'resolv'
module Pre
  class ServerValidator
    def initialize(domain)
      @domain = domain
    end

    def valid?(resolution_provider = Resolv::DNS)
      resolver = resolution_provider.new
      resolver.getresources(@domain, Resolv::DNS::Resource::IN::MX).any?
    end
  end
end
