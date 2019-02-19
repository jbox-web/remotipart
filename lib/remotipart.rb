# frozen_string_literal: true

require 'zeitwerk'
Zeitwerk::Loader.for_gem.setup

module Remotipart
  require 'remotipart/engine' if defined?(Rails)
end
