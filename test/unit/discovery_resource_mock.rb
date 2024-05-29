# frozen_string_literal: true

require File.join(Gem.loaded_specs['hammer_cli_foreman'].full_gem_path, 'test/unit/apipie_resource_mock')

module DiscoveryResourceMock
  def self.discovered_hosts_index
    ResourceMocks.mock_action_call(:discovered_hosts, :index, [{}])
  end

  def self.discovered_hosts_show
    ResourceMocks.mock_action_calls(
      [:discovered_hosts, :index, [{ "id" => 2, "name" => "mac52540068f9d6" }]],
      [:discovered_hosts, :show, { "id" => 2, "name" => "mac52540068f9d6" }]
    )
  end

  def self.facts_index
    ResourceMocks.mock_action_call(:fact_values, :index, {
                                     "total" => 5604,
                                     "subtotal" => 0,
                                     "page" => 1,
                                     "per_page" => 20,
                                     "search" => "",
                                     "sort" => {
                                       "by" => nil,
                                       "order" => nil,
                                     },
                                     "results" => [{
                                       "some.host.com" => {
                                         "network_br180" => "10.32.83.0",
                                         "mtu_usb0" => "1500",
                                         "physicalprocessorcount" => "1",
                                         "rubyversion" => "1.8.7",
                                       },
                                     }],
                                   })
  end

  def self.discovery_rules_index
    ResourceMocks.mock_action_call(:discovery_rules, :index, [{}])
  end

  def self.discovery_rules_show
    ResourceMocks.mock_action_calls(
      [:discovery_rules, :index, [{ "id" => 2, "name" => "rule_two" }]],
      [:discovery_rules, :show, { "id" => 2, "name" => "rule_2" }]
    )
  end
end
