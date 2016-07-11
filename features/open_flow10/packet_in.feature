@open_flow10
Feature: PacketIn

  When packets are received by the datapath and sent to the
  controller, they use the PacketIn message.

  Scenario: new
    When I create an OpenFlow message with:
      """ruby
      arp_request = Pio::Arp::Request.new(
        source_mac: 'fa:ce:b0:00:00:cc',
        sender_protocol_address: '192.168.0.1',
        target_protocol_address: '192.168.0.2'
      )

      Pio::PacketIn.new(transaction_id: 0,
                        buffer_id: 0xffffff00,
                        in_port: 1,
                        reason: :no_match,
                        raw_data: arp_request.to_binary)
      """
    Then the message has the following fields and values:
      | field           |             value |
      | transaction_id  |                 0 |
      | xid             |                 0 |
      | buffer_id       |        4294967040 |
      | total_length    |                64 |
      | in_port         |                 1 |
      | reason          |         :no_match |
      | data.class      | Pio::Arp::Request |
      | source_mac      | fa:ce:b0:00:00:cc |
      | destination_mac | ff:ff:ff:ff:ff:ff |

  Scenario: convert PacketIn to Ruby code
    When I eval the following Ruby code:
      """ruby
      arp_request = Pio::Arp::Request.new(
        source_mac: 'fa:ce:b0:00:00:cc',
        sender_protocol_address: '192.168.0.1',
        target_protocol_address: '192.168.0.2'
      )

      Pio::PacketIn.new(transaction_id: 0,
                        buffer_id: 0xffffff00,
                        in_port: 1,
                        reason: :no_match,
                        raw_data: arp_request.to_binary).to_ruby
      """
    Then the result of eval should be:
      """ruby
      [
        0x01, # version
        0x0a, # type
        0x00, 0x52, # _length
        0x00, 0x00, 0x00, 0x00, # transaction_id
        0xff, 0xff, 0xff, 0x00, # buffer_id
        0x00, 0x40, # total_length
        0x00, 0x01, # in_port
        0x00, # reason
        0x00, # padding
        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfa, 0xce, 0xb0, 0x00, 0x00, 0xcc, 0x08, 0x06, 0x00, 0x01, 0x08, 0x00, 0x06, 0x04, 0x00, 0x01, 0xfa, 0xce, 0xb0, 0x00, 0x00, 0xcc, 0xc0, 0xa8, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xc0, 0xa8, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, # raw_data
      ].pack('C82')
      """
