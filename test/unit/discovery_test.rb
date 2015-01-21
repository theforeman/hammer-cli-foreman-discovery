# using this before the require so test_helper resolves the correct foreman_api.json to use
ENV['TEST_API_VERSION'] = '1.7'

require File.join(Gem.loaded_specs['hammer_cli_foreman'].full_gem_path, 'test/unit/test_helper')
require File.join(File.dirname(__FILE__), 'discovery_resource_mock')
require 'hammer_cli_foreman_discovery/discovery'

describe HammerCLIForemanDiscovery::DiscoveredHost do

  include CommandTestHelper

  context "ListCommand" do
    let(:cmd) { HammerCLIForemanDiscovery::DiscoveredHost::ListCommand.new("", ctx) }

    before :each do
      DiscoveryResourceMock.discovered_hosts_index
    end

    context "parameters" do
      it_should_accept "no arguments"
      it_should_accept_search_params
    end

    context "output" do
      let(:expected_record_count) { cmd.resource.call(:index).length }

      it_should_print_n_records
      it_should_print_columns ["ID", "Name", "MAC", "Last report", "Subnet", "Organization", "Location"]
    end
  end

  context "InfoCommand" do

    let(:cmd) { HammerCLIForemanDiscovery::DiscoveredHost::InfoCommand.new("", ctx) }

    before :each do
      cmd.stubs(:get_parameters).returns([])
    end

    context "parameters" do
      it_should_accept "id", ["--id=1"]
      it_should_accept "name", ["--name=host"]
    end

    context "output" do
      with_params ["--id=1"] do
        it_should_print_n_records 1
        it_should_print_columns ["ID", "Name", "MAC", "Last report", "Subnet", "Organization", "Location"]

        it_should_print_columns ["IP", "Model", "Facts"]
      end
    end

  end

  context "ProvisionCommand" do
    let(:cmd) { HammerCLIForemanDiscovery::DiscoveredHost::ProvisionCommand.new("", ctx) }

    context "parameters" do
      it_should_accept "name, environment_id, architecture_id, domain_id, puppet_proxy_id, operatingsystem_id and more",
                       ["--name=host", "--environment-id=1", "--architecture-id=1", "--domain-id=1", "--puppet-proxy-id=1", "--operatingsystem-id=1",
                        "--ip=1.2.3.4", "--mac=11:22:33:44:55:66", "--medium-id=1", "--partition-table-id=1", "--subnet-id=1",
                        "--sp-subnet-id=1", "--model-id=1", "--hostgroup-id=1", "--owner-id=1", '--puppet-ca-proxy-id=1', '--puppetclass-ids',
                        "--root-password=pwd", "--ask-root-password=false", "--provision-method=build"]

      with_params ["--name=host", "--environment-id=1", "--architecture-id=1", "--domain-id=1", "--puppet-proxy-id=1", "--operatingsystem-id=1",
                   "--ip=1.2.3.4", "--mac=11:22:33:44:55:66", "--medium-id=1", "--partition-table-id=1", "--subnet-id=1",
                   "--sp-subnet-id=1", "--model-id=1", "--hostgroup-id=1", "--owner-id=1", '--puppet-ca-proxy-id=1', '--puppetclass-ids',
                   "--root-password=pwd", "--ask-root-password=false", "--provision-method=build", "--managed=true", "--build=true", "--enabled=true"] do
        it_should_call_action_and_test_params(:update) { |par| par["discovered_host"]["managed"] == true }
        it_should_call_action_and_test_params(:update) { |par| par["discovered_host"]["build"] == true }
        it_should_call_action_and_test_params(:update) { |par| par["discovered_host"]["enabled"] == true }
        it_should_call_action_and_test_params(:update) { |par| par["discovered_host"]["provision_method"] == "build" }
      end
    end
  end

  context "RebootCommand" do
    let(:cmd) { HammerCLIForemanDiscovery::DiscoveredHost::RebootCommand.new("", ctx) }
    context "parameters" do
      it_should_accept "name", ["--name=host"]
      it_should_accept "id", ["--id=1"]
    end
  end

  context "RefreshFactsCommand" do
    let(:cmd) { HammerCLIForemanDiscovery::DiscoveredHost::RefreshFactsCommand.new("", ctx) }

    context "parameters" do
      it_should_accept "name", ["--name=host"]
      it_should_accept "id", ["--id=1"]
    end
  end

end
