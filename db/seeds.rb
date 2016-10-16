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

OkrRole.create!(name: "Admin", description: "Admin is the one who controls everything in the system.")
OkrRole.create!(name: "Team Lead", description: "Team Lead manages the team.")
OkrRole.create!(name: "Employee", description: "Employee is the basic unit of a company.")

# ------------------------
# Security and Role Module 
# ------------------------

# Control Type 

company_okr_control = ControlType.create!(okr_system_type: "Company OKR")
team_okr_control = ControlType.create!(okr_system_type: "Team OKR")
user_control = ControlType.create!(okr_system_type: "User Admin")
team_control = ControlType.create!(okr_system_type: "Team Admin")
timeframe_control = ControlType.create!(okr_system_type: "Timeframe Control")

# Controls

Control.create!(details: "Create Company OKR", control_type_id: company_okr_control.id)
Control.create!(details: "Edit Company OKR", control_type_id: company_okr_control.id)
Control.create!(details: "Delete Company OKR", control_type_id: company_okr_control.id)
Control.create!(details: "Create Team OKR", control_type_id: team_okr_control.id)
Control.create!(details: "Edit Team OKR", control_type_id: team_okr_control.id)
Control.create!(details: "Delete Team OKR", control_type_id: team_okr_control.id)
Control.create!(details: "Create User", control_type_id: user_control.id)
Control.create!(details: "Edit User Information", control_type_id: user_control.id)
Control.create!(details: "Delete User", control_type_id: user_control.id)
Control.create!(details: "View System Users Information", control_type_id: user_control.id)
Control.create!(details: "Create Team", control_type_id: team_control.id)
Control.create!(details: "Edit Team Information", control_type_id: team_control.id)
Control.create!(details: "Delete Team", control_type_id: team_control.id)
Control.create!(details: "View System Teams Information", control_type_id: team_control.id)
Control.create!(details: "Set time interval for particular year", control_type_id: timeframe_control.id)
Control.create!(details: "View System Timeframes", control_type_id: timeframe_control.id)

# ----------------
# Timeframe Module 
# ----------------

timeframe = Timeframe.create!(year: "2016", timeframe_type: "Quarterly")

TimeframeLog.create!(start_date: "2016-01-01", end_date: "2016-03-31", timeframe_id: timeframe.id)
TimeframeLog.create!(start_date: "2016-04-01", end_date: "2016-06-30", timeframe_id: timeframe.id)
TimeframeLog.create!(start_date: "2016-07-01", end_date: "2016-09-30", timeframe_id: timeframe.id)
TimeframeLog.create!(start_date: "2016-10-01", end_date: "2016-12-31", timeframe_id: timeframe.id)





