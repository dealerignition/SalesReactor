class Phone < ActiveRecord::Base
  validates_presence_of :type, :number
  belongs_to :has_phones, :polymorphic => true
end
