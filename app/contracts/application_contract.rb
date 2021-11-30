class ApplicationContract < Dry::Validation::Contract
  config.messages.load_paths << 'config/locales/errors.yml'
end