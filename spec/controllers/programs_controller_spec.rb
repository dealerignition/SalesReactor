require 'spec_helper'

describe ProgramsController do
  before do
    @program1 = Program.create!(
      :program_type => "Retailer",
      :category => "Floor Coverings",
      :products => "Carpets",
      :trademarks => "Karastan",
      :notes => "Awesome.",
      :company => Company.first
    )
    @program2 = Program.create!(
      :program_type => "Retailer",
      :category => "Floor Coverings",
      :products => "Carpets",
      :trademarks => "Karastan",
      :notes => "Awesome.",
      :company => Company.first
    )
  end

  describe "GET 'index'" do
    before do
      get :index
    end

    it { should respond_with :success }
    it { should assign_to(:programs).with([@program1, @program2]) }
    it { should render_template :index }
  end

  describe "GET 'show'" do
    before do
      get :show, :id => 1
    end

    it { should respond_with :success }
    it { should assign_to(:program).with(@program1) }
    it { should render_template :show }
  end

  describe "GET 'edit'" do
    before do
      get :edit, :id => 1
    end

    it { should respond_with :success }
    it { should assign_to(:program).with(@program1) }
    it { should render_template :edit }
  end

end
