class Program < ActiveRecord::Base
  belongs_to :company, :dependent => :destroy
  validates_presence_of :type
  has_many :contacts, :as => :has_contacts
end
