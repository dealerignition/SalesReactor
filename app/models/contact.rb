class Contact < ActiveRecord::Base
  has_many :phones, :as => :has_phones
  validates_presence_of :name
end
