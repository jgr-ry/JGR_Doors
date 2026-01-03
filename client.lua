local doorBones = {
    {name = "door_dside_f", doorIndex = 0, seat = -1}, -- conductor
    {name = "door_pside_f", doorIndex = 1, seat = 0},  -- copiloto
    {name = "door_dside_r", doorIndex = 2, seat = 1}, -- trasero izq
    {name = "door_pside_r", doorIndex = 3, seat = 2}, -- trasero der
}

local textVisible = false

local function showInteractionText()
    if type(lib) == 'table' and type(lib.showTextUI) == 'function' then
        pcall(function() lib.showTextUI('Pulsa [E] para entrar', { position = 'right-center', icon = 'car' }) end)
        textVisible = true
        return
    end

    textVisible = true
end

local function hideInteractionText()
    if textVisible then
        if type(lib) == 'table' and type(lib.hideTextUI) == 'function' then
            pcall(function() lib.hideTextUI() end)
        end
        textVisible = false
    end
end

local function notifyLocked()
    if type(lib) == 'table' and type(lib.notify) == 'function' then
        pcall(function() lib.notify({ description = 'Vehículo cerrado', type = 'error' }) end)
        return
    end
    -- fallback to simple help text if lib.notify not available
    QBCore = QBCore -- noop to avoid lint
end

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        if not IsPedInAnyVehicle(ped, false) then
            local px,py,pz = table.unpack(GetEntityCoords(ped))
            local vehicle = nil

            if type(lib) == 'table' and type(lib.getClosestVehicle) == 'function' then
                local ok, v = pcall(function() return lib.getClosestVehicle(vector3(px,py,pz), 6.0, false) end)
                if ok then vehicle = v end
            end

            if not vehicle or vehicle == 0 then
                vehicle = GetClosestVehicle(px,py,pz, 6.0, 0, 70)
            end

            local found = false
            if vehicle and vehicle ~= 0 then
                for _, bone in ipairs(doorBones) do
                    local boneIndex = GetEntityBoneIndexByName(vehicle, bone.name)
                    if boneIndex and boneIndex ~= -1 then
                        local bx,by,bz = table.unpack(GetWorldPositionOfEntityBone(vehicle, boneIndex))
                        local dist = Vdist(px,py,pz, bx,by,bz)
                        if dist < 1.5 then
                            sleep = 5
                            found = true
                            showInteractionText()
                            if IsControlJustReleased(0, 38) then -- E
                                local lock = GetVehicleDoorLockStatus(vehicle)
                                if lock and lock >= 2 then
                                    notifyLocked()
                                else
                                    SetVehicleDoorOpen(vehicle, bone.doorIndex, false, false)
                                    TaskEnterVehicle(ped, vehicle, 20000, bone.seat, 2.0, 1, 0)
                                    Wait(700)
                                    SetVehicleDoorShut(vehicle, bone.doorIndex, false)
                                end
                                hideInteractionText()
                                break
                            end
                        end
                    end
                end
            end

            if not found then
                hideInteractionText()
            end
        else
            hideInteractionText()
        end

        Wait(sleep)
    end
end)
