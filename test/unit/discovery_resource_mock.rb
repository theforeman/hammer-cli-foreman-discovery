require File.join(Gem.loaded_specs['hammer_cli_foreman'].full_gem_path, 'test/unit/apipie_resource_mock')

module DiscoveryResourceMock

  def self.discovered_hosts_index
    ResourceMocks.mock_action_call(:discovered_hosts, :index, [ { } ])
  end

  def self.discovered_hosts_show
    ResourceMocks.mock_action_calls(
        [:discovered_hosts, :index, [{ "id" => 2, "name" => "mac52540068f9d6" }]],
        [:discovered_hosts, :show, { "id" => 2, "name" => "mac52540068f9d6" }]
    )
  end
end
