class BaseForm
  def initialize(params)
    @params = params
    @validated_params = nil
    @errors = nil
  end

  attr_accessor :errors, :validated_params
  attr_reader :model, :params

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  def valid?
    result = @contract.call(params)

    if result.success?
      @validated_params = result.values.data
      true
    else
      @errors = result.errors.to_h
      false
    end
  end

  def persisted?
    false
  end

  private

  def persist!
    raise I18n.t('dry_validation.errors.unimplemented')
  end
end
