module HammerCLIForemanDiscovery
  class DiscoveredHost < HammerCLIForeman::Command

    resource :discovered_hosts

    class ListCommand < HammerCLIForeman::ListCommand
        output do
          field :id, _("Id")
          field :name, _("Name")
          field :mac, _("Mac")
          field :last_report, _('Last Report')
          field :subnet_name, _('Subnet')
          field :organization_name, _('Organization')
          field :location_name, _('Location')
        end

        build_options
    end

    autoload_subcommands
  end

  HammerCLI::MainCommand.subcommand 'discovery', "Discovery related actions.", DiscoveredHost
end
