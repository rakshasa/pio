require 'bindata'
require 'pio/enqueue'
require 'pio/send_out_port'
require 'pio/set_eth_addr'
require 'pio/set_ip_addr'
require 'pio/set_ip_tos'
require 'pio/set_transport_port'
require 'pio/set_vlan_priority'
require 'pio/set_vlan_vid'
require 'pio/strip_vlan_header'

module Pio
  module OpenFlow
    # Actions list.
    class Actions < BinData::Primitive
      ACTION_CLASS = {
        0 => Pio::SendOutPort,
        1 => Pio::SetVlanVid,
        2 => Pio::SetVlanPriority,
        3 => Pio::StripVlanHeader,
        4 => Pio::SetEthSrcAddr,
        5 => Pio::SetEthDstAddr,
        6 => Pio::SetIpSrcAddr,
        7 => Pio::SetIpDstAddr,
        8 => Pio::SetIpTos,
        9 => Pio::SetTransportSrcPort,
        10 => Pio::SetTransportDstPort,
        11 => Pio::Enqueue
      }

      mandatory_parameter :length

      endian :big

      string :binary, read_length: :length

      def set(value)
        self.binary = [value].flatten.map(&:to_binary).join
      end

      # rubocop:disable MethodLength
      # This method smells of :reek:TooManyStatements
      def get
        actions = []
        tmp = binary
        while tmp.length > 0
          type = BinData::Uint16be.read(tmp)
          begin
            action = ACTION_CLASS.fetch(type).read(tmp)
            tmp = tmp[action.message_length..-1]
            actions << action
          rescue KeyError
            raise "action type #{type} is not supported."
          end
        end
        actions
      end
      # rubocop:enable MethodLength

      def [](index)
        get[index]
      end
    end
  end
end