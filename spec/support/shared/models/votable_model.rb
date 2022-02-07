shared_examples 'votable model' do
  it { should have_many(:votes).dependent(:destroy) }

  describe '#rating' do
    let(:model_klass) { described_class.name.underscore.to_sym }
    let(:user) { create(:user) }
    let(:votable) { create(model_klass) }
  end
end
