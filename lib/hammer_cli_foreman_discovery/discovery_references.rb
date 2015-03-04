module HammerCLIForemanDiscovery

  module DiscoveryReferences
    def self.hosts(dsl)
      dsl.build do
        collection :hosts, _("Hosts"), :numbered => false do
          custom_field Fields::Reference
        end
      end
    end
  end
end