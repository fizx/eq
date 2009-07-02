class Availability < Struct.new(:id, :label, :startms, :finishms)
  def initialize(interest, date, people)
    super
    self.label = people == 1 ? "1 person" : "#{people} people"
    self.id = "#{interest.id}-interest"
    self.startms = date.to_time.to_i * 1000
    self.finishms = (date + 1).to_time.to_i * 1000
  end
end