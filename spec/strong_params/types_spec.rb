RSpec.describe StrongParams::Types do
  let(:model) { AllTypes }

  subject(:type) { StrongParams::Column.of(model, column_name) }

  describe StrongParams::Types::Enum do
    describe '#external_values' do
      subject { type.external_values }

      describe 'from an integer Rails column defined as enum in model' do
        let(:column_name) { :fake_enum_nullable }

        it "has the same values as the enum" do
          is_expected.to eq(model::ENUM_OPTIONS_FAKE.keys.map(&:to_s))
        end
      end
    end
  end
end
