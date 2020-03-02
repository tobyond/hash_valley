RSpec.describe HashValidator do
  before do
    HashValidator.clear_validators!
  end

  subject { validator.valid? }
  let(:validator) { HashValidator.new(methods, validations) }
  let(:methods) {
    {
      first_name: first,
      last_name: "Last",
      email: email,
      id: 1
    }
  }
  let(:first) { "First" }
  let(:validations) { {} }
  let(:email) { "first@last.com" }

  context "when validations hash is empty" do
    context "when all values are present" do
      it "is expected to validate presence only" do
        expect(subject).to be(true)
        expect(validator.errors.messages).to be_empty
      end
    end

    context "when email is blank" do
      let(:email) { nil }

      it "is expected to have error message" do
        expect(subject).to be(false)
        expect(validator.errors.messages).to eq({ email: ["can't be blank"] })
      end
    end
  end

  context "when validations hash is present" do
    let(:validations) {
      {
        email: { format: { with: URI::MailTo::EMAIL_REGEXP } },
        id: { inclusion: { in: ids } }
      }
    }
    let(:ids) { [1, 2] }

    context "when all values are present" do
      it "is expected to validate presence only" do
        expect(subject).to be(true)
        expect(validator.errors.messages).to be_empty
      end
    end

    context "when email is invalid and first_name is nil" do
      let(:email) { "first##*last.boo" }
      let(:first) { nil }

      it "is expected to fall back to presence for first, and have invalid error message for email" do
        expect(subject).to be(false)
        expect(validator.errors.messages)
          .to contain_exactly([:email, ["is invalid"]], [:first_name, ["can't be blank"]])
      end
    end
  end

  context "when hash is not sent" do
    let(:methods) { "string" }

    it "is expected to raise HashNotProvidedError" do
      expect { subject }.to raise_error(HashNotProvidedError)
    end

  end
end
