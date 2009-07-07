module EqTimeHelper
  def startms
    (start.to_f * 1000).to_i
  end
  
  def finishms
    (finish.to_f * 1000).to_i
  end
  
  def human_range
    DateRange.new(start..finish).to_s
    
    # start_year = start.year == finish.year ? "" : " %G"
    # finish_year = (start.year == finish.year && start.year == Time.now.year) ? "" : " %G"
    # 
    # if start.month == finish.month
    # else
    #   start
    # end
    # 
    # "#{start_month}#{start_day}#{start_time}#{start_year}-#{finish_month}#{finish_day}#{finish_time}#{finish_year}"
  end

end