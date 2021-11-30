class BaseForm
  attr_accessor :errors, :validated_params
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