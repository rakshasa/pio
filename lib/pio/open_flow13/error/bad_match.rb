# frozen_string_literal: true

require 'pio/open_flow/error_message'
require 'pio/open_flow/message'
require 'pio/open_flow13/error/error_type13'

module Pio
  module OpenFlow13
    module Error
      # Bad match error.
      class BadMatch < OpenFlow::Message
        # enum ofp_bad_match_code
        class BadMatchCode < BinData::Primitive
          ERROR_CODES = {
            bad_type: 0,
            bad_length: 1,
            bad_tag: 2,
            bad_datalink_address_mask: 3,
            bad_network_address_mask: 4,
            bad_wildcards: 5,
            bad_field: 6,
            bad_value: 7,
            bad_mask: 8,
            bad_prerequisite: 9,
            duplicate_field: 10,
            permission_error: 11
          }.freeze

          endian :big
          uint16 :error_code

          def get
            ERROR_CODES.invert.fetch(error_code)
          end

          def set(value)
            self.error_code = ERROR_CODES.fetch(value)
          end
        end

        open_flow_header version: 4,
                         type: OpenFlow::ErrorMessage.type,
                         length: -> { 12 + raw_data.length }
        error_type13 :error_type, value: -> { :bad_match }
        bad_match_code :error_code
        rest :raw_data
      end
    end
  end
end
