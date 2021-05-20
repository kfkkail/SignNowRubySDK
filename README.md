# Signnow

This library simplifies integrating SignNow's eSignature platform into your existing applications. It is still under development but we welcome you to try it and provide feedback at api@signnow.com.

## Installation

Add this line to your application's Gemfile:

    gem 'signnow-sdk'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install signnow-sdk

## Usage

Configure your Rails application to load your OAuth credentials when it starts:

Add a YAML config file to /config

```
 development:
   # Your app's Oauth credentials provided by your account manager
   basic_authorization: 0fccdbc73581ca0f9bf8c379e6a96813

   base_url: https://capi-eval.signnow.com
   signing_base_url: https://eval.signnow.com
```

Add signnow.rb to /config/initializers with the following

```ruby
require 'signnow'

SN::Settings.load("#{::Rails.root}/config/signnow.yml", Rails.env)
```
