ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

    local playerCoords, inZone, lastZone
    local justEnter = true
    local justChecked = false
    
    while true do
        playerCoords, inZone = GetEntityCoords(PlayerPedId()), nil

        for index, data in ipairs(Config.Zones) do
            for index, bubble in ipairs(data.bubbles) do
                if Vdist(playerCoords, bubble.x, bubble.y, bubble.z) < bubble.w then
                    inZone = data

                    break
                end
            end

            if inZone then
                break
            end
        end

        if inZone and lastZone then
            if inZone ~= lastZone then
                if not justChecked then
                    justChecked = true
                    inZone = nil
                end
            else
                justChecked = false
            end
        end

        if inZone then
            if inZone ~= lastZone then
                justEnter = true
            end

            if justEnter then
                if (inZone.type == "green") then
                    SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
                    NetworkSetFriendlyFireOption(false)
                end

                ClearPlayerWantedLevel(PlayerId())             
                TriggerEvent("pNotify:SendNotification",{
                    text = ("<b style='color:#FFFFFF'>%s</b>"):format(inZone.enter),
                    type = "error",
                    timeout = (3000),
                    layout = "centerright",
                    queue = "global"
                })

                lastZone = inZone
                justEnter = false
            end

            if (inZone.type == "green") then
                DisablePlayerFiring(PlayerId(), true) 
                DisableControlAction(0, 288, true)
                DisableControlAction(0, 106, true) 
                DisableControlAction(2, 37, true)

                if IsDisabledControlJustPressed(2, 37) then 
                    SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)

                    TriggerEvent("pNotify:SendNotification",{
                        text = "<b style='color:#FFFFFF'>Nie możesz wykonać tej czynności!</b>",
                        type = "error",
                        timeout = (3000),
                        layout = "centerright",
                        queue = "global"
                    })
                end

                if IsDisabledControlJustPressed(0, 106) then 
                    SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)

                    TriggerEvent("pNotify:SendNotification",{
                        text = "<b style='color:#FFFFFF'>Nie możesz wykonać tej czynności!</b>",
                        type = "error",
                        timeout = (3000),
                        layout = "centerright",
                        queue = "global"
                    })
                end
            end

            if (inZone.type == "green") or (inZone.type == "yellow") then
                DisableControlAction(0, 288, true)   
                if IsDisabledControlJustPressed(0, 288) then 
                    TriggerEvent("pNotify:SendNotification",{
                        text = "<b style='color:#FFFFFF'>Nie możesz wykonać tej czynności!</b>",
                        type = "error",
                        timeout = (3000),
                        layout = "centerright",
                        queue = "global"
                    })
                end

                DisableControlAction(0, 182, true)   
                if IsDisabledControlJustPressed(0, 182) then 
                    TriggerEvent("pNotify:SendNotification",{
                        text = "<b style='color:#FFFFFF'>Nie możesz wykonać tej czynności!</b>",
                        type = "error",
                        timeout = (3000),
                        layout = "centerright",
                        queue = "global"
                    })
                end              
            end

            if (inZone.type ~= "red") then
                if not IsPedInAnyVehicle(PlayerPedId(), false) then
                    if IsWeapon(GetSelectedPedWeapon(PlayerPedId())) then
                        SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
    
                        TriggerEvent("pNotify:SendNotification",{
                            text = "<b style='color:#FFFFFF'>Broń dostępna tylko w czerwonej strefie!</b>",
                            type = "error",
                            timeout = (3000),
                            layout = "centerright",
                            queue = "global"
                        })
                    end
                end
            end
        else
            if not justEnter then
                NetworkSetFriendlyFireOption(true)

                TriggerEvent("pNotify:SendNotification",{
                    text = ("<b style='color:#FFFFFF'>%s</b>"):format(lastZone.leave),
                    type = "error",
                    timeout = (3000),
                    layout = "centerright",
                    queue = "global"
                })

                justEnter = true
            end

            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                if IsWeapon(GetSelectedPedWeapon(PlayerPedId())) then
                    SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)

                    TriggerEvent("pNotify:SendNotification",{
                        text = "<b style='color:#FFFFFF'>Broń dostępna tylko w czerwonej strefie!</b>",
                        type = "error",
                        timeout = (3000),
                        layout = "centerright",
                        queue = "global"
                    })
                end
            end
        end

        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    local playerCoords

    for _,data in ipairs(Config.Zones) do
        for _, bubble in ipairs(data.bubbles) do
            data.blip = AddBlipForCoord(bubble.x, bubble.y, bubble.z)
            SetBlipSprite(data.blip, data.id)
            SetBlipDisplay(data.blip, 4)
            SetBlipScale(data.blip, 1.0)
            SetBlipColour(data.blip, data.clr)
            SetBlipAsShortRange(data.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(data.title)
            EndTextCommandSetBlipName(data.blip)
        end
    end

    while true do
        playerCoords = GetEntityCoords(PlayerPedId())

        for index, data in ipairs(Config.Zones) do
            for index, bubble in ipairs(data.bubbles) do
                if Vdist(playerCoords, bubble.x, bubble.y, bubble.z) < bubble.w*2 then
                    DrawMarker(28, bubble.x, bubble.y, bubble.z, 0, 0, 0, 0, 0, 0, bubble.w, bubble.w, bubble.w, data.color.r, data.color.g, data.color.b, 85, 0, 0, 2, 0, 0, 0, 0) 
                end
            end
        end

        Citizen.Wait(0)
	end
end)

function IsWeapon(weaponHash)
    for index, hash in ipairs(Config.Weapons) do 
        if weaponHash == hash then
            return true
        end
    end

    return false
end

function SetQueueMax(queue, max)
    local tmp = {
        queue = tostring(queue),
        max = tonumber(max)
    }

    SendNUIMessage({maxNotifications = tmp})
end

function SendNotification(options)
    options.animation = options.animation or {}
    options.sounds = options.sounds or {}
    options.docTitle = options.docTitle or {}

    local options = {
        type = options.type or "info",
        layout = options.layout or "centerRight",
        theme = options.theme or "gta",
        text = options.text or "Powiadomienie Testowe",
        timeout = options.timeout or 5000,
        progressBar = options.progressBar ~= false and true or false,
        closeWith = options.closeWith or {},
        animation = {
            open = options.animation.open or "gta_effects_open",
            close = options.animation.close or "gta_effects_close"
        },
        sounds = {
            volume = options.sounds.volume or 0.5,
            conditions = options.sounds.conditions or {"docVisible"},
            sources = options.sounds.sources or {"notif.wav"}
        },
        docTitle = {
            conditions = options.docTitle.conditions or {}
        },
        modal = options.modal or false,
        id = options.id or false,
        force = options.force or false,
        queue = options.queue or "global",
        killer = options.killer or false,
        container = options.container or false,
        buttons = options.button or false
    }

    SendNUIMessage({options = options})
end

RegisterNetEvent("pNotify:SendNotification")
AddEventHandler("pNotify:SendNotification", function(options)
    SendNotification(options)
end)

RegisterNetEvent("pNotify:SetQueueMax")
AddEventHandler("pNotify:SetQueueMax", function(queue, max)
    SetQueueMax(queue, max)
end)