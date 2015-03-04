class D3ItemAttribute < ActiveRecord::Base
  # disable STI
  self.inheritance_column = :_type_disabled

  belongs_to :item, class_name: 'D3Item'
end
