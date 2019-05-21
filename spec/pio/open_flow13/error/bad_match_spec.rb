# frozen_string_literal: true

require 'pio/open_flow13/error/bad_match'

describe Pio::OpenFlow13::Error::BadMatch do
  it_should_behave_like('an OpenFlow message',
                        Pio::OpenFlow13::Error::BadMatch)
end
