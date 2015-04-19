require 'faye/websocket'
require 'eventmachine'
require 'json'

module EGMidi

  class Socket

    def initialize url, &block
      EM.run {
        puts url
        @ws = Faye::WebSocket::Client.new(url, [], {})
        if EGMidi.logging
          @ws.onopen = lambda { |event| EGMidi.log "WebSocket Connection opened" }
        end
        @ws.onmessage = lambda { |msg| block.call(JSON.parse(msg.data)['sparks']) }
      }
    end

  end

end
