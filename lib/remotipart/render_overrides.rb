module Remotipart
  # Responder used to automagically wrap any non-xml replies in a text-area
  # as expected by iframe-transport.
  module RenderOverrides
    include ERB::Util

    def self.included(base)
      base.class_eval do
        alias_method_chain :render, :remotipart
      end
    end

    def render_with_remotipart *args
      render_without_remotipart *args
      if remotipart_submitted?
        response.body = %{<textarea data-type=\"#{response.content_type}\" data-status=\"#{response.response_code}\" data-statusText=\"#{response.message}\">#{html_escape(response.body)}</textarea>}
        response.content_type = Mime::HTML
      end
      response_body
    end
  end
end
