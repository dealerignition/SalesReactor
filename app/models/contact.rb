class Contact < ActiveRecord::Base
  has_many :phones, :as => :has_phones
  belongs_to :has_contacts, :polymorphic => true, :dependent => :destroy
  validates_presence_of :name
end
