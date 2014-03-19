$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'signnow/check_element'
require 'signnow/document'
require 'signnow/element'
require 'signnow/field'
require 'signnow/invalid_state_error'
require 'signnow/invitation'
require 'signnow/settings'
require 'signnow/signature_element'
require 'signnow/text_element'
require 'signnow/user'

env = ENV['ENV'] || 'development'

SN.load_settings(File.join(__dir__, 'SignNow.yml'), env)
