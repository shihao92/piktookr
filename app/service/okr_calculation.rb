class OkrCalculation

  def self.calculate_progress_contribution(progress, count) 
    progress_contribution = progress / count
    progress_contribution = progress_contribution.round(2)
    return progress_contribution
  end

end
