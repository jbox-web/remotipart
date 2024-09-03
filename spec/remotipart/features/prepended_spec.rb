# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'prepended', type: :feature do
  context 'when another library overrides #render using prepend' do
    it 'does not break' do
      expect { visit prepended_path }.to_not raise_error
    end
  end
end
