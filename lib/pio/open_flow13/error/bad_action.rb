# frozen_string_literal: true

require 'pio/open_flow/error_message'
require 'pio/open_flow/message'
require 'pio/open_flow13/error/error_type13'

module Pio
  module OpenFlow13
    module Error
      # Bad action error.
      class BadAction < OpenFlow::Message
        # enum ofp_bad_action_code
        class BadActionCode < BinData::Primitive
          ERROR_CODES = {
            bad_type: 0,
            bad_length: 1,
            bad_expermienter: 2,
            bad_expermienter_type: 3,
            bad_out_port: 4,
            bad_argument: 5,
            permission_error: 6,
            too_many: 7,
            bad_queue: 8,
            bad_out_group: 9,
            match_inconsistent: 10,
            unsupported_order: 11,
            bad_tag: 12,
            bad_set_type: 13,
            bad_set_length: 14,
            bad_set_argument: 15
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
        error_type13 :error_type, value: -> { :bad_action }
        bad_action_code :error_code
        rest :raw_data
      end
    end
  end
end
