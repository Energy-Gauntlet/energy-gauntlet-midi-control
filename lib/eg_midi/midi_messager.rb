require 'eventmachine'
require 'unimidi'

require_relative './midi_map'

module EGMidi

  class MidiMessager

    include MidiMap

    @@inverted_midi = {}

    attr_accessor :octave, :key

    def initialize config = {}
      @octave = config[:octave] || 5
      @key    = config[:key]    || :c
      enable_logging if config[:logging]
    end

    def play note
      if logging
        EGMidi.log "Playing Octave: #{@octave} Key: #{@key} Note: #{get_letter_for_note note}"
      end
      EM.run do
        out.puts 0x90, get_midi_for_note(note), 100
        out.puts 0x80, get_midi_for_note(note), 100
      end
    end

    def logging
      @logging || false
    end

    def disable_logging
      @logging = true
    end

    def enable_logging
      @logging = true
    end

    protected

      def out
        @out ||= UniMIDI::Output.first
      end

      def get_letter_for_note note
        if note.is_a? Fixnum
          inverted_midi[get_midi_for_note note]
        else
          note
        end
      end

      def get_midi_for_note note
        if note.is_a? Fixnum
          @@keys[@octave][@key][:midi][note]
        else
          @@keys[@octave][@key][note]
        end
      end

    private

      def inverted_midi
        @@inverted_midi["#{@octave}-#{@key}"] ||= @@keys[@octave][@key].invert
      end

  end

end
