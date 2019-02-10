# frozen_string_literal: true

module Remotipart
  require 'remotipart/view_helper'
  require 'remotipart/request_helper'
  require 'remotipart/render_overrides'
  require 'remotipart/middleware'
  require 'remotipart/rails' if defined?(Rails)
end
