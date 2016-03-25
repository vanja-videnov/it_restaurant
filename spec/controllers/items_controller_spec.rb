require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  include SessionsHelper

  before do
    @manager = create(:user_waiter, manager: true)
    log_in(@manager)
  end
  after do
    log_out
  end

end
