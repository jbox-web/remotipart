# frozen_string_literal: true

module Remotipart
  class Engine < ::Rails::Engine

    initializer 'remotipart.view_helper' do
      ActiveSupport.on_load(:action_view) do
        include Remotipart::RequestHelper
        include Remotipart::ViewHelper
      end
    end

    initializer 'remotipart.controller_helper' do
      ActiveSupport.on_load(:action_controller) do
        include Remotipart::RequestHelper
        include Remotipart::RenderOverrides
      end
    end

    initializer 'remotipart.include_middleware' do
      # Rails 5 no longer instantiates ActionDispatch::ParamsParser
      # https://github.com/rails/rails/commit/a1ced8b52ce60d0634e65aa36cb89f015f9f543d
      config.app_middleware.use Middleware
    end

  end
end
