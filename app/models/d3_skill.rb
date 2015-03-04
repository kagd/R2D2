class D3Skill < ActiveRecord::Base
  # disable STI
  self.inheritance_column = :_type_disabled

  belongs_to :hero, class_name: 'D3Hero'
  has_one :rune, class_name: 'D3Rune', dependent: :destroy
end
