# frozen_string_literal: true

module Remotipart
  module ViewHelper

    # No longer used
    # Retrained to prevent issues while updating
    def remotipart_response(_options = {}, &block)
      with_output_buffer(&block)
    end

  end
end
