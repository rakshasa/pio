# frozen_string_literal: true

require 'pio/open_flow13/hello'
require 'pio/parse_error'

describe Pio::OpenFlow13::Hello do
  describe '.read' do
    When(:result) { Pio::OpenFlow13::Hello.read(binary) }

    context 'with a hello message (no version bitmap)' do
      Given(:binary) { [4, 0, 0, 8, 0, 0, 0, 0].pack('C*') }

      Then { result.class == Pio::OpenFlow13::Hello }
      Then { result.version == 4 }
      Then { result.type.zero? }
      Then { result.length == 8 }
      Then { result.transaction_id.zero? }
      Then { result.xid.zero? }
      Then { result.supported_versions.empty? }
    end

    context 'with a hello message' do
      Given(:binary) do
        [4, 0, 0, 16, 0, 0, 0, 0, 0, 1, 0, 8, 0, 0, 0, 18].pack('C*')
      end

      Then { result.class == Pio::OpenFlow13::Hello }
      Then { result.version == 4 }
      Then { result.type.zero? }
      Then { result.length == 16 }
      Then { result.transaction_id.zero? }
      Then { result.xid.zero? }
      Then { result.supported_versions == %i[open_flow10 open_flow13] }
    end

    context 'with a hello message (OpenFlow 1.0)' do
      Given(:binary) { [1, 0, 0, 8, 0, 0, 0, 0].pack('C*') }

      Then do
        result == Failure(Pio::ParseError, 'Invalid OpenFlow13 Hello message.')
      end
    end
  end

  describe '.new' do
    it_should_behave_like('an OpenFlow message', Pio::OpenFlow13::Hello)

    context 'with no arguments' do
      When(:result) { Pio::OpenFlow13::Hello.new }

      Then { result.version == 4 }
      Then { result.type.zero? }
      Then { result.length == 16 }
      Then { result.transaction_id.zero? }
      Then { result.xid.zero? }
      Then { result.supported_versions == [:open_flow13] }
      Then do
        result.to_binary ==
          [4, 0, 0, 16, 0, 0, 0, 0, 0, 1, 0, 8, 0, 0, 0, 16].pack('C*')
      end
    end

    context 'with invalid_option: :foo' do
      When(:result) { Pio::OpenFlow13::Hello.new(invalid_option: :foo) }

      Then do
        result == Failure(RuntimeError, 'Unknown option: invalid_option')
      end
    end
  end
end
