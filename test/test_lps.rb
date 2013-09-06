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

  def test_freq=
    st = Time.now
    i = 0
    LPS.freq(1).while { i < 100 }.loop do |lps|
      print i += 1
      print ' '

      lps.freq = i
      assert_equal i, lps.freq
    end
    assert ((Time.now - st) - (1...100).map { |e| 1.0 / e }.inject(:+)).abs < 0.1
  end

  def test_freq_to_nil
    i = 0
    st = Time.now
    LPS.freq(1).while { i < 100 }.loop do |lps|
      print i += 1
      print ' '

      lps.freq = nil
    end
    assert (Time.now - st) < 0.1
  end

  def test_interval=
    st = Time.now
    i = 0
    LPS.interval(1).while { i < 100 }.loop do |lps|
      print i += 1
      print ' '

      lps.interval = 1.0 / i
      assert_equal 1.0 / i, lps.interval
    end
    assert ((Time.now - st) - (1...100).map { |e| 1.0 / e }.inject(:+)).abs < 0.1
  end

  def test_invalid_freq_interval
    assert_raise(ArgumentError) do
      LPS.freq(10).loop do |lps|
        lps.freq = -1
      end
    end

    assert_raise(ArgumentError) do
      LPS.freq(10).loop do |lps|
        lps.interval = -1
      end
    end
  end
end

