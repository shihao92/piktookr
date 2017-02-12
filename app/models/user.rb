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
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:google_oauth2]

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "128x128>" }, default_url: "/searching-user.svg"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  validates_attachment_size :avatar, :in => 0.megabytes..2.megabytes

  # Validations on the entities
  validates   :email, presence: true, :format => { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
                                                   message: 'Is not a valid email address' }
  validates   :password, presence: true, length: { minimum: 5 }, confirmation: true, :unless => :user_update
  validates   :last_name, presence: true
  validates   :first_name, presence: true
  enum status: { inactive: 0, active: 1, removed: 2 }
  validates   :position, presence: true, length: { minimum: 2 }

  attr_accessor :user_update

  before_commit on: :update do
    true if self.user_update
    false
  end
  
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

    if User.where(id: user_id).update_all(status: 2)
      status = 200
    end
    return status
  end

  def self.search_user_except_self(keyword, current_user_id)
    users = User.select("id, avatar_file_name, last_name, first_name, position")
                .where("(LOWER(last_name) like LOWER(?) or LOWER(first_name) like LOWER(?)) and id != #{current_user_id}", "%#{keyword}%", "%#{keyword}%")
    return users
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.find_by(email: data["email"], status: 'active')
    return user
  end

end
