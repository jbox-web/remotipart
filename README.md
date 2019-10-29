# Remotipart: Rails jQuery File Uploads

[![GitHub license](https://img.shields.io/github/license/jbox-web/remotipart.svg)](https://github.com/jbox-web/remotipart/blob/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/jbox-web/remotipart.svg)](https://github.com/jbox-web/remotipart/releases/latest)
[![Build Status](https://travis-ci.com/jbox-web/remotipart.svg?branch=master)](https://travis-ci.com/jbox-web/remotipart)
[![Code Climate](https://codeclimate.com/github/jbox-web/remotipart/badges/gpa.svg)](https://codeclimate.com/github/jbox-web/remotipart)
[![Test Coverage](https://codeclimate.com/github/jbox-web/remotipart/badges/coverage.svg)](https://codeclimate.com/github/jbox-web/remotipart/coverage)

Remotipart is a Ruby on Rails gem enabling AJAX file uploads with jQuery in Rails 5 remote forms.

This gem augments the native Rails jQuery remote form functionality enabling asynchronous file uploads with little to no modification to your application.

* [How AJAX File Uploads Work](http://www.alfajango.com/blog/ajax-file-uploads-with-the-iframe-method/)

## Installation

Put this in your `Gemfile` :

```ruby
git_source(:github){ |repo_name| "https://github.com/#{repo_name}.git" }

gem 'remotipart', github: 'jbox-web/remotipart', tag: '1.5.0'
```

then run `bundle install`.


## Usage

* For multipart / forms with file inputs, set your form_for to remote as you would for a normal ajax form : `remote: true`
* When Javascript is enabled in the user's browser, the form, including the file, will be submitted asynchronously to your controller with : `format: 'js'`

If you need to determine if a particular request was made via a remotipart-enabled form :

* from your Rails controller or view :

```ruby
if remotipart_submitted?
```

* from your javascript :

```javascript
  $(form).bind("ajax:success", function(){
    if ($(this).data('remotipartSubmitted')) {
      ...
    }
  });
```

If you want to be notified when the upload is complete (which can be either success or error)

* from your javascript :

```javascript
  $(form).on("ajax:remotipartComplete", function(e, data){
    console.log(e, data)
  });
```


## Example

`sample_layout.html.erb` :

```html
<%= form_for @sample, html: { multipart: true }, remote: true do |f| %>
  <div class="field">
    <%= f.label :file %>
    <%= f.file_field :file %>
  </div>
  <div class="actions">
    <%= f.submit %>
  </div>
<% end %>
```

`sample_controller.rb` :

```ruby
def create
  respond_to do |format|
    if @sample.save
      format.js
    end
  end
end
```

`create.js.erb` :

```javascript
// Display a Javascript alert
alert('success!');
<% if remotipart_submitted? %>
  alert('submitted via remotipart')
<% else %>
  alert('submitted via native jquery-ujs')
<% end %>
```

The content type requested from the application can be overridden via the <tt>data-type</tt> HTML5 attribute:

`sample_layout2.html.erb` :

```html
<%= form_for @sample, html: { multipart: true }, remote: true, data: { type: :html } do |f| %>
  <div class="field">
    <%= f.label :file %>
    <%= f.file_field :file %>
  </div>
  <div class="actions">
    <%= f.submit %>
  </div>
<% end %>
```

In this case, the application should serve HTML using a <tt>create.html.erb</tt> template instead of JavaScript.
