require 'spec_helper'

describe CompaniesController do
  before do
    @company1 = Company.create!(:zipcode => 29600,
      :name => "XYZ, Inc.",
      :city => "Greenville",
      :state => "SC",
      :country => "USA"
    )
    @company2 = Company.create!(:zipcode => 29600,
      :name => "ABC, Inc.",
      :city => "Greenville",
      :state => "SC",
      :country => "USA"
    )
  end

  describe "GET 'show'" do
    before do
      get :show, :id => 1
    end

    it { should respond_with :success }
    it { should assign_to(:company).with(@company1) }
    it { should render_template :show }

  end

  describe "GET 'index'" do
    before do
      get :index
    end

    it { should respond_with :success }
    it { should assign_to(:companies).with([@company1, @company2]) }
    it { should render_template :index }

  end

  describe "GET 'edit'" do
    before do
      get :edit, :id => 1
    end

    it { should respond_with :success }
    it { should assign_to(:company).with(@company1) }
    it { should render_template :edit }
  end

  describe "GET 'new'" do
    before do
      get :new
    end

    it { should respond_with :success }
    it { should assign_to(:company).with_kind_of(Company) }
    it { should render_template :new }
  end

end
