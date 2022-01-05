require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }

    context 'Authenticated user' do
      before { login user }

      context "author of file's parent" do
        let!(:file_parent) { create(:question, user: user, files: [file]) }

        it 'can remove attachment' do
          expect { delete :destroy, params: { id: file_parent.files.first }, format: :js }.to change(file_parent.files, :count).by(-1)
        end

        it 'render destroy' do
          delete :destroy, params: { id: file_parent.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context "not author of file's parent" do
        let!(:file_parent) { create(:question, user: create(:user), files: [file]) }

        it 'can not remove attachment' do
          expect { delete :destroy, params: { id: file_parent.files.first }, format: :js }.to_not change(file_parent.files, :count)
        end

        it 'render destroy' do
          delete :destroy, params: { id: file_parent.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end

    context 'Unuthenticated user' do
      let!(:file_parent) { create(:question, user: user, files: [file]) }

      it 'can not remove files' do
        expect { delete :destroy, params: { id: file_parent.files.first }, format: :js }.to_not change(file_parent.files, :count)
      end

      it 'redirect to login page' do
        delete :destroy, params: { id: file_parent.files.first }, format: :js
        expect(response).to have_http_status(401)
      end
    end
  end
end
