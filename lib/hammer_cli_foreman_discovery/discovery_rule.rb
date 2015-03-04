require 'hammer_cli'
require 'hammer_cli_foreman'
require 'hammer_cli_foreman_discovery/discovery_references'

module HammerCLIForemanDiscovery

  module CommonDiscoveryRuleUpdateOptions

    def self.included(base)
      base.option "--hosts-limit", "HOSTS_LIMIT", " ", :attribute_name => :option_max_count
      base.build_options :without => :max_count
    end

  end

  class DiscoveryRule < HammerCLIForeman::Command

    resource :discovery_rules

    class ListCommand < HammerCLIForeman::ListCommand

      output do
        field :id, _("ID")
        field :name, _("Name")
        field :priority, _("Priority")
        field :search, _("Search")
        field nil, _("Host Group"), Fields::SingleReference, :key => :hostgroup
        field :hosts_limit, _("Hosts Limit")
        field :enabled, _("Enabled")
      end

      build_options
    end

    class InfoCommand < HammerCLIForeman::InfoCommand

      output ListCommand.output_definition do
        field :hostname, _('Hostname template')
        HammerCLIForemanDiscovery::DiscoveryReferences.hosts(self)
      end

      build_options
    end

    class CreateCommand < HammerCLIForeman::CreateCommand
      success_message _("Rule created")
      failure_message _("Could not create the rule")

      include HammerCLIForemanDiscovery::CommonDiscoveryRuleUpdateOptions
      build_options
    end

    class UpdateCommand < HammerCLIForeman::UpdateCommand
      success_message _("Rule updated")
      failure_message _("Could not update the rule")

      include HammerCLIForemanDiscovery::CommonDiscoveryRuleUpdateOptions
      build_options
    end

    class DeleteCommand < HammerCLIForeman::DeleteCommand
      success_message _("Rule deleted")
      failure_message _("Could not delete the rule")

      build_options
    end

    autoload_subcommands
  end

end
