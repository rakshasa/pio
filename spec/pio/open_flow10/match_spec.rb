# frozen_string_literal: true

require 'pio/open_flow10/match'

describe Pio::OpenFlow10::Match do
  describe '.read' do
    When(:match) { Pio::OpenFlow10::Match.read(binary) }

    context 'with a Match binary' do
      Given(:binary) do
        [
          0x00, 0x38, 0x20, 0xfe,
          0x00, 0x01,
          0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
          0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
          0x00, 0x00,
          0x00,
          0x00,
          0x00, 0x00,
          0x00,
          0x00,
          0x00, 0x00,
          0x00, 0x00, 0x00, 0x00,
          0x00, 0x00, 0x00, 0x00,
          0x00, 0x00,
          0x00, 0x00
        ].pack('C*')
      end

      Then do
        match.wildcards.keys == %i[
          vlan_vid
          source_mac_address
          destination_mac_address
          ether_type
          ip_protocol
          transport_source_port
          transport_destination_port
          source_ip_address_all
          destination_ip_address_all
          vlan_priority
          tos
        ]
      end
      Then { match.in_port == 1 }
      Then { match.source_mac_address == '00:00:00:00:00:00' }
      Then { match.destination_mac_address == '00:00:00:00:00:00' }
      Then { match.vlan_vid.zero? }
      Then { match.vlan_priority.zero? }
      Then { match.ether_type.zero? }
      Then { match.tos.zero? }
      Then { match.ip_protocol.zero? }
      Then { match.source_ip_address == '0.0.0.0' }
      Then { match.destination_ip_address == '0.0.0.0' }
      Then { match.transport_source_port.zero? }
      Then { match.transport_destination_port.zero? }
    end

    context 'with a Match binary generated with Pio::OpenFlow10::Match.new' do
      Given(:binary) do
        Pio::OpenFlow10::Match.
          new(source_ip_address: '192.168.1.0/24').
          to_binary_s
      end

      Then do
        match.wildcards.keys == %i[
          in_port
          vlan_vid
          source_mac_address
          destination_mac_address
          ether_type
          ip_protocol
          transport_source_port
          transport_destination_port
          source_ip_address
          destination_ip_address_all
          vlan_priority
          tos
        ]
      end
      And { match.wildcards[:source_ip_address] = 12 }
      Then { match.in_port.zero? }
      Then { match.source_mac_address == '00:00:00:00:00:00' }
      Then { match.destination_mac_address == '00:00:00:00:00:00' }
      Then { match.vlan_vid.zero? }
      Then { match.vlan_priority.zero? }
      Then { match.ether_type.zero? }
      Then { match.tos.zero? }
      Then { match.ip_protocol.zero? }
      Then { match.source_ip_address == '192.168.1.0' }
      Then { match.source_ip_address.prefixlen == 24 }
      Then { match.destination_ip_address == '0.0.0.0' }
      Then { match.transport_source_port.zero? }
      Then { match.transport_destination_port.zero? }
    end
  end

  describe '.new' do
    When(:match) { Pio::OpenFlow10::Match.new(options) }

    context 'with in_port: 1' do
      Given(:options) { { in_port: 1 } }
      Then do
        match.wildcards.keys == %i[
          vlan_vid
          source_mac_address
          destination_mac_address
          ether_type
          ip_protocol
          transport_source_port
          transport_destination_port
          source_ip_address_all
          destination_ip_address_all
          vlan_priority
          tos
        ]
      end
      Then { match.in_port == 1 }
      Then { match.source_mac_address == '00:00:00:00:00:00' }
      Then { match.destination_mac_address == '00:00:00:00:00:00' }
      Then { match.vlan_vid.zero? }
      Then { match.vlan_priority.zero? }
      Then { match.ether_type.zero? }
      Then { match.tos.zero? }
      Then { match.ip_protocol.zero? }
      Then { match.source_ip_address == '0.0.0.0' }
      Then { match.destination_ip_address == '0.0.0.0' }
      Then { match.transport_source_port.zero? }
      Then { match.transport_destination_port.zero? }

      describe '#==' do
        When(:result) { match == other }

        context 'with Match.new(in_port: 1)' do
          Given(:other) { Pio::OpenFlow10::Match.new(in_port: 1) }
          Then { result == true }
        end
      end
    end

    context "with source_ip_address: '192.168.1.0/24'" do
      Given(:options) { { source_ip_address: '192.168.1.0/24' } }
      Then do
        match.wildcards.keys == %i[
          in_port
          vlan_vid
          source_mac_address
          destination_mac_address
          ether_type
          ip_protocol
          transport_source_port
          transport_destination_port
          source_ip_address
          destination_ip_address_all
          vlan_priority
          tos
        ]
      end
      Then { match.wildcards.fetch(:source_ip_address) == 8 }
      Then { match.in_port.zero? }
      Then { match.source_mac_address == '00:00:00:00:00:00' }
      Then { match.destination_mac_address == '00:00:00:00:00:00' }
      Then { match.vlan_vid.zero? }
      Then { match.vlan_priority.zero? }
      Then { match.ether_type.zero? }
      Then { match.tos.zero? }
      Then { match.ip_protocol.zero? }
      Then { match.source_ip_address == '192.168.1.0/24' }
      Then { match.destination_ip_address == '0.0.0.0' }
      Then { match.transport_source_port.zero? }
      Then { match.transport_destination_port.zero? }
    end

    context "with destination_ip_address: '192.168.1.0/24'" do
      Given(:options) { { destination_ip_address: '192.168.1.0/24' } }
      Then do
        match.wildcards.keys == %i[
          in_port
          vlan_vid
          source_mac_address
          destination_mac_address
          ether_type
          ip_protocol
          transport_source_port
          transport_destination_port
          source_ip_address_all
          destination_ip_address
          vlan_priority
          tos
        ]
      end
      Then { match.wildcards.fetch(:destination_ip_address) == 8 }
      Then { match.in_port.zero? }
      Then { match.source_mac_address == '00:00:00:00:00:00' }
      Then { match.destination_mac_address == '00:00:00:00:00:00' }
      Then { match.vlan_vid.zero? }
      Then { match.vlan_priority.zero? }
      Then { match.ether_type.zero? }
      Then { match.tos.zero? }
      Then { match.ip_protocol.zero? }
      Then { match.source_ip_address == '0.0.0.0' }
      Then { match.destination_ip_address == '192.168.1.0/24' }
      Then { match.transport_source_port.zero? }
      Then { match.transport_destination_port.zero? }
    end
  end
end
