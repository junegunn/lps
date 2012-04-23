LPS: Loops Per Second
=====================

Rate-controlled loop execution.

Installation
------------

Add this line to your application's Gemfile:

    gem 'lps'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lps

Usage
-----

```ruby
# - Loops 10 times per second
# - Loops for 10 seconds
now = Time.now
LPS.freq(10).while { Time.now - now < 10 }.loop { # do something }

# - Loops 10 times per second
# - Loops indefinitely
LPS.freq(10).loop { # do something }
```

Breaking out of the loop
------------------------

```ruby
LPS.freq(10).loop { break if rand(10) == 0 }
```

Falling behind
--------------

With LPS, the given loop block is run synchronously,
which means that if the block execution takes longer than the interval for the given frequency,
(e.g. 0.01 second for 100)
it may not be possible to achieve the desired frequency.

```ruby
12.times.map { |i| 1 << i }.each do |ps|
  cnt = 0
  now = Time.now
  LPS.freq(ps).while { Time.now - now <= 1 }.loop do
    cnt += 1
    sleep 0.01
  end

  puts [ps, cnt].join ' => '
end
```

```
1 => 1
2 => 2
4 => 4
8 => 8
16 => 16
32 => 32
64 => 64
128 => 98
256 => 98
512 => 99
1024 => 97
2048 => 98
```
