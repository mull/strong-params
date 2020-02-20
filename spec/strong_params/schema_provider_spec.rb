
RSpec.describe StrongParams::SchemaProvider do
  subject(:provider) { StrongParams.of(Post) }

  describe '#required' do
    let(:attribute) { :title }

    subject { provider.require(attribute) }

    it 'provides a schema that requires the given attribute' do
      result = subject.call({})
      expect(result.errors.to_h).to have_key(:title)
    end
  end

  describe '#optional' do
    let(:attribute) { :title }

    subject { provider.optional(attribute) }

    it 'provides a schema where the attribute is optional' do
      result = subject.call({})
      expect(result.errors.to_h).not_to have_key(:title)
    end
  end
end
