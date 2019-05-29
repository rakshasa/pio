# frozen_string_literal: true

require 'pio/open_flow13/error/bad_action'

describe Pio::OpenFlow13::Error::BadAction do
  it_should_behave_like('an OpenFlow message',
                        Pio::OpenFlow13::Error::BadAction)
end
