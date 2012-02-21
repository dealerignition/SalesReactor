require 'spec_helper'

describe Phone do
  it { should validate_presence_of :type }
  it { should validate_presence_of :number }
  it { should belong_to(:has_phones).dependent(:destroy) }
end
