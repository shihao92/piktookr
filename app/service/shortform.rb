class Shortform

  def self.get_string_shortform(input)
    shortform_string = ""
    shortform = input.scan(/[A-Z]/)
    counter = 0
    shortform.each do |item| 
      if counter < 2 
        shortform_string = shortform_string + item 
        counter = counter + 1
      end
    end

    return shortform_string
  end

end
