# frozen_string_literal: true

module Pio
  module OpenFlow13
    # Controller max length, or :no_buffer.
    class ControllerMaxLength < BinData::Primitive
      MAX = 0xffe5
      NO_BUFFER = 0xffff

      endian :big
      uint16 :max_length, initial_value: NO_BUFFER

      def max
        MAX
      end

      def get
        max_length == NO_BUFFER ? :no_buffer : max_length
      end

      def set(length)
        if length == :no_buffer
          self.max_length = NO_BUFFER
        else
          length_num = length.to_i
          if length > max
            raise ArgumentError, "The controller max length should be <= #{max.to_hex}"
          end
          self.max_length = length_num
        end
      end
    end
  end
end
