class Company < ActiveRecord::Base
  validates_presence_of :name, :address1, :zipcode, :city, :state, :country
  has_many :phones, :as => :has_phones
end
