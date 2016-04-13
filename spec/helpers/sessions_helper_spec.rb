require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  include SessionsHelper

  before do
    @manager = create(:user_waiter,manager: true, email: 'sanjica@rbt.com')
    @user_waiter = create(:user_waiter)
  end

  describe 'login' do
    context 'when manager is logged in' do
      before do
        log_in(@manager)
      end
      after do
        log_out
      end
      it 'saves user in session' do
        expect(session[:user_id]).to eq(@manager.id)
        expect(logged_in?).to eq(true)
        expect(is_manager?). to eq(true)
        expect(current_user).to eq(@manager)
      end
    end

    context 'when waiter is logged in' do
      before do
        log_in(@user_waiter)
      end
      after do
        log_out
      end
      it 'saves user in session' do
        expect(session[:user_id]).to eq(@user_waiter.id)
        expect(logged_in?).to eq(true)
        expect(is_manager?). to eq(false)
        expect(current_user).to eq(@user_waiter)
      end
    end
  end

  describe 'logout' do
    it 'there is no user in session' do
      expect(session[:user_id]).to eq(nil)
      expect(logged_in?).to eq(false)
      expect(current_user).to be_falsey
    end
  end
end
