module HammerCLIForemanDiscovery
  module CommandExtensions
    class ProvisionWithPuppet < HammerCLI::CommandExtensions
      option_family(
        format: HammerCLI::Options::Normalizers::List.new,
        aliased_resource: 'puppet-class',
        description: 'Names/Ids of associated Puppet classes'
      ) do
        parent '--puppet-class-ids', 'PUPPET_CLASS_IDS', _('List of Puppet class ids'),
               attribute_name: :option_puppetclass_ids
        child '--puppet-classes', 'PUPPET_CLASS_NAMES', '',
              attribute_name: :option_puppetclass_names
      end

      # TODO: Until the API is cleaned up
      option_family(
        aliased_resource: 'environment',
        description: _('Puppet environment. Required if host is managed and value is not inherited from host group'),
        deprecation: _("Use %s instead") % '--puppet-environment[-id]',
        deprecated: { '--environment' => _("Use %s instead") % '--puppet-environment[-id]',
                      '--environment-id' => _("Use %s instead") % '--puppet-environment[-id]' }
      ) do
        parent '--environment-id', 'ENVIRONMENT_ID', _(''),
               format: HammerCLI::Options::Normalizers::Number.new,
               attribute_name: :option_environment_id
        child '--environment', 'ENVIRONMENT_NAME', _('Environment name'),
              attribute_name: :option_environment_name
      end

      option_family(
        aliased_resource: 'puppet_proxy'
      ) do
        parent '--puppet-proxy-id', 'PUPPET_PROXY_ID', _(''),
               format: HammerCLI::Options::Normalizers::Number.new,
               attribute_name: :option_puppet_proxy_id
      end
      option_family(
        aliased_resource: 'puppet_ca_proxy'
      ) do
        parent '--puppet-ca-proxy-id', 'PUPPET_CA_PROXY_ID', _(''),
               format: HammerCLI::Options::Normalizers::Number.new,
               attribute_name: :option_puppet_ca_proxy_id
      end

      request_params do |params, command_object|
        if command_object.option_puppet_proxy
          params['discovered_host']['puppet_proxy_id'] ||= HammerCLIForemanPuppet::CommandExtensions::HostPuppetProxy.proxy_id(
            command_object.resolver, command_object.option_puppet_proxy
          )
        end
        if command_object.option_puppet_ca_proxy
          params['discovered_host']['puppet_ca_proxy_id'] ||= HammerCLIForemanPuppet::CommandExtensions::HostPuppetProxy.proxy_id(
            command_object.resolver, command_object.option_puppet_ca_proxy
          )
        end
        if command_object.option_puppetclass_ids
          params['discovered_host']['puppet_attributes'] ||= {}
          params['discovered_host']['puppet_attributes']['puppetclass_ids'] ||= command_object.option_puppetclass_ids
        end
        if command_object.option_puppetclass_names
          params['discovered_host']['puppet_attributes'] ||= {}
          params['discovered_host']['puppet_attributes']['puppetclass_ids'] ||= command_object.resolver.puppetclass_ids(
            'option_names' => command_object.option_puppetclass_names
          )
        end
        if params['discovered_host']['environment_id']
          params['discovered_host']['puppet_attributes'] ||= {}
          params['discovered_host']['puppet_attributes']['environment_id'] = params['discovered_host'].delete('environment_id')
        end
      end
    end
  end
end
