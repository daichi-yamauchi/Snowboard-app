require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:html_body) { mail.html_part.body.decoded }
  let(:text_body) { mail.text_part.body.decoded }

  describe 'account_activation' do
    before { user.activation_token = User.new_token }
    let(:mail) { UserMailer.account_activation(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('【スノメン】アカウントの有効化')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['noreply@snomen.jp'])
    end

    it 'renders the html body' do
      expect(html_body).to match(user.name)
      expect(html_body).to match('snomen.herokuapp.com')
      expect(html_body).to match(user.activation_token)
      expect(html_body).to match(CGI.escape(user.email))
    end

    it 'renders the text body' do
      expect(text_body).to match(user.name)
      expect(text_body).to match('snomen.herokuapp.com')
      expect(text_body).to match(user.activation_token)
      expect(text_body).to match(CGI.escape(user.email))
    end
  end

  describe 'password_reset' do
    before { user.reset_token = User.new_token }
    let(:mail) { UserMailer.password_reset(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('【スノメン】パスワードの再設定')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['noreply@snomen.jp'])
    end

    it 'renders the html body' do
      expect(html_body).to match(user.reset_token)
      expect(html_body).to match('snomen.herokuapp.com')
      expect(html_body).to match(CGI.escape(user.email))
    end

    it 'renders the text body' do
      expect(text_body).to match(user.reset_token)
      expect(text_body).to match('snomen.herokuapp.com')
      expect(text_body).to match(CGI.escape(user.email))
    end
  end
end
