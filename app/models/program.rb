class Program < ActiveRecord::Base
  belongs_to :company, :dependent => :destroy
  validates_presence_of :program_type
  validates_presence_of :category
  has_many :contacts, :as => :has_contacts
end
