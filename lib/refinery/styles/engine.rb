module Refinery
  module Style
    class Engine < Rails::Engine
      include Refinery::Engine
      isolate_namespace Refinery::Style

      engine_name :refinery_styles

      initializer "register refinerycms_styles plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.name = "styles"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.style_admin_games_path }
          plugin.pathname = root
          plugin.activity = {
            :class_name => :'refinery/style/game',
            :title => 'name'
          }
          plugin.menu_match = %r{refinery/style(/.*)?$}
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Styles)
      end
    end
  end
end
