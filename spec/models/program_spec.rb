require 'spec_helper'

describe Program do
  it { should validate_presence_of :program_type }
  it { should validate_presence_of :category }
  it { should belong_to(:company).dependent(:destroy) }
  it { should have_many :contacts }
end
