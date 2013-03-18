require "lps/version"
require 'option_initializer'

class LPS
  include OptionInitializer
  option_initializer! :freq, :interval => Numeric, :while => :&
  option_validator :freq do |v|
    msg = 'frequency must be a positive number (or nil)'
    raise TypeError, msg unless v.is_a?(Numeric) || v.nil?
    raise ArgumentError, msg if v.is_a?(Numeric) && v <= 0
  end
  option_validator :interval do |v|
    raise ArgumentError, 'interval must be a non-negative number' if v < 0
  end

  # @param [Proc] &block Loop
  def loop &block
    ret = nil
    always = @while.nil?
    if @freq.nil?
      while always || @while.call
        ret = block.call
      end
    else
      sleep_interval = 1.0 / @freq

      nt = Time.now
      while always || @while.call
        nt += sleep_interval
        ret = block.call

        now  = Time.now
        diff = nt - now

        if diff > 0.01
          sleep diff
        elsif diff < 0
          nt = now
        end
      end
    end
    ret
  end

  # @param [Hash] opts Options Hash.
  # @option opts [Numeric] :freq Frequency of loop execution (loops/sec)
  # @option opts [#call] :cond Loop condition
  def initialize opts = {}
    validate_options opts

    freq, intv, @while = opts.values_at :freq, :interval, :while
    raise ArgumentError,
      "can't have both frequency and interval" if freq && intv

    @freq =
      if freq
        freq
      elsif intv
        (intv == 0) ? nil : 1.0 / intv
      else
        nil
      end
  end
end

