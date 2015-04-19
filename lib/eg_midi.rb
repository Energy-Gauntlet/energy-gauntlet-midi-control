require 'rubygems'
require 'bundler/setup'

require_relative './eg_midi/socket'
require_relative './eg_midi/commander'
require_relative './eg_midi/midi_messager'

module EGMidi

  def self.run config, &block
    enable_logging if config[:logging]
    commander = Commander.new({
      'flex_0' => {
        high: 1800,
        low:  1350
      },
      'flex_1' => {
        high: 2100,
        low:  1200
      },
      'x' => {
        high: 2800,
        low:  1600
      },
      'y' => {
        high: 3000,
        low:  1200
      }
    })
    ws = Socket.new(config[:socket_url]) do |raw|
      [
        commander.parse(raw['right']),
        commander.parse(raw['left'])
      ].flatten.each do |proc|
        proc.call
      end
    end
  end

  def self.log msg
    puts "#{Time.now.strftime('%s')} #{msg}"
  end

  def self.logging
    @logging || false
  end

  def self.enable_logging
    @logging = true
  end

end
