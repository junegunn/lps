# LPS: Loops Per Second

Rate-controlled loop execution.

## Installation

Add this line to your application's Gemfile:

    gem 'lps'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lps

## Usage

```ruby
    # - Loops 10 times per second
    # - Loops for 10 seconds
    now = Time.now
    LPS.freq(10).while { Time.now - now < 10 }.loop { # do something }

    # - Loops 10 times per second
    # - Loops indefinitely
    LPS.freq(10).loop { # do something }
```

## Breaking out of the loop

```ruby
    LPS.freq(10).loop { break if rand(10) == 0 }
```

## Falling behind

With LPS, the given loop block is run synchronously,
so if it takes longer than the calculated interval,
it won't be possible to achieve the desired frequency.

```ruby
    12.times.map { |i| 1 << i }.each do |ps|
      cnt = 0
      now = Time.now
      LPS.freq(ps).while { Time.now - now <= 1 }.loop { cnt += 1; sleep 0.01 }

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
