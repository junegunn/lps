require "lps/version"
require 'option_initializer'

class LPS
  include OptionInitializer
  option_initializer! :freq, :interval, :while
  option_validator do |k, v|
    case k
    when :freq
      raise ArgumentError,
        'frequency must be a positive number (or nil)' unless
          v.nil? || (v.is_a?(Numeric) && v > 0)
    when :interval
      raise ArgumentError,
        'interval must be a positive number (or zero)' unless
          v.is_a?(Numeric) && v >= 0
    when :while
      raise ArgumentError,
        'loop condition must respond to call' unless
          v.respond_to?(:call)
    end
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

