RSpec.describe StrongParams do
  it "has a version number" do
    expect(StrongParams::VERSION).not_to be nil
  end

  describe '.of' do
    subject { StrongParams.of(Post) }

    it { is_expected.to be_a(StrongParams::SchemaProvider) }

    it 'holds all columns of the model' do
      expect(subject.columns.keys).to eq(Post.column_names.map(&:to_sym))
    end
  end
end
