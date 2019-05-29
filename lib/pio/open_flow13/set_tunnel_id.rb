# frozen_string_literal: true

require 'pio/open_flow/action'
require 'pio/open_flow13/match'

module Pio
  module OpenFlow13
    # Set tunnel ID
    class SetTunnelId < OpenFlow::Action
      action_header action_type: 25, action_length: 16

      uint16 :oxm_class, value: Match::OpenFlowBasicValue::OXM_CLASS
      bit7 :oxm_field, value: Match::TunnelId::OXM_FIELD
      bit1 :oxm_hasmask, value: 0
      uint8 :oxm_length, value: 8
      uint64 :tunnel_id

      def initialize(tunnel_id)
        super tunnel_id: tunnel_id
      end
    end
  end
end
