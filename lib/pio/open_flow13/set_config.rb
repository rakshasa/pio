# frozen_string_literal: true

require 'pio/open_flow'
require 'pio/open_flow13/controller_max_length'

module Pio
  module OpenFlow13
    # OpenFlow 1.3 SetConfig message parser and generator
    class SetConfig < OpenFlow::Message
      open_flow_header version: 4, type: 9, length: 12
      flags_16bit :flags,
                  %i[fragment_drop
                     fragment_reassemble]
      controller_max_length :miss_send_length
    end
  end
end
