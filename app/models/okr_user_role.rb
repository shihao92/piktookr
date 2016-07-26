class OkrUserRole < ActiveRecord::Base

    # self.table_name = "okr_user_roles"
    belongs_to :user
    belongs_to :okr_role

end
