module EGMidi

  class Commander

    attr_reader :config

    attr_accessor :messager1, :messager2

    def initialize config = {}
      @config   = config
      @messager1 = EGMidi::MidiMessager.new({ logging: EGMidi.logging })
      @messager2 = EGMidi::MidiMessager.new({ logging: EGMidi.logging, octave: 6 })
    end

    def parse raw
      if raw['connected'] == false
        []
      else
        x = normalize 'x', raw
        y = normalize 'y', raw

        @messager1.octave = 8 - (x * 8).round
        @messager2.octave = 8 - (x * 8).round

        if raw['button_0'] == 1
          f0 = normalize 'flex_0', raw

          [
            lambda { messager1.play((f0 * 6).round) }
          ]
        else
          f1 = normalize 'flex_1', raw

          [
            lambda { messager2.play((f1 * 6).round) }
          ]
        end
      end
    end

    def fix_range key, raw
      val = raw[key].to_f
      if val > config[key][:high] then return config[key][:high].to_f end
      if val < config[key][:low]  then return config[key][:low].to_f  end
      return val
    end

    def normalize key, raw
      val = fix_range key, raw
      (val - config[key][:low]) / (config[key][:high] - config[key][:low])
    end

  end

end
