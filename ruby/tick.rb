class Tick
  attr_reader :time
  attr_accessor :mkts

  def initialize(time)
    @time = time
    @mkts = {}
  end
end

class TData
  attr_reader :latest
  attr_reader :volume

  def initialize(latest, volume)
    @latest = latest
    @volume = volume
  end
end