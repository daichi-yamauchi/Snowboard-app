require 'rails_helper'

RSpec.describe 'MicropostsInterfaces', type: :system do
  subject { page }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    create_list(:micropost, 50, user: user)
    login(user)
    visit root_path
  end

  describe 'check display of home page' do
    it { is_expected.to have_selector 'input[type="file"' }
    it { expect(first(:css, 'section.user_info')).to have_text "#{user.microposts.count} microposts" }
    it { is_expected.to have_selector 'ul.pagination' }
    it { is_expected.to have_link 'delete' }
    it '0 and 1 micropost is displayed correctly' do
      login(other_user)
      visit root_path
      expect(first(:css, 'section.user_info')).to have_text '0 microposts'
      create(:micropost, user: other_user)
      visit root_path
      expect(first(:css, 'section.user_info')).to have_text '1 micropost'
    end
  end

  describe 'check display of other_user page' do
    before do
      create_list(:micropost, 3, user: other_user)
      visit user_path(other_user)
    end
    it { is_expected.to have_no_link 'delete' }
  end

  describe 'post micropost' do
    context 'empty micropost' do
      before do
        fill_in 'micropost[content]', with: ''
        click_button 'Post'
      end

      it { is_expected.to have_selector 'div#error_explanation' }
      it { is_expected.to have_selector 'ul.pagination a[rel="next"][href="/?page=2"]' }
    end

    context 'valid micropost' do
      let(:content) { 'おはよう' }
      let(:post_micropost) do
        fill_in 'micropost[content]', with: content
        # find('input[type="file"]').click
        # attach_file 'input[type="file"]', 'spec/fixtures/images/kitten.jpg'
        find('input[type="file"]').set('spec/fixtures/images/kitten.jpg')
        click_button 'Post'
      end

      it { expect { post_micropost }.to change(Micropost, :count).by(1) }

      describe 'after post' do
        before { post_micropost }
        it { is_expected.to have_current_path root_path }
        it { is_expected.to have_text content }
        it { is_expected.to have_selector 'span.content>img' }
      end
    end
  end

  describe 'delete micropost' do
    it 'Micropost.count decrease of 1' do
      before_count = Micropost.count
      accept_alert { first(:css, 'a[data-method="delete"]').click }
      expect(page).to have_selector 'div.alert-success'
      expect(Micropost.count).to eq before_count - 1
    end
  end
end
