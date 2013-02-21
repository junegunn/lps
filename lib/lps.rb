require "lps/version"

class LPS
  # @param [Numeric] freq Frequency of loop execution (loops/sec)
  # @return [LPS]
  def self.freq freq
    LPS.new.freq freq
  end

  # @param [Numeric] intv Loop execution interval
  # @return [LPS]
  def self.interval intv
    LPS.new.interval intv
  end

  # @param [Proc] &cond Loop condition
  # @return [LPS]
  def self.while &cond
    LPS.new.while &cond
  end

  # @param [Numeric] freq Frequency of loop execution (loops/sec)
  # @return [LPS]
  def freq freq
    LPS.new(:freq => freq, :cond => @cond)
  end

  # @param [Numeric] intv Loop execution interval
  # @return [LPS]
  def interval intv
    freq(intv == 0 ? nil : (1.0 / intv))
  end

  # @param [Proc] &cond Loop condition
  # @return [LPS]
  def while &cond
    LPS.new(:freq => @freq, :cond => cond)
  end

  # @param [Proc] &block Loop
  def loop &block
    ret = nil
    if @freq.nil?
      while @cond.call
        ret = block.call
      end
    else
      sleep_interval = 1.0 / @freq

      nt = Time.now
      while @cond.call
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
    raise ArgumentError, 'Not a Hash' unless opts.is_a?(Hash)

    @freq = opts[:freq]
    raise ArgumentError,
      'Frequency must be a positive number (or nil)' unless
          @freq.nil? || (@freq.is_a?(Numeric) && @freq > 0)

    @cond = opts[:cond] || proc { true }
    raise ArgumentError, 'Invalid condition block' unless
        @cond.respond_to?(:call)
  end
end

