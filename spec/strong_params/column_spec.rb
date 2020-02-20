RSpec.describe StrongParams::Column do
  shared_examples_for "correct type return" do |attribute, expected_type|
    def resolve(attr)
      StrongParams::Column.of(AllTypes, attr)
    end


    describe "#{attribute}" do
      subject(:result) { resolve(column) }

      describe "as scalar" do
        describe "nullable" do
          let(:column) { "#{attribute}_nullable" }

          it { is_expected.to be_a(expected_type) }
          it { is_expected.to be_nullable }
        end

        describe "not null" do
          let(:column) { "#{attribute}_not_nullable" }

          it { is_expected.to be_a(expected_type) }
          it { is_expected.not_to be_nullable }
        end
      end

      describe "as array" do
        describe "nullable" do
          let(:column) { "#{attribute}_array_nullable" }

          it { is_expected.to be_a(StrongParams::Types::Array) }
          it { is_expected.to be_nullable }

          it 'subtypes' do
            expect(result.subtype).to be_a(expected_type)
          end
        end

        describe "not null" do
          let(:column) { "#{attribute}_array_not_nullable" }

          it { is_expected.to be_a(StrongParams::Types::Array) }
          it { is_expected.not_to be_nullable }

          it 'subtypes' do
            expect(result.subtype).to be_a(expected_type)
          end
        end
      end
    end
  end

  describe '.of' do
    include_examples "correct type return", :string, StrongParams::Types::String
    # include_examples "correct type return", :text, StrongParams::Types::String
    # include_examples "correct type return", :integer, StrongParams::Types::Integer
    # include_examples "correct type return", :bigint, StrongParams::Types::Integer
    # include_examples "correct type return", :float, StrongParams::Types::Float
    # include_examples "correct type return", :decimal, StrongParams::Types::Decimal
    # include_examples "correct type return", :numeric, StrongParams::Types::Decimal
    # include_examples "correct type return", :datetime, StrongParams::Types::DateTime
    # include_examples "correct type return", :time, StrongParams::Types::Time
    # include_examples "correct type return", :date, StrongParams::Types::Date
    # include_examples "correct type return", :binary, StrongParams::Types::Binary
    # include_examples "correct type return", :boolean, StrongParams::Types::Boolean
    # include_examples "correct type return", :fake_enum, StrongParams::Types::Enum
  end
end
