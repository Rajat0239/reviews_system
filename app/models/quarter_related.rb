module QuarterRelated

  def self.current_quarter
    ((Time.now.month - 1)/3+1).to_s+" "+(Time.now.year).to_s
  end

  def self.is_quarter_present
    ReviewDate.exists?(quarter: self.current_quarter)
  end

  def self.quarter_related_to_date(date)
    ((date.to_date.month-1)/3+1).to_s+" "+ date.to_date.year.to_s
  end

end
