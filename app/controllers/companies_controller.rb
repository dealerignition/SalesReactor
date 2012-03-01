class CompaniesController < ApplicationController

  def index
    @companies = Company.limit(5)
  end

  def show
    @company = Company.find request[:id]
  end

  def edit
    @company = Company.find request[:id]
  end

  def new
    @company = Company.new
  end

end
