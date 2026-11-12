# frozen_string_literal: true

require 'hammer_cli_foreman/subnet'

module HammerCLIForemanDiscovery
  class SubnetExtensions < ::HammerCLI::CommandExtensions
    output do |definition|
      definition.at(_('Smart Proxies')).append do
        field :discovery, _('Discovery'), Fields::Reference, details: :url
      end
    end
  end

  ::HammerCLIForeman::Subnet::InfoCommand.extend_with(SubnetExtensions.new)
end
