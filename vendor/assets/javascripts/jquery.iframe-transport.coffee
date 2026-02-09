# This [jQuery](https://jquery.com/) plugin implements an `<iframe>`
# [transport](https://api.jquery.com/jQuery.ajax/#extending-ajax) so that
# `$.ajax()` calls support the uploading of files using standard HTML file
# input fields. This is done by switching the exchange from `XMLHttpRequest`
# to a hidden `iframe` element containing a form that is submitted.
# The [source for the plugin](https://github.com/cmlenz/jquery-iframe-transport)
# is available on [Github](https://github.com/) and licensed under the [MIT
# license](https://github.com/cmlenz/jquery-iframe-transport/blob/master/LICENSE).
# ## Usage
# To use this plugin, you simply add an `iframe` option with the value `true`
# to the Ajax settings an `$.ajax()` call, and specify the file fields to
# include in the submssion using the `files` option, which can be a selector,
# jQuery object, or a list of DOM elements containing one or more
# `<input type="file">` elements:
#     $("#myform").submit(function() {
#         $.ajax(this.action, {
#             files: $(":file", this),
#             iframe: true
#         }).complete(function(data) {
#             console.log(data);
#         });
#     });
# The plugin will construct hidden `<iframe>` and `<form>` elements, add the
# file field(s) to that form, submit the form, and process the response.
# If you want to include other form fields in the form submission, include
# them in the `data` option, and set the `processData` option to `false`:
#     $("#myform").submit(function() {
#         $.ajax(this.action, {
#             data: $(":text", this).serializeArray(),
#             files: $(":file", this),
#             iframe: true,
#             processData: false
#         }).complete(function(data) {
#             console.log(data);
#         });
#     });
# ### Response Data Types
# As the transport does not have access to the HTTP headers of the server
# response, it is not as simple to make use of the automatic content type
# detection provided by jQuery as with regular XHR. If you can't set the
# expected response data type (for example because it may vary depending on
# the outcome of processing by the server), you will need to employ a
# workaround on the server side: Send back an HTML document containing just a
# `<textarea>` element with a `data-type` attribute that specifies the MIME
# type, and put the actual payload in the textarea:
#     <textarea data-type="application/json">
#       {"ok": true, "message": "Thanks so much"}
#     </textarea>
# The iframe transport plugin will detect this and pass the value of the
# `data-type` attribute on to jQuery as if it was the "Content-Type" response
# header, thereby enabling the same kind of conversions that jQuery applies
# to regular responses. For the example above you should get a Javascript
# object as the `data` parameter of the `complete` callback, with the
# properties `ok: true` and `message: "Thanks so much"`.
# ### Handling Server Errors
# Another problem with using an `iframe` for file uploads is that it is
# impossible for the javascript code to determine the HTTP status code of the
# servers response. Effectively, all of the calls you make will look like they
# are getting successful responses, and thus invoke the `done()` or
# `complete()` callbacks. You can only communicate problems using the content
# of the response payload. For example, consider using a JSON response such as
# the following to indicate a problem with an uploaded file:
#     <textarea data-type="application/json">
#       {"ok": false, "message": "Please only upload reasonably sized files."}
#     </textarea>
# ### Compatibility
# This plugin has primarily been tested on Safari 5 (or later), Firefox 4 (or
# later), and Internet Explorer (all the way back to version 6). While I
# haven't found any issues with it so far, I'm fairly sure it still doesn't
# work around all the quirks in all different browsers. But the code is still
# pretty simple overall, so you should be able to fix it and contribute a
# patch :)
# ## Annotated Source

# coffeelint: disable=max_line_length

((factory) ->
  'use strict'

  if typeof define == 'function' and define.amd
    # AMD. Register as an anonymous module.
    define ['jquery'], factory

  else if typeof module == 'object' and module.exports
    # Node/CommonJS
    module.exports = (root, jQuery) ->
      if jQuery == undefined
        # require('jQuery') returns a factory that requires window to
        # build a jQuery instance, we normalize how we use modules
        # that require this pattern but the window provided is a noop
        # if it's defined (how jquery works)
        if typeof window != 'undefined'
          jQuery = require('jquery')
        else
          jQuery = require('jquery')(root)
      factory(jQuery)

  else
    # Browser globals
    factory(jQuery)

) ($) ->
  'use strict'

  # Register a prefilter that checks whether the `iframe` option is set, and
  # switches to the "iframe" data type if it is `true`.
  $.ajaxPrefilter (options, _origOptions, _jqXHR) ->
    if options.iframe
      options.originalURL = options.url
      return 'remotipart.iframe'

  # Register a transport for the "iframe" data type. It will only activate
  # when the "files" option has been set to a non-empty list of enabled file
  # inputs.
  $.ajaxTransport 'remotipart.iframe', (options, origOptions, _jqXHR) ->
    form    = null
    iframe  = null
    name    = 'iframe-' + $.now()
    files   = $(options.files).filter(':file:enabled')
    accepts = null

    # Remove "iframe" from the data types list so that further processing is
    # based on the content type returned by the server, without attempting an
    # (unsupported) conversion from "iframe" to the actual type.
    # This function gets called after a successful submission or an abortion
    # and should revert all changes made to the page to enable the
    # submission via this transport.

    cleanUp = ->
      files.each (i, file) ->
        $file = $(file)
        $file.data('clone').replaceWith $file
        return
      form.remove()
      iframe.one 'load', ->
        iframe.remove()
        return
      iframe.attr 'src', 'about:blank'
      return

    options.dataTypes.shift()

    # Use the data from the original AJAX options, as it doesn't seem to be
    # copied over since jQuery 1.7.
    # See https://github.com/cmlenz/jquery-iframe-transport/issues/6
    options.data = origOptions.data

    if files.length
      form = $('<form enctype=\'multipart/form-data\' method=\'post\'></form>').hide().attr(action: options.originalURL, target: name)

      # If there is any additional data specified via the `data` option,
      # we add it as hidden fields to the form. This (currently) requires
      # the `processData` option to be set to false so that the data doesn't
      # get serialized to a string.
      if typeof options.data == 'string' and options.data.length > 0
        $.error 'data must not be serialized'

      $.each options.data or {}, (name, value) ->
        if $.isPlainObject(value)
          name  = value.name
          value = value.value
        $('<input type=\'hidden\' />').attr(name: name, value: value).appendTo(form)

      # Add a hidden `X-Requested-With` field with the value `IFrame` to the
      # field, to help server-side code to determine that the upload happened
      # through this transport.
      $('<input type=\'hidden\' value=\'IFrame\' name=\'X-Requested-With\' />').appendTo(form)

      # Borrowed straight from the JQuery source.
      # Provides a way of specifying the accepted data type similar to the
      # HTTP "Accept" header
      if options.dataTypes[0] and options.accepts[options.dataTypes[0]]
        accepts = options.accepts[options.dataTypes[0]] + (if options.dataTypes[0] != '*' then ', */*; q=0.01' else '')
      else
        accepts = options.accepts['*']

      $('<input type=\'hidden\' name=\'X-HTTP-Accept\'>').attr('value', accepts).appendTo(form)

      # Move the file fields into the hidden form, but first remember their
      # original locations in the document by replacing them with disabled
      # clones. This should also avoid introducing unwanted changes to the
      # page layout during submission.
      files.after((_idx) ->
        $this = $(this)
        $clone = $this.clone().prop('disabled', true)
        $this.data('clone', $clone)
        $clone
      ).next()

      files.appendTo(form)

      return {
        send: (headers, completeCallback) ->
          iframe = $('<iframe src=\'about:blank\' name=\'' + name + '\' id=\'' + name + '\' style=\'display:none\'></iframe>')

          # The first load event gets fired after the iframe has been injected
          # into the DOM, and is used to prepare the actual submission.
          iframe.one 'load', ->

            # The second load event gets fired when the response to the form
            # submission is received. The implementation detects whether the
            # actual payload is embedded in a `<textarea>` element, and
            # prepares the required conversions to be made in that case.
            iframe.one 'load', ->
              doc        = if @contentWindow then @contentWindow.document else if @contentDocument then @contentDocument else @document
              root       = if doc.documentElement then doc.documentElement else doc.body
              textarea   = root.getElementsByTagName('textarea')[0]
              type       = textarea and textarea.getAttribute('data-type') or null
              status     = textarea and textarea.getAttribute('data-status') or 200
              statusText = textarea and textarea.getAttribute('data-statusText') or 'OK'
              content =
                text: if type then textarea.value else if root then root.textContent or root.innerText else null

              cleanUp()
              completeCallback status, statusText, content, if type then 'Content-Type: ' + type else null
              return

            # Now that the load handler has been set up, submit the form.
            form[0].submit()
            return

          # After everything has been set up correctly, the form and iframe
          # get injected into the DOM so that the submission can be
          # initiated.
          $('body').append(form, iframe)
          return

        abort: ->
          if iframe != null
            iframe.unbind('load').attr 'src', 'about:blank'
            cleanUp()
          return
      }

# coffeelint: enable=max_line_length
