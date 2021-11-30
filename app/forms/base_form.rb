class BaseForm
  attr_reader :model
  
  def save
    if valid?
      persist!
      true
    else
      false
    end
  end
end