class Company < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :zipcode
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :country
  has_many :phones, :as => :has_phones
  has_many :contacts, :as => :has_contacts
  has_many :programs
end
