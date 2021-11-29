class BaseForm
  def save
    if valid?
      persist!
      true
    else
      false
    end
  end
end