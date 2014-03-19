require 'signnow'

module SN
  class InvalidStateError < StandardError
    attr_reader :reason
    def initialize(reason)
      @reason = reason
    end
  end
end

