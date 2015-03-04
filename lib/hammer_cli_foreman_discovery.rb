module HammerCLIForemanDiscovery
  require 'hammer_cli_foreman_discovery/version'

  begin
    require 'hammer_cli_foreman_discovery/discovery_references'

    HammerCLI::MainCommand.lazy_subcommand('discovery', _("Manipulate discovered hosts."),
                                           'HammerCLIForemanDiscovery::DiscoveredHost', 'hammer_cli_foreman_discovery/discovery'
    )

    HammerCLI::MainCommand.lazy_subcommand('discovery_rule', _("Manipulate discovered rules."),
                                           'HammerCLIForemanDiscovery::DiscoveryRule', 'hammer_cli_foreman_discovery/discovery_rule'
    )

  rescue => e
    handler = HammerCLIForeman::ExceptionHandler.new(:context => {}, :adapter => :base)
    handler.handle_exception(e)
    raise HammerCLI::ModuleLoadingError.new(e)
  end
end
