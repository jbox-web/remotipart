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

  remotipart =
    setup: (form) ->

      # Preserve form.data('ujs:submit-button') before it gets nulled by $.ajax.handleRemote
      button    = form.data('ujs:submit-button')
      csrfParam = $('meta[name="csrf-param"]').attr('content')
      csrfToken = $('meta[name="csrf-token"]').attr('content')
      csrfInput = form.find('input[name="' + csrfParam + '"]').length

      form.one('ajax:beforeSend.remotipart', (e, xhr, settings) ->
        # Delete the beforeSend bindings, since we're about to re-submit via ajaxSubmit with the beforeSubmit
        # hook that was just setup and triggered via the default `$.rails.handleRemote`
        delete settings.beforeSend

        settings.iframe = true
        settings.files  = $($.rails.fileInputSelector, form)
        settings.data   = form.serializeArray()

        # Insert the name/value of the clicked submit button, if any
        settings.data.push(button) if button

        # jQuery 1.9 serializeArray() contains input:file entries
        # so exclude them from settings.data, otherwise files will not be sent
        settings.files.each (i, file) ->
          j = settings.data.length - 1
          while j >= 0
            if settings.data[j].name == file.name
              settings.data.splice j, 1
            j--
          return

        settings.processData = false

        # Modify some settings to integrate JS request with rails helpers and middleware
        settings.dataType = 'script *' if settings.dataType == undefined

        settings.data.push
          name: 'remotipart_submitted'
          value: true

        if csrfToken and csrfParam and !csrfInput
          settings.data.push
            name: csrfParam
            value: csrfToken

        # Allow remotipartSubmit to be cancelled if needed
        if $.rails.fire(form, 'ajax:remotipartSubmit', [xhr, settings])
          # Second verse, same as the first
          $.rails.ajax(settings).always (data) ->
            $.rails.fire(form, 'ajax:remotipartComplete', [data])

          setTimeout (->
            $.rails.disableFormElements(form)
          ), 20

        # Run cleanup
        remotipart.teardown form

        # Cancel the jQuery UJS request
        return false
      ).data('remotipartSubmitted', true)

    teardown: (form) ->
      form.unbind('ajax:beforeSend.remotipart').removeData('remotipartSubmitted')

  $.remotipart = remotipart

  $(document).on 'ajax:aborted:file', 'form', ->
    form = $(this)
    remotipart.setup(form)
    # Manually call jquery-ujs remote call so that it can setup form and settings as usual,
    # and trigger the `ajax:beforeSend` callback to which remotipart binds functionality.
    $.rails.handleRemote(form)
    return false
