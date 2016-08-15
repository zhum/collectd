# collectd

[![Gem Version](https://badge.fury.io/rb/collectd.svg)](http://badge.fury.io/rb/collectd)

Allows you to send metrics to [**collectd**](https://github.com/collectd/collectd) from Ruby, by talking to the collectd network protocol, and sending stats periodicially to a network-aware instance of collectd.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'collectd'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install collectd

## Setup

You need to have `collectd` load the network plugin, and listen on UDP port `25826` (so it's acting as a server): 

```
# /etc/collectd.conf

LoadPlugin network
  
<Plugin "network">
  Listen "ff18::efc0:4a42"
</Plugin>
```

Usage
-----

Specify a server to send data to:

```ruby
Collectd.add_server(10, 'ff18::efc0:4a42', 25826)
```

Each server you add will receive all the data you push later. An interval of 10 is quite reasonable. Because of UDP and `collectd`'s network buffering, you can set the interval to less than 10, but you won't see much benefit.

`ruby-collectd` gives you a free data collector out of the box, and it's a nice gentle introduction to instrumenting your app. 

To collect memory and CPU statistics of your Ruby process, do:

```ruby
Stats = Collectd.my_process(:woo_data)
Stats.with_full_proc_stats
```

In the first line, we set up a new plugin. ``my_process`` is the plugin name (magically handled by method_missing), and ``:woo_data`` is the plugin instance. 

A **plugin name** is generally an application's name, and a **plugin instance** is a unique identifier of an instance of an application (i.e. you have multiple daemons or scripts running at the same time).

In the second line, ``with_full_proc_stats`` is a method provided by `ruby-collectd` that collects stats about the current running process. It makes use of polled gauges, which we talk about later. 

Behind the scenes, ``with_full_proc_stats`` is using a **simple interface** you can use to instrument your own data. 

Back in the first line we set up a plugin which we wanted to record some data on. ``with_full_proc_stats`` sets up **types**, which are a kind of data you are measuring (in this case CPU and memory usage).

You can do this yourself like this: 

```ruby
Stats = Collectd.my_daemon(:backend)

# Set counter absolutely
Stats.my_counter(:my_sleep).counter = 0
Stats.my_gauge(:my_gauge).gauge = 23 

loop do 
  # Increment counter relatively
  Stats.my_counter(:my_sleep).count! 5
  # Set gauge absolutely
  Stats.my_gauge(:my_stack).gauge = rand(40)
  sleep 5
end
```

    
(Don't worry if this doesn't make sense - gauges and counters are explained 
below)

You can also **poll** for your data, if you feel comfortable with that:

```ruby
Stats.counter(:seconds_elapsed).polled_counter do
  Time.now.to_i
end
```

Test Application
--------------------

To test if your Ruby application is successfully sending metrics to CollectD, please use the [revett/collectd-carbon](https://github.com/revett/collectd-docker) Docker image (setup instructions in README).

