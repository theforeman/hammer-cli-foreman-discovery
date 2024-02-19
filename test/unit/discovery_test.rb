# using this before the require so test_helper resolves the correct foreman_api.json to use
ENV['TEST_API_VERSION'] = '2.4'

require File.join(Gem.loaded_specs['hammer_cli_foreman'].full_gem_path, 'test/unit/test_helper')
require File.join(File.dirname(__FILE__), 'discovery_resource_mock')
require 'hammer_cli_foreman_discovery/discovery'

describe HammerCLIForemanDiscovery::DiscoveredHost do

  include CommandTestHelper

  describe "ListCommand" do
    let(:cmd) { HammerCLIForemanDiscovery::DiscoveredHost::ListCommand.new("", ctx) }

    before :each do
      DiscoveryResourceMock.discovered_hosts_index
    end

    describe "parameters" do
      it_should_accept "no arguments"
      it_should_accept_search_params
    end

    describe "output" do
      let(:expected_record_count) { cmd.resource.call(:index).length }
      it_should_print_n_records
      it_should_print_columns ["ID", "Name", "MAC", "Last report", "Subnet", "CPUs", "Memory", "Disk count", "Disks size"]
    end
  end

  describe "InfoCommand" do

    let(:cmd) { HammerCLIForemanDiscovery::DiscoveredHost::InfoCommand.new("", ctx) }

    before :each do
      cmd.stubs(:get_parameters).returns([])
    end

    describe "parameters" do
      it_should_accept "id", ["--id=1"]
      it_should_accept "name", ["--name=host"]
    end

    describe "output" do
      with_params ["--id=1"] do
        it_should_print_n_records 1
        it_should_print_columns ["ID", "Name", "MAC", "Last report", "Subnet", "CPUs", "Memory", "Disk count", "Disks size", "Organization", "Location"]
        it_should_print_columns ["IP", "Model"]
      end
    end

  end

  describe "DeleteCommand" do

    let(:cmd) { HammerCLIForemanDiscovery::DiscoveredHost::DeleteCommand.new("", ctx) }

    describe "parameters" do
      it_should_accept "name", ["--name=host"]
      it_should_accept "id", ["--id=1"]
    end

  end

  describe "ProvisionCommand" do
    let(:cmd) { HammerCLIForemanDiscovery::DiscoveredHost::ProvisionCommand.new("", ctx) }

    describe "parameters" do
      it_should_accept "name, architecture_id, domain_id, operatingsystem_id and more",
                       ["--name=host", "--architecture-id=1", "--domain-id=1", "--operatingsystem-id=1",
                        "--ip=1.2.3.4", "--mac=11:22:33:44:55:66", "--medium-id=1", "--partition-table-id=1", "--subnet-id=1",
                        "--sp-subnet-id=1", "--model-id=1", "--hostgroup-id=1", "--owner-id=1",
                        "--root-password=pwd", "--ask-root-password=false", "--provision-method=build"]

      with_params ["--name=host", "--architecture-id=1", "--domain-id=1", "--operatingsystem-id=1",
                   "--ip=1.2.3.4", "--mac=11:22:33:44:55:66", "--medium-id=1", "--partition-table-id=1", "--subnet-id=1",
                   "--sp-subnet-id=1", "--model-id=1", "--hostgroup-id=1", "--owner-id=1",
                   "--root-password=pwd", "--ask-root-password=false", "--provision-method=build", "--managed=true", "--build=true", "--enabled=true"] do
        it_should_call_action_and_test_params(:update) { |par| par["discovered_host"]["managed"] == true }
        it_should_call_action_and_test_params(:update) { |par| par["discovered_host"]["build"] == true }
        it_should_call_action_and_test_params(:update) { |par| par["discovered_host"]["enabled"] == true }
        it_should_call_action_and_test_params(:update) { |par| par["discovered_host"]["provision_method"] == "build" }
      end
    end
  end

  describe "AutoProvisionCommand" do

    let(:cmd) { HammerCLIForemanDiscovery::DiscoveredHost::AutoProvisionCommand.new("", ctx) }

    describe "parameters" do
      it_should_accept "name", ["--name=host"]
      it_should_accept "id", ["--id=1"]
    end

  end

  describe "RebootCommand" do
    let(:cmd) { HammerCLIForemanDiscovery::DiscoveredHost::RebootCommand.new("", ctx) }
    describe "parameters" do
      it_should_accept "name", ["--name=host"]
      it_should_accept "id", ["--id=1"]
    end
  end

  describe "RefreshFactsCommand" do
    let(:cmd) { HammerCLIForemanDiscovery::DiscoveredHost::RefreshFactsCommand.new("", ctx) }

    describe "parameters" do
      it_should_accept "name", ["--name=host"]
      it_should_accept "id", ["--id=1"]
    end
  end

  describe "FactsCommand" do

    let(:cmd) { HammerCLIForemanDiscovery::DiscoveredHost::FactsCommand.new("", ctx) }

    before(:each) do
      DiscoveryResourceMock.facts_index
    end

    describe "parameters" do
      it_should_accept "name", ["--name=mac52540068f9d6"]
      it_should_accept "id", ["--id=1"]
    end

    describe "output" do
      with_params ["--name=mac52540068f9d6"] do
        it_should_print_column "Fact"
        it_should_print_column "Value"
      end
    end
  end

end
