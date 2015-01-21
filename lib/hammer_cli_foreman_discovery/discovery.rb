require 'hammer_cli'
require 'hammer_cli_foreman'
module HammerCLIForemanDiscovery

  class DiscoveredHost < HammerCLIForeman::Command

    resource :discovered_hosts

    class ListCommand < HammerCLIForeman::ListCommand
      output do
        field :id, _("ID")
        field :name, _("Name")
        field :mac, _("MAC")
        field :last_report, _('Last report'), Fields::Date
        field nil, _("Subnet"), Fields::SingleReference, :key => :subnet
        field nil, _("Organization"), Fields::SingleReference, :key => :organization
        field nil, _("Location"), Fields::SingleReference, :key => :location
      end

      build_options
    end

    class InfoCommand < HammerCLIForeman::InfoCommand
      output ListCommand.output_definition do
        field :ip, _('IP')
        field :model, _('Model')
        field :facts_hash, _('Facts')
      end

      build_options
    end

    class ProvisionCommand < HammerCLIForeman::UpdateCommand
      command_name "provision"

      success_message _("Host created")
      failure_message _("Could not create the host")

      def self.build_options
        option "--partition-table-id", "PARTITION_TABLE_ID", " "
        option "--root-password", "ROOT_PW", " "
        option "--ask-root-password", "ASK_ROOT_PW", " ",
                    :format => HammerCLI::Options::Normalizers::Bool.new
        option "--puppetclass-ids", "PUPPETCLASS_IDS", " ",
                    :format => HammerCLI::Options::Normalizers::List.new

        bool_format           = {}
        bool_format[:format] = HammerCLI::Options::Normalizers::Bool.new
        option "--managed", "MANAGED", " ", bool_format
        bool_format[:format] = HammerCLI::Options::Normalizers::Bool.new
        option "--build", "BUILD", " ", bool_format
        bool_format[:format] = HammerCLI::Options::Normalizers::Bool.new
        option "--enabled", "ENABLED", " ", bool_format

        option "--parameters", "PARAMS", _("Host parameters"),
                    :format => HammerCLI::Options::Normalizers::KeyValueList.new
        option "--interface", "INTERFACE", _("Interface parameters"), :multivalued => true,
                    :format => HammerCLI::Options::Normalizers::KeyValueList.new
        option "--provision-method", "METHOD", " ",
                    :format => HammerCLI::Options::Normalizers::Enum.new(['build', 'image'])

        super :without => [:root_pass, :ptable_id, :puppet_class_ids]
      end

      def ask_password
        prompt = _("Enter the root password for the host:") + '_'
        ask(prompt) { |q| q.echo = false }
      end

      def request_params
        params = super

        params['discovered_host']['ptable_id'] = option_partition_table_id unless option_partition_table_id.nil?
        params['discovered_host']['root_pass'] = option_root_password unless option_root_password.nil?

        if option_ask_root_password
          params['discovered_host']['root_pass'] = ask_password
        end

        params
      end

      build_options
    end

    class RebootCommand < HammerCLIForeman::SingleResourceCommand
      action :reboot
      command_name "reboot"
      desc _("Reboot a host")
      success_message _("Host reboot started")
      failure_message _("Could not reboot the host")

      build_options
    end

    class RefreshFactsCommand < HammerCLIForeman::SingleResourceCommand
      action :refresh_facts
      command_name "refresh_facts"
      desc _("Refresh the facts of a host")
      success_message _("Host facts refreshed")
      failure_message _("Could not refresh the facts of the host")

      build_options
    end

    autoload_subcommands
  end

  HammerCLI::MainCommand.subcommand 'discovery', _("Discovery related actions."), DiscoveredHost
end
