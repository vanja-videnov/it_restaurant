require 'rails_helper'

RSpec.describe Manager::ReportsController, type: :controller do
  include SessionsHelper
  subject(:report) { Report.new(date: date, table_id: table, category_id: category, subcategory_id: subcategory, item_id: item)}
  let(:date) { Date.current.to_s }
  let(:table) { create(:table) }
  let(:category) { create(:category) }
  let(:subcategory) { create(:subcategory) }
  let(:item) { create(:item)}
  it { expect(report).to be_valid }

  before do
    report.save
    @manager = create(:user_waiter, manager:true, email:'vanjaaaaa@rbt.ccc')
    @user_waiter = create(:user_waiter)
    log_in(@manager)
  end
  after do
    log_out
  end
  describe 'GET #show' do

    context 'when is manager' do
      it 'renders the show view' do
        get :daily
        expect(response).to render_template :show
        expect(assigns(:reports)).to eq(Report.where(date: date))
        expect(assigns(:per_category)).to eq(Report.joins(:category).where(date: date).group(:table_id, :category_id).select('reports.*, count(category_id) as category_count'))
        expect(assigns(:per_table)).to eq(Report.where(date: date).group(:table_id, :item_id).order('table_id asc'))
        expect(assigns(:item_per_table)).to eq(Report.where(date: date).group(:table_id).select('reports.*, count(table_id) as table_count'))
        expect(assigns(:per_items)).to eq(Report.where(date: date).joins(:item).group('item_id').select('reports.*, count(item_id) as item_count'))

      end

      it 'shows per item report if is selected' do
        get :items
        expect(assigns(:per_items)).to eq(Report.all.joins(:item).group('item_id').select('reports.*, count(item_id) as item_count'))
      end

      it 'shows per table report if is selected' do
        get :tables
        expect(assigns(:item_per_table)).to eq(Report.all.group(:table_id).select('reports.*, count(table_id) as table_count'))
        expect(assigns(:per_table)).to eq(Report.all.group(:table_id, :item_id).order('table_id asc'))
      end

      it 'shows per category report if is selected' do
        get :categories
        expect(assigns(:per_category)).to eq(Report.all.joins(:category).group(:table_id, :category_id).select('reports.*, count(category_id) as category_count'))
      end
    end

    context 'when is not manager' do
      before do
        log_out
        log_in(@user_waiter)
      end
      after do
        log_out
        log_in(@manager)
      end
      it 'dont render the show view' do
        get :daily
        expect(response).to redirect_to root_path
      end

      it 'dont assign report' do
        get :daily
        expect(assigns(:per_items)).to eq(nil)
      end
    end

    context 'when is not logged in' do
      before do
        log_out
      end
      after do
        log_in(@manager)
      end
      it 'dont render the show view' do
        get :daily
        expect(response).to redirect_to root_path
      end

      it 'dont assign report' do
        get :daily
        expect(assigns(:per_items)).to eq(nil)
      end
    end
  end
end
