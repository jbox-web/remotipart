# frozen_string_literal: true

module Remotipart
  module Rails
    class Engine < ::Rails::Engine

      initializer 'remotipart.view_helper' do
        ActionView::Base.send :include, RequestHelper
        ActionView::Base.send :include, ViewHelper
      end

      initializer 'remotipart.controller_helper' do
        ActionController::Base.send :include, RequestHelper
        ActionController::Base.send :include, RenderOverrides
      end

      initializer 'remotipart.include_middleware' do
        # Rails 5 no longer instantiates ActionDispatch::ParamsParser
        # https://github.com/rails/rails/commit/a1ced8b52ce60d0634e65aa36cb89f015f9f543d
        config.app_middleware.use Middleware
      end

    end
  end
end
