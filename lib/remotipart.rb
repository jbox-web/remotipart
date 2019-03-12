# frozen_string_literal: true

require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.setup

module Remotipart
  require 'remotipart/engine' if defined?(Rails)
end
