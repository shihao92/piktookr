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

  # Linkage to notification module
  has_many  :sender_users, class_name: 'Notification', foreign_key: 'sender_id'
  has_many  :receiver_users, class_name: 'Notification', foreign_key: 'receiver_id'
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  # Validations on the entities
  validates   :email, presence: true, :format => { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
                                                   message: 'Is not a valid email address' }
  validates   :password, presence: true, length: { minimum: 5 }, confirmation: true
  validates   :last_name, presence: true
  validates   :first_name, presence: true
  enum status: { active: 0, inactive: 1 }
  validates   :position, presence: true, length: { minimum: 2 }
  

  def self.return_users_lists_not_in_team(team_id, current_user_id) 
    okr_user_teams = OkrUserTeam.where(okr_team_id: team_id)
    users_list = Array.new
    users = User.all
    users.each do |item|
      if current_user_id != item.id
        users_list << item.id
      end
    end 
    okr_user_teams.each do |user|
      users_list.delete(user.user_id)
    end
    
    return users_list
  end

  # Method to remove particular user from the system
  def self.remove_user(user_id)
    status = 0
    # Remove from contribution module
    log_personal_key_results = LogPersonalKeyResult.where(user_id: user_id)
    log_personal_key_results.each do |item|
      Contribution.where(log_personal_key_result_id: item.id).destroy_all()
    end
    # Remove from logs module
    LogPersonalKeyResult.where(user_id: user_id).destroy_all()
    LogPersonalObjective.where(user_id: user_id).destroy_all()
    LogTeamKeyResult.where(user_id: user_id).destroy_all()
    LogTeamObjective.where(user_id: user_id).destroy_all()
    LogCompanyKeyResult.where(user_id: user_id).destroy_all()
    LogCompanyObjective.where(user_id: user_id).destroy_all()
    # Remove from OKR Management Module    
    personal_objectives = PersonalObjective.where(user_id: user_id)
    personal_objectives.each do |item|
      OkrTeamPersonal.where(personal_objective_id: item.personal_objective_id)
    end
    personal_objectives.destroy_all()
    TeamKeyResult.where(user_id: user_id).destroy_all()
    team_objectives = TeamObjective.where(user_id: user_id)
    team_objectives.each do |item|
      OkrTeamCompany.where(team_objective_id: item.id).destroy_all()
    end
    TeamObjective.where(user_id: user_id).destroy_all()
    CompanyKeyResult.where(user_id: user_id).destroy_all()
    CompanyObjective.where(user_id: user_id).destroy_all()
    # Remove from OKR Team Module
    OkrUserTeam.where(user_id: user_id).destroy_all()
    # Remove from OKR Role Module
    OkrUserRole.where(user_id: user_id).destroy_all()
    # Remove from user table
    User.where(id: user_id).destroy_all()

    status = 200
    return status
  end

  def self.search_user_except_self(keyword, current_user_id)
    users = User.select("id, avatar_file_name, last_name, first_name, position")
                .where("(last_name like ? or first_name like ?) and id != #{current_user_id}", "%#{keyword}%", "%#{keyword}%")
    return users
  end

end
