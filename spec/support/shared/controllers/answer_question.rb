shared_examples_for 'Answer Question' do
  before do
    do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
  end

  it 'returns 200 status if there is access_token' do
    expect(response).to be_successful
  end

  it 'returns all public fields' do
    public_fields.each do |attr|
      expect(resource_responce[attr]).to eq resource.send(attr).as_json
    end
  end

  describe 'comment' do
    let(:comment) { resource.comments.min_by(&:created_at) }
    let(:comment_response) { resource_responce['comments'].min_by { |item| item['created_at'] } }

    it 'returns list of comments' do
      expect(resource_responce['comments'].size).to eq 3
    end

    it 'returns all public fields' do
      %w[id text commentable_id created_at updated_at].each do |attr|
        expect(comment_response[attr]).to eq comment.send(attr).as_json
      end
    end
  end

  describe 'links' do
    let(:link) { resource.links.min_by(&:created_at) }
    let(:link_response) { resource_responce['links'].min_by { |item| item['created_at'] } }

    it 'returns list of comments' do
      expect(resource_responce['links'].size).to eq 3
    end

    it 'returns all public fields' do
      %w[id name url linkable_id created_at updated_at].each do |attr|
        expect(link_response[attr]).to eq link.send(attr).as_json
      end
    end
  end

  describe 'files' do
    it 'returns list of files' do
      expect(resource_responce['files'].size).to eq 2
    end
  end
end
