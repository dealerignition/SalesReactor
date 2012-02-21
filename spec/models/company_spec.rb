require 'spec_helper'

describe Company do
  it { should validate_presence_of :name }
  it { should validate_presence_of :address1 }
  it { should validate_presence_of :zipcode }
  it { should validate_presence_of :city }
  it { should validate_presence_of :state }
  it { should validate_presence_of :country }
  it { should have_many :phones }
  it { should have_many :contacts }
  it { should have_many :programs }
end
