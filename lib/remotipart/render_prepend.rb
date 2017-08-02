module Remotipart
  # Responder used to automagically wrap any non-xml replies in a text-area
  # as expected by iframe-transport.
  module RenderPrepend
    include ERB::Util

    def render *args
      super(*args)
      if remotipart_submitted?
        textarea_body = response.content_type == 'text/html' ? html_escape(response.body) : response.body
        response.body = %{<script type=\"text/javascript\">try{window.parent.document;}catch(err){document.domain=document.domain;}</script> <textarea data-type=\"#{response.content_type}\" data-status=\"#{response.response_code}\" data-statusText=\"#{response.message}\">#{textarea_body}</textarea>}
        response.content_type = ::Rails.version >= '5' ? Mime[:html] : Mime::HTML
      end
      response_body
    end
  end
end
