# frozen_string_literal: true

require 'pio/open_flow/error_message'
require 'pio/open_flow13/error/error_type13'

module Pio
  module OpenFlow13
    # Error message parser
    module Error
      extend OpenFlow::ErrorMessage

      # Error message body parser.
      class BodyParser < BinData::Record
        endian :big
        error_type13 :error_type
        uint16 :error_code
      end
    end
  end
end
