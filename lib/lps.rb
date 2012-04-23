require "lps/version"

class LPS
  def self.freq freq
    LPS.new :freq => freq
  end

  def self.while &cond
    LPS.new :cond => cond
  end

  def freq freq
    LPS.new(:freq => freq, :cond => @cond)
  end

  def while &cond
    LPS.new(:freq => @freq, :cond => cond)
  end

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
          break unless @cond.call
          sleep diff
        elsif diff < 0
          nt = now
        end
      end
    end
    ret
  end

  def initialize opts = {}
    raise ArgumentError.new("Not a Hash") unless opts.is_a?(Hash)

    @freq = opts[:freq]
    raise ArgumentError.new(
      "Frequency must be a positive number (or nil)") unless 
          @freq.nil? || (@freq.is_a?(Numeric) && @freq > 0)

    @cond = opts[:cond] || proc { true }
    raise ArgumentError.new("Invalid condition block") unless
        @cond.is_a?(Proc)
  end
end

