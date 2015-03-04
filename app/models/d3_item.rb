class D3Item < ActiveRecord::Base
  belongs_to :hero, class_name: 'D3Hero'
  has_many :item_attributes, class_name: 'D3ItemAttribute', dependent: :destroy
end
