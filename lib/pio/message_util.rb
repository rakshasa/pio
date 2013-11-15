# -*- coding: utf-8 -*-
module Pio
  # Pio Message Util.
  module MessageUtil
    def option_hash
      mandatory_options.reduce({}) do | opt, each |
        klass = option_to_klass[each]
        opt_pair = { each => klass.new(user_options[each]).to_a }
        opt.merge opt_pair
      end.merge default_options
    end
  end
end

### Local variables:
### mode: Ruby
### coding: utf-8
### indent-tabs-mode: nil
### End: