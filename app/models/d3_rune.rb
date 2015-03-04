class D3Rune < ActiveRecord::Base
  # disable STI
  self.inheritance_column = :_type_disabled

  belongs_to :skill, class_name: 'D3Skill'
end
