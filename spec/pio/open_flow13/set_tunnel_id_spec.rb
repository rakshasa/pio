# frozen_string_literal: true

require 'pio/open_flow13/set_tunnel_id'

describe Pio::OpenFlow13::SetTunnelId do
  describe '.new' do
    When(:set_tunnel_id) { Pio::OpenFlow13::SetTunnelId.new(tunnel_id) }

    context 'with 3' do
      When(:tunnel_id) { 3 }

      describe '#tunnel_id' do
        Then { set_tunnel_id.tunnel_id == 3 }
      end

      describe '#action_type' do
        Then { set_tunnel_id.action_type == 25 }
      end

      describe '#action_length' do
        Then { set_tunnel_id.action_length == 16 }
      end

      describe '#to_binary' do
        Then { set_tunnel_id.to_binary.length == 16 }
      end
    end
  end
end
