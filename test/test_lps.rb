#!/usr/bin/env ruby

$VERBOSE = true
require 'rubygems'
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
    assert_raise(ArgumentError) { LPS.freq {} }
    assert_raise(ArgumentError) { LPS.freq }
    assert_raise(ArgumentError) { LPS.freq(0) }
    assert_raise(ArgumentError) { LPS.freq(-1) }
    assert_raise(ArgumentError) { LPS.freq(1, 1) }
  end

  def test_invalid_interval
    assert_raise(ArgumentError) { LPS.interval {} }
    assert_raise(ArgumentError) { LPS.interval }
    assert_raise(ArgumentError) { LPS.interval(-1) }
    assert_raise(ArgumentError) { LPS.interval(1, 1) }
  end

  def test_both_freq_and_interval
    LPS.interval(1).freq(1)
    assert_raise(ArgumentError) { LPS.interval(1).freq(1).new }
  end

  def test_non_number_params
    assert_raise(TypeError) { LPS.freq('bad') }
    assert_raise(TypeError) { LPS.interval('bad') }
    assert_raise(ArgumentError) { LPS.while('bad') }
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

  def test_lps_interval
    20.times.map { |i| 1 << i }.each do |ps|
      cnt = 0

      now = Time.now
      LPS.interval(1.0 / ps).while { Time.now - now <= 1 }.loop { cnt += 1 }

      puts [ps, cnt].join ' => '
    end
  end
end

