class User < ActiveRecord::Base

  #self.table_name = "users"

  # Linkage to role module
  has_one   :okr_user_role
  has_one   :okr_role, :through => :okr_user_role
  
  # Linkage to team module
  has_one   :team
  has_many  :okr_user_teams
  has_many  :okr_teams, :through => :okr_user_teams

  # Linkage to okr module
  has_many  :personal_objectives
  has_many  :team_key_results
  has_many  :team_objectives
  has_many  :company_key_results
  has_many  :company_objectives 
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

end
