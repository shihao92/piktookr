class Notification < ApplicationRecord

  # ---------
  # Relations
  # ---------

  belongs_to    :sender,  class_name: "User", foreign_key: "sender_id"
  belongs_to    :receiver, class_name: "User", foreign_key: "receiver_id"

  # -----------
  # Validations
  # -----------
  validates     :notification_message, presence: true
  validates     :sender_id, presence: true
  validates     :receiver_id, presence: true
  validates     :read_status, presence: true


  def self.generate_notification_team_invitation(sender_id, receiver_id, team_id) 
    status = 0
    sender = User.find(sender_id)
    team = OkrTeam.find(team_id)
    notification = '<span class="bold">' + sender.last_name + ' ' + sender.first_name + '</span> invited you to join <span class="bold">' + team.name + '</span>'
    
    new_notification = Notification.new(notification_message: notification, sender_id: sender_id, receiver_id: receiver_id, notification_type: "TEAM", read_status: "PENDING")

    if new_notification.save
      OkrUserTeam.pending_team_invitation(team_id, receiver_id, new_notification.id)
      status = 200
    end
    return status
  end

  def self.accepted_team_invitation(notification_id)
    status = 0
    okr_user_team = OkrUserTeam.find_by(notification_id: notification_id)
    okr_team = OkrTeam.find(okr_user_team.okr_team_id)
    updated_message = 'You had accepted the invitation into team <span class="bold">' + okr_team.name + '</span>'
    if Notification.where(id: notification_id).update_all(notification_message: updated_message)
      status = 200
    end

    return status
  end

end
