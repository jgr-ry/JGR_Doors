-- Puertas que se pueden usar y el asiento al que llevan.
local DOORS = {
    { bone = 'door_dside_f', seat = -1 }, -- conductor
    { bone = 'door_pside_f', seat = 0 },  -- copiloto
    { bone = 'door_dside_r', seat = 1 },  -- trasero izquierdo
    { bone = 'door_pside_r', seat = 2 },  -- trasero derecho
}

local textVisible = false

local function showInteractionText()
    if textVisible then return end
    lib.showTextUI(Config.Text.enter, Config.TextUI)
    textVisible = true
end

local function hideInteractionText()
    if not textVisible then return end
    lib.hideTextUI()
    textVisible = false
end

local function isVehicleLocked(vehicle)
    local lock = GetVehicleDoorLockStatus(vehicle)
    return (lock and lock >= 2) or GetVehicleDoorsLockedForPlayer(vehicle, PlayerId())
end

--- Devuelve la puerta más cercana al jugador dentro de Config.DoorDistance, o nil.
local function getClosestDoor(vehicle, coords)
    local maxPassengers = GetVehicleMaxNumberOfPassengers(vehicle)
    local closest, closestDist

    for i = 1, #DOORS do
        local door = DOORS[i]
        -- Solo puertas que existen en el modelo y llevan a un asiento que existe.
        if door.seat < maxPassengers then
            local boneIndex = GetEntityBoneIndexByName(vehicle, door.bone)
            if boneIndex ~= -1 then
                local dist = #(coords - GetWorldPositionOfEntityBone(vehicle, boneIndex))
                if dist <= Config.DoorDistance and (not closestDist or dist < closestDist) then
                    closest, closestDist = door, dist
                end
            end
        end
    end

    return closest
end

local function enterThroughDoor(ped, vehicle, door)
    if Config.RespectLocks and isVehicleLocked(vehicle) then
        Bridge.Notify(Config.Text.locked, 'error')
        return
    end

    TaskEnterVehicle(ped, vehicle, 20000, door.seat, Config.RunToSeat and 2.0 or 1.0, 1, 0)
end

CreateThread(function()
    while true do
        local sleep = 1000
        local door, vehicle
        local ped = PlayerPedId()

        -- Nada que hacer si ya está en un vehículo, entrando en uno o muerto.
        if not IsPedInAnyVehicle(ped, false)
            and GetVehiclePedIsTryingToEnter(ped) == 0
            and not IsEntityDead(ped) then
            local coords = GetEntityCoords(ped)
            vehicle = lib.getClosestVehicle(coords, Config.SearchRadius, false)

            if vehicle and vehicle ~= 0 then
                sleep = 250 -- hay un vehículo cerca: revisar más a menudo
                door = getClosestDoor(vehicle, coords)
            end
        end

        if door then
            sleep = 0 -- junto a una puerta: comprobar la tecla cada frame
            showInteractionText()

            if IsControlJustReleased(0, Config.InteractKey) then
                hideInteractionText()
                enterThroughDoor(ped, vehicle, door)
            end
        else
            hideInteractionText()
        end

        Wait(sleep)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        hideInteractionText()
    end
end)
