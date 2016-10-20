# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# --------
# Okr Role 
# --------

admin_role = OkrRole.create!(name: "Admin", description: "Admin is the one who controls everything in the system.")
team_lead_role = OkrRole.create!(name: "Team Lead", description: "Team Lead manages the team.")
employee_role = OkrRole.create!(name: "Employee", description: "Employee is the basic unit of a company.")

# ------------------------
# Security and Role Module 
# ------------------------

# Control Type 

company_okr_control = ControlType.create!(okr_system_type: "Company OKR")
team_okr_control = ControlType.create!(okr_system_type: "Team OKR")
user_control = ControlType.create!(okr_system_type: "User Admin")
team_control = ControlType.create!(okr_system_type: "Team Admin")
timeframe_control = ControlType.create!(okr_system_type: "Timeframe Control")
feedback_control = ControlType.create!(okr_system_type: "Feedback Control")

# Controls

create_company_okr = Control.create!(details: "Create Company OKR", control_type_id: company_okr_control.id)
edit_company_okr = Control.create!(details: "Edit Company OKR", control_type_id: company_okr_control.id)
delete_company_okr = Control.create!(details: "Delete Company OKR", control_type_id: company_okr_control.id)
create_team_okr = Control.create!(details: "Create Team OKR", control_type_id: team_okr_control.id)
edit_team_okr = Control.create!(details: "Edit Team OKR", control_type_id: team_okr_control.id)
delete_team_okr = Control.create!(details: "Delete Team OKR", control_type_id: team_okr_control.id)
create_user = Control.create!(details: "Create User", control_type_id: user_control.id)
edit_user_info = Control.create!(details: "Edit User Information", control_type_id: user_control.id)
delete_user = Control.create!(details: "Delete User", control_type_id: user_control.id)
view_system_users_info = Control.create!(details: "View System Users Information", control_type_id: user_control.id)
create_team = Control.create!(details: "Create Team", control_type_id: team_control.id)
edit_team_info = Control.create!(details: "Edit Team Information", control_type_id: team_control.id)
delete_team = Control.create!(details: "Delete Team", control_type_id: team_control.id)
view_system_teams_info = Control.create!(details: "View System Teams Information", control_type_id: team_control.id)
set_time_interval = Control.create!(details: "Set time interval for particular year", control_type_id: timeframe_control.id)
view_system_timeframes = Control.create!(details: "View System Timeframes", control_type_id: timeframe_control.id)
view_future_timeframes = Control.create!(details: "View Future Timeframes", control_type_id: timeframe_control.id)
view_feedbacks = Control.create!(details: "View Feedbacks", control_type_id: feedback_control.id)

# Assign basic role to controls
# Admin
OkrRoleControl.create!(okr_role_id: admin_role.id, control_id: create_company_okr.id)
OkrRoleControl.create!(okr_role_id: admin_role.id, control_id: edit_company_okr.id)
OkrRoleControl.create!(okr_role_id: admin_role.id, control_id: delete_company_okr.id)
OkrRoleControl.create!(okr_role_id: admin_role.id, control_id: create_team_okr.id)
OkrRoleControl.create!(okr_role_id: admin_role.id, control_id: edit_team_okr.id)
OkrRoleControl.create!(okr_role_id: admin_role.id, control_id: delete_team_okr.id)
OkrRoleControl.create!(okr_role_id: admin_role.id, control_id: create_user.id)
OkrRoleControl.create!(okr_role_id: admin_role.id, control_id: edit_user_info.id)
OkrRoleControl.create!(okr_role_id: admin_role.id, control_id: delete_user.id)
OkrRoleControl.create!(okr_role_id: admin_role.id, control_id: view_system_users_info.id)
OkrRoleControl.create!(okr_role_id: admin_role.id, control_id: create_team.id)
OkrRoleControl.create!(okr_role_id: admin_role.id, control_id: edit_team_info.id)
OkrRoleControl.create!(okr_role_id: admin_role.id, control_id: delete_team.id)
OkrRoleControl.create!(okr_role_id: admin_role.id, control_id: view_system_teams_info.id)
OkrRoleControl.create!(okr_role_id: admin_role.id, control_id: set_time_interval.id)
OkrRoleControl.create!(okr_role_id: admin_role.id, control_id: view_system_timeframes.id)
OkrRoleControl.create!(okr_role_id: admin_role.id, control_id: view_future_timeframes.id)
OkrRoleControl.create!(okr_role_id: admin_role.id, control_id: view_feedbacks.id)
# Team Lead
OkrRoleControl.create!(okr_role_id: team_lead_role.id, control_id: create_team_okr.id)
OkrRoleControl.create!(okr_role_id: team_lead_role.id, control_id: edit_team_okr.id)
OkrRoleControl.create!(okr_role_id: team_lead_role.id, control_id: delete_team_okr.id)
OkrRoleControl.create!(okr_role_id: team_lead_role.id, control_id: edit_team_info.id)
OkrRoleControl.create!(okr_role_id: team_lead_role.id, control_id: view_future_timeframes.id)
# Employee
OkrRoleControl.create!(okr_role_id: employee_role.id, control_id: view_future_timeframes.id)

# ----------------
# Timeframe Module 
# ----------------

timeframe = Timeframe.create!(year: "2016", timeframe_type: "Quarterly")

TimeframeLog.create!(start_date: "2016-01-01", end_date: "2016-03-31", timeframe_id: timeframe.id, quarter: "Q1 2016")
TimeframeLog.create!(start_date: "2016-04-01", end_date: "2016-06-30", timeframe_id: timeframe.id, quarter: "Q2 2016")
TimeframeLog.create!(start_date: "2016-07-01", end_date: "2016-09-30", timeframe_id: timeframe.id, quarter: "Q3 2016")
TimeframeLog.create!(start_date: "2016-10-01", end_date: "2016-12-31", timeframe_id: timeframe.id, quarter: "Q4 2016")





