# frozen_string_literal: true

ENV['TEST_API_VERSION'] = '2.4'

require File.join(Gem.loaded_specs['hammer_cli_foreman'].full_gem_path, 'test/unit/test_helper')
require 'hammer_cli_foreman_discovery/subnet_extensions'

describe HammerCLIForemanDiscovery::SubnetExtensions do
  let(:definition) { HammerCLIForeman::Subnet::InfoCommand.output_definition }
  let(:subnet) do
    {
      'name' => 'subnet',
      'dhcp' => { 'id' => 1, 'name' => 'proxy.example.com', 'url' => 'https://proxy.example.com:9090' },
      'discovery' => { 'id' => 2, 'name' => 'discovery.example.com', 'url' => 'https://discovery.example.com:9090' },
    }
  end

  it 'adds the discovery proxy to the smart proxies of subnet info' do
    assert_includes definition.at('Smart Proxies').fields.map(&:label), 'Discovery'
  end

  it 'prints the discovery proxy' do
    out, = capture_io do
      HammerCLI::Output::Output.new({}, default_adapter: :base).print_record(definition, subnet)
    end
    assert_includes out, "    Discovery: discovery.example.com (https://discovery.example.com:9090)\n"
  end
end
