require 'hammer_cli'
require 'hammer_cli_foreman'
require 'hammer_cli_foreman/fact'

module HammerCLIForemanDiscovery
  def self.exception_handler_class
       HammerCLIForeman::ExceptionHandler
  end

  class DiscoveredHost < HammerCLIForeman::Command

    resource :discovered_hosts

    class ListCommand < HammerCLIForeman::ListCommand
      output do
        field :id, _("ID")
        field :name, _("Name")
        field :mac, _("MAC")
        field :cpus, _('CPUs')
        field :memory, _('Memory')
        field :disk_count, _('Disk count')
        field :disks_size, _('Disks size')
        field nil, _("Subnet"), Fields::SingleReference, :key => :subnet
        field :last_report, _('Last report'), Fields::Date
      end

      build_options
    end

    class InfoCommand < HammerCLIForeman::InfoCommand
      output ListCommand.output_definition do
        field :ip, _('IP')
        field :model_name, _('Model')
        field nil, _("Organization"), Fields::SingleReference, :key => :organization
        field nil, _("Location"), Fields::SingleReference, :key => :location
      end

      build_options
    end


    class FactsCommand < HammerCLIForeman::AssociatedResourceListCommand
      command_name "facts"
      resource :fact_values, :index
      parent_resource :discovered_hosts

      output do
        field :fact, _("Fact")
        field :value, _("Value")
      end

      def send_request
        HammerCLIForeman::Fact::ListCommand.unhash_facts(super)
      end

      def request_params
        params = super
        params['host_id'] = params.delete('discovered_host_id')
        params
      end

      build_options
    end

    class DeleteCommand < HammerCLIForeman::DeleteCommand
      success_message _("Host deleted")
      failure_message _("Could not delete the host")

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
        bool_format[:format] = HammerCLI::Options::Normalizers::Bool.new
        option "--overwrite", "OVERWRITE", " ", bool_format

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

        params['discovered_host']['host_parameters_attributes'] = parameter_attributes
        params['discovered_host']['ptable_id'] = option_partition_table_id unless option_partition_table_id.nil?
        params['discovered_host']['root_pass'] = option_root_password unless option_root_password.nil?
        params['discovered_host']['overwrite'] = option_overwrite unless option_overwrite.nil?

        if option_ask_root_password
          params['discovered_host']['root_pass'] = ask_password
        end

        params
      end

      def parameter_attributes
        return {} unless option_parameters
        option_parameters.collect do |key, value|
          if value.is_a? String
            {"name"=>key, "value"=>value}
          else
            {"name"=>key, "value"=>value.inspect}
          end
        end
      end

      build_options
    end

    class AutoProvisionCommand < HammerCLIForeman::SingleResourceCommand
      action :auto_provision
      command_name "auto-provision"
      desc _("Auto provision a host")
      success_message _("Host created")
      failure_message _("Could not create the host")

      build_options
    end

    class RebootCommand < HammerCLIForeman::SingleResourceCommand
      action :reboot
      command_name "reboot"
      desc _("Reboot a host")

      option '--all', :flag, _("Reboot all discovered hosts")

      def execute
        if option_all?
          begin
            resource.call(:reboot_all, {})
            if success_message
              print_message(success_message)
              HammerCLI::EX_OK
            end
          rescue RestClient::UnprocessableEntity => error
            response = JSON.parse(error.response)
            response = HammerCLIForeman.record_to_common_format(response) unless response.has_key?('message')
            output.print_error(response['host_details'].map {|i| i['name'] + ": " + i['error'] }.join("\n"))
            HammerCLI::EX_DATAERR
          end
        else
          super
        end
      end

      success_message _("Host reboot started")
      failure_message _("Could not reboot the host")

      build_options
    end

    class RefreshFactsCommand < HammerCLIForeman::SingleResourceCommand
      action :refresh_facts
      command_name "refresh-facts"
      desc _("Refresh the facts of a host")
      success_message _("Host facts refreshed")
      failure_message _("Could not refresh the facts of the host")

      build_options
    end
    autoload_subcommands
  end

end
