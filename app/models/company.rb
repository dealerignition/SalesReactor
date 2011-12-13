class Company < ActiveRecord::Base
  belongs_to :category
  has_many :programs
end
