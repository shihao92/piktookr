class User < ActiveRecord::Base

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

  # Linkage to log generation module
  has_many  :log_personal_key_result
  has_many  :log_personal_objective
  has_many  :log_team_key_result
  has_many  :log_team_objective
  has_many  :log_company_key_result
  has_many  :log_company_objective
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  # Validations on the entities
  validates   :email, presence: true, uniqueness: true, :format => { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
                                                                     message: 'Is not a valid email address' }
  validates   :password, presence: true, length: { minimum: 5 }, confirmation: true
  validates   :last_name, presence: true
  validates   :first_name, presence: true
  validates   :status, inclusion: { in: %w(ACTIVE INACTIVE), 
                                    message: "%{value} is not a valid status!"}
  validates   :position, presence: true, length: { minimum: 2 }
  

end
