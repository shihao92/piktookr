class OkrRole < ActiveRecord::Base
 
    #self.table_name = "okr_roles"
    has_and_belongs_to_many :users
end
