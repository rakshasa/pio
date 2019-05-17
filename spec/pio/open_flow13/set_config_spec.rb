# frozen_string_literal: true

require 'pio/open_flow13/set_config'

describe Pio::OpenFlow13::SetConfig do
  describe '.new' do
    it_should_behave_like('an OpenFlow message', Pio::OpenFlow13::SetConfig)

    context 'with :miss_send_length: :no_buffer' do
      When(:set_config) { Pio::OpenFlow13::SetConfig.new(miss_send_length: :no_buffer) }

      describe '#flags' do
        Then { set_config.flags == [] }
      end

      describe '#miss_send_length' do
        Then { set_config.miss_send_length == :no_buffer }
      end
    end

    context 'with flags: [:fragment_drop], miss_send_length: 0xffe5' do
      When(:set_config) { Pio::OpenFlow13::SetConfig.new(flags: %i[fragment_drop], miss_send_length: 0xffe5) }

      describe '#flags' do
        Then { set_config.flags == [:fragment_drop] }
      end

      describe '#miss_send_length' do
        Then { set_config.miss_send_length == 0xffe5 }
      end
    end

    context 'with miss_send_length: 0xffe6' do
      When(:set_config) { Pio::OpenFlow13::SetConfig.new(miss_send_length: 0xffe6) }
      Then { set_config == Failure(ArgumentError) }
    end

  end

  describe '.read' do
    context 'with a Set Config binary' do
      Given(:binary) do
        [0x04, 0x09, 0x00, 0x0c, 0x00, 0x00, 0x00, 0x0d, 0x00, 0x02,
         0xff, 0xe5].pack('C*')
      end

      When(:set_config) do
        Pio::OpenFlow13::SetConfig.read(binary)
      end

      Then { set_config.class == Pio::OpenFlow13::SetConfig }
      Then { set_config.version == 4 }
      Then { set_config.type == 9 }
      Then { set_config.length == 12 }
      Then { set_config.transaction_id == 13 }
      Then { set_config.xid == 13 }
      Then { set_config.flags == %i[fragment_reassemble] }
      Then { set_config.miss_send_length == 0xffe5 }
    end
  end


end
