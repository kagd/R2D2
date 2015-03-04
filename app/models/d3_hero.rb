class D3Hero < ActiveRecord::Base
  # disable STI
  self.inheritance_column = :_type_disabled

  # remove the class method since we have a class attribute
  class << self
    def instance_method_already_implemented?(method_name)
      return true if method_name == 'class'
      super
    end
  end

  has_many :skills, class_name: "D3Skill", dependent: :destroy
  has_many :items, class_name: 'D3Item', dependent: :destroy

  default_scope -> { order('name ASC') }
end
