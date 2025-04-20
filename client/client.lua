local isRecording = false
local badgeNumber = nil
local Framework
local isOnDuty = false
local isBodycamOn = false

-- Framework init
CreateThread(function()
    if Config.Framework == 'qb' then
        Framework = exports['qb-core']:GetCoreObject()
    elseif Config.Framework == 'esx' then
        Framework = exports['es_extended']:getSharedObject()
    end
end)

-- Check Permission
function IsAllowedToUse()
    local PlayerData

    if Config.Framework == 'qb' then
        PlayerData = Framework.Functions.GetPlayerData()
    elseif Config.Framework == 'esx' then
        PlayerData = Framework.GetPlayerData()
    end

    if Config.ToggleDutyCheck then
        PlayerData.job.onduty = isOnDuty
    end

    print("Player Job: " .. PlayerData.job.name)
    print("On Duty: " .. tostring(PlayerData.job.onduty))

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

RegisterKeyMapping('togglebodycam', 'Toggle Bodycam Recording', 'keyboard', 'F10')
