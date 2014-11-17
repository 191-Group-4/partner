class Project < ActiveRecord::Base
   has_many :groups, :through => :group_relations
   has_many :evaluations
   belongs_to :user
   has_many :users, :through => :group_relations
   has_many :group_relations
   belongs_to :group
   has_many :courses, :through => :group_relations, :source => :course

   enum name_gen: [:numbered, :hacker, :creatures, :colors]
end
