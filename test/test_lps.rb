#!/usr/bin/env ruby

require 'rubygems'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../lib')
require 'lps'
require 'test-unit'

class TestLPS < Test::Unit::TestCase
  def test_lps
    duration = 3

    [0.2, 10, 20].each do |ps|
      cnt = 0

      now = Time.now
      LPS.while { Time.now - now <= duration }.freq(ps).loop { cnt += 1 }

      expected = (duration * ps).to_i
      # FIXME: naive assertion
      assert (expected-1..expected+1).include?(cnt)
    end
  end

  def test_no_frequency
    cnt = 0
    now = Time.now
    LPS.while { Time.now - now <= 1 }.loop { cnt += 1 }
    # FIXME: naive assertion
    assert cnt > 1000
  end

  def test_non_positive_frequency
    assert_raise(ArgumentError) { LPS.freq(0) }
    assert_raise(ArgumentError) { LPS.freq(-1) }
  end

  def test_non_number_frequency
    assert_raise(ArgumentError) { LPS.freq('freq') }
  end

  def test_non_proc_cond
    assert_raise(ArgumentError) { LPS.while('freq') }
  end

  def test_return_value
    cnt = 0
    now = Time.now
    ret = LPS.while { Time.now - now <= 1 }.loop { cnt += 1 }
    assert_equal cnt, ret
  end

  def test_loop_break
    cnt = 0
    LPS.freq(100).loop { break if (cnt += 1) >= 50 }
    assert_equal 50, cnt
  end

  def test_lps_high_freq
    20.times.map { |i| 1 << i }.each do |ps|
      cnt = 0

      now = Time.now
      LPS.freq(ps).while { Time.now - now <= 1 }.loop { cnt += 1 }

      # TODO: need assertion
      puts [ps, cnt].join ' => '
    end
  end
end

