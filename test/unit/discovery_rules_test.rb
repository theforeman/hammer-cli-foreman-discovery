# using this before the require so test_helper resolves the correct foreman_api.json to use
ENV['TEST_API_VERSION'] = '2.4'

require File.join(Gem.loaded_specs['hammer_cli_foreman'].full_gem_path, 'test/unit/test_helper')
require File.join(File.dirname(__FILE__), 'discovery_resource_mock')
require 'hammer_cli_foreman_discovery/discovery_rule'

describe HammerCLIForemanDiscovery::DiscoveryRule do

  include CommandTestHelper

  context "ListCommand" do
    let(:cmd) { HammerCLIForemanDiscovery::DiscoveryRule::ListCommand.new("", ctx) }

    before :each do
      DiscoveryResourceMock.discovery_rules_index
    end

    context "parameters" do
      it_should_accept "no arguments"
      it_should_accept_search_params
    end

    context "output" do
      let(:expected_record_count) { cmd.resource.call(:index).length }
      it_should_print_n_records
      it_should_print_columns ["ID", "Name", "Priority", "Search", "Host Group", "Hosts Limit", "Enabled"]
    end
  end

  context "InfoCommand" do

    let(:cmd) { HammerCLIForemanDiscovery::DiscoveryRule::InfoCommand.new("", ctx) }

    before :each do
      cmd.stubs(:get_parameters).returns([])
    end

    context "parameters" do
      it_should_accept "id", ["--id=1"]
      it_should_accept "name", ["--name=rule"]
    end

    context "output" do
      with_params ["--id=1"] do
        it_should_print_n_records 1
        it_should_print_columns ["ID", "Name", "Priority", "Search", "Host Group", "Hosts Limit", "Enabled", "Hostname template", "Hosts", "Locations", "Organizations"]
      end
    end

  end

  context "DeleteCommand" do

    let(:cmd) { HammerCLIForemanDiscovery::DiscoveryRule::DeleteCommand.new("", ctx) }

    context "parameters" do
      it_should_accept "name", ["--name=rule"]
      it_should_accept "id", ["--id=1"]
    end

  end

  context "CreateCommand" do

    let(:cmd) { HammerCLIForemanDiscovery::DiscoveryRule::CreateCommand.new("", ctx) }

    context "parameters" do
      it_should_accept "name, priority, search, hostgroup, hostgroup-id, hosts-limit, locations, organizations and enabled",
                       ["--name=rule", "--priority=1", "--search='cpu_count > 1'",
                        "--hostgroup='test'", "--hostgroup-id=1", "--hosts-limit=1",
                        "--enabled=true", "--organization-ids=1", "--location-ids=1"]
      it_should_fail_with "Error: Could not find hostgroup, please set one of options --hostgroup, --hostgroup-id",
                          ["--priority=1", "--search=cpu_count > 1", "--hosts-limit=1", "--enabled=false"]

      it_should_accept "only hostgroup, name, search, location-ids, organization-ids and priority",
                       ["--hostgroup=example", "--name=rule", "--priority=1", "--search='cpu_count > 1'",
                        "--location-ids=1", "--organization-ids=1"]

      with_params ["--name=rule", "--priority=1", "--search=cpu_count > 1"] do
        it_should_call_action_and_test_params(:create) { |par| par["discovery_rule"]["priority"] == 1 }
        it_should_call_action_and_test_params(:create) { |par| par["discovery_rule"]["search"] == "cpu_count > 1" }
      end
    end
  end

  context "UpdateCommand" do

    let(:cmd) { HammerCLIForemanDiscovery::DiscoveryRule::UpdateCommand.new("", ctx) }

    context "parameters" do
      it_should_accept "id, name, priority, search, hostgroup, hostgroup-id, hosts-limit and enabled",
                       ["--id=1", "--name=rule", "--priority=1", "--search=cpu_count > 1", "--hostgroup='test'", "--hostgroup-id=1", "--hosts-limit=1", "--enabled=true"]
      it_should_accept "name", ["--name=rule", "--new-name=rule2"]
      it_should_accept "only hostgroup, name, search and priority", ["--hostgroup=example", "--name=rule", "--priority=1", "--search=cpu_count > 1"]

      with_params ["--name=rule", "--priority=5", "--search=cpu_count <>> 1", "--hostgroup='test'", "--hostgroup-id=1", "--hosts-limit=1", "--enabled=true"] do
        it_should_call_action_and_test_params(:update) { |par| par["discovery_rule"]["name"] == "rule" }
        it_should_call_action_and_test_params(:update) { |par| par["discovery_rule"]["priority"] == 5 }
        it_should_call_action_and_test_params(:update) { |par| par["discovery_rule"]["search"] == "cpu_count <>> 1" }
      end
    end
  end

end
