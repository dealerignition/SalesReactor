require 'spec_helper'

describe "companies/index.html.haml" do
  before do
    assign(:companies, 
           [stub_model(Company), stub_model(Company)])
    render
  end

  it "should render all the companies" do
    view.should render_template :partial => "_company",
      :count => 2
  end

  it "should have a search box" do
    rendered.should contain "Search"
  end
end
