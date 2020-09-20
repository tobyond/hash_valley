require "active_model"
class HashNotProvidedError < StandardError; end

class HashValidator

  include ActiveModel::Validations

  # hash = {
  #   first_name: "",
  #   last_name: "Last",
  #   email: "first@last#error_email.com"
  # }
  # validations = {
  #   first_name: { presence: true },
  #   last_name: { inclusion: { in: ["Last", "Second Last"] }, allow_blank: true },
  #   email: { format: { with: URI::MailTo::EMAIL_REGEXP } }
  # }
  # validator = HashValidator.new(hash, validations)
  # validator.valid?
  # => false
  # validator.errors.messages
  # => {:first_name=>["can't be blank"], :email=>["is invalid"]}
  #
  # for a list of the validations available:
  # https://guides.rubyonrails.org/active_record_validations.html
  #
  # if you don't send in a validations hash then it will default to presence: true
  def initialize(methods, validations = {})
    raise HashNotProvidedError unless methods.is_a?(Hash)
    methods.each do |name, value|
      self.class.send(:attr_accessor, name)
      instance_variable_set("@#{name}", value)
    end
    methods.keys.each do |arg|
      self.class.class_eval do
        validates arg, validations[arg].presence || { presence: true }
      end
    end
  end
end
