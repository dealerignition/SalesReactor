class Phone < ActiveRecord::Base
  validates_presence_of :phone_type
  validates_presence_of :number
  belongs_to :has_phones, :polymorphic => true, :dependent => :destroy
end
