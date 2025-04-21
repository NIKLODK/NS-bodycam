Config = {}

-- Choose 'qbcore' or 'esx'
Config.Framework = 'FRAMEWORK'

-- Choose Time Duration
Config.RecordingDuration = 100000

-- API Key from your FiveManage panel
Config.FiveManageAPIKey = 'APIKEY' -- DOES NOT WORK

-- Whether bodycam requires duty status
Config.RequireDuty = false 
Config.ToggleDutyCheck = false 

-- Debug option
Config.Debug = true

-- Your server name / unit format
Config.BodycamUnitPrefix = 'NIKLO BODYCAM'

Config.AllowedJobs = {
    ['police'] = true,
    ['sheriff'] = true,
}
