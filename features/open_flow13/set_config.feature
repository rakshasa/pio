@open_flow13
Feature: SetConfig
  Scenario: new
    When I create an OpenFlow message with:
      """
      Pio::SetConfig.new
      """
    Then the message has the following fields and values:
      | field            |      value |
      | version          |          4 |
      | to_binary.length |         12 |
      | transaction_id   |          0 |
      | xid              |          0 |
      | flags            |         [] |
      | miss_send_length | :no_buffer |

  Scenario: new (flags: %i[fragment_reassemble], miss_send_length: 0xffe5)
    When I create an OpenFlow message with:
      """
      data_dump = [
        0x04, 0x09, 0x00, 0x0c, 0x00, 0x00, 0x00, 0x0d, 0x00, 0x02,
        0xff, 0xe5
      ].pack('C*')

      Pio::SetConfig.new(flags: %i[fragment_reassemble], miss_send_length: 0xffe5)
      """
    Then the message has the following fields and values:
      | field                   |                  value |
      | version                 |                      4 |
      | to_binary.length        |                     12 |
      | transaction_id          |                     13 |
      | xid                     |                     13 |
      | flags                   | %[fragment_reassemble] |
      | miss_send_length        |             :no_buffer |
