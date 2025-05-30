local isRecording = false
local badgeNumber = nil
local Framework
local isOnDuty = false
local isBodycamOn = false

-- Framework init
CreateThread(function()
    while not Framework do
        if Config.Framework == 'qb' then
            Framework = exports['qb-core']:GetCoreObject()
        elseif Config.Framework == 'esx' then
            Framework = exports['es_extended']:getSharedObject()
        end
        Wait(100)
    end
end)

-- Check Permission
function IsAllowedToUse()
    local PlayerData

    if not Framework then
        print("^1[ERROR] Framework not loaded yet.")
        return false
    end

    if Config.Framework == 'qb' then
        PlayerData = Framework.Functions.GetPlayerData()
    elseif Config.Framework == 'esx' then
        PlayerData = Framework.GetPlayerData()
    end

    if not PlayerData or not PlayerData.job then
        print("^1[ERROR] PlayerData or PlayerData.job is nil.")
        return false
    end

    if Config.ToggleDutyCheck then
        PlayerData.job.onduty = isOnDuty
    end

    if Config.Debug then
        print("^3[DEBUG] Job Name: ^7" .. tostring(PlayerData.job.name))
        print("^3[DEBUG] On Duty: ^7" .. tostring(PlayerData.job.onduty))
        print("^3[DEBUG] isOnDuty (local): ^7" .. tostring(isOnDuty))
    end

    if Config.RequireDuty and not PlayerData.job.onduty then
        return false
    end

    return Config.AllowedJobs[PlayerData.job.name] == true
end

-- Dato & Time
function GetDateAndTime()
    local year, month, day, hour, minute, second = GetLocalTime()
    local date = string.format("%02d/%02d/%04d", day, month, year)
    local time = string.format("%02d:%02d:%02d", hour, minute, second)
    return date, time
end

-- Toggle bodycam
RegisterCommand("togglebodycam", function()
    if not IsAllowedToUse() then
        lib.notify({ title = 'Bodycam', description = 'You are not allowed to use this.', type = 'error' })
        return
    end

    if not badgeNumber then
        local input = lib.inputDialog('Enter Badge Info', {
            { type = 'input', label = 'Badge Number', placeholder = 'e.g. 18231' }
        })
        if not input or not input[1] or input[1] == '' then
            lib.notify({ title = 'Bodycam', description = 'You must enter a badge number.', type = 'error' })
            return
        end
        badgeNumber = input[1]
    end

    local date, time = GetDateAndTime()

    if isBodycamOn then
        SendNUIMessage({ type = "stopRecording" })
        TriggerServerEvent("bodycam:uploadFootage", badgeNumber)
        isRecording = false
        isBodycamOn = false
        lib.notify({ title = 'Bodycam', description = 'Bodycam is now OFF.', type = 'error' })
    else
        SendNUIMessage({
            type = "startRecording",
            badge = badgeNumber,
            date = date,
            time = time,
            unit = Config.BodycamUnitPrefix,
            id = math.random(10000, 99999),
        })
        isRecording = true
        isBodycamOn = true
        lib.notify({ title = 'Bodycam', description = 'Bodycam is now ON.', type = 'success' })

        Wait(Config.RecordingDuration * 1000)

        SendNUIMessage({ type = "stopRecording" })
        TriggerServerEvent("bodycam:uploadFootage", badgeNumber)
        isRecording = false
        isBodycamOn = false
    end
end)

-- Toggle duty
RegisterCommand("toggleduty", function()
    isOnDuty = not isOnDuty
    local dutyStatus = isOnDuty and "ON" or "OFF"
    lib.notify({ title = 'Duty Status', description = 'You are now ' .. dutyStatus .. ' duty.', type = isOnDuty and 'success' or 'error' })

    if Config.Debug then
        print("^3[DEBUG] Toggled duty status. New isOnDuty: ^7" .. tostring(isOnDuty))
    end
end, false)

-- Key mappings
RegisterKeyMapping('togglebodycam', 'Toggle Bodycam Recording', 'keyboard', 'F10')
RegisterKeyMapping('toggleduty', 'Toggle Duty Status', 'keyboard', 'F9')
