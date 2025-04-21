Config = {}

-- Choose 'qbcore' or 'esx'
Config.Framework = 'FRAMEWORK'

-- Choose Time Duration
Config.RecordingDuration = 1000000 -- SET TO HIGH NUMBER BECAUSE RECORD FUNCTION DOES NOT WORK!

-- API Key from your FiveManage panel
Config.FiveManageAPIKey = 'APIKEY' -- DOES NOT WORK

-- Whether bodycam requires duty status
Config.RequireDuty = false 
Config.ToggleDutyCheck = false 

-- Debug option
Config.Debug = false -- SET TO TRUE FOR DEBUG

-- Your server name / unit format
Config.BodycamUnitPrefix = 'NIKLO BODYCAM'

Config.AllowedJobs = {
    ['police'] = true,
    ['sheriff'] = true,
}
