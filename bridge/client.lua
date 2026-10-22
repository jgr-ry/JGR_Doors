--[[
    Bridge de cliente
    ------------------------------------------------------------------------
    Detecta el framework (qbx_core -> qb-core -> es_extended -> ox_core/standalone)
    y expone una API común. El resto del script solo llama a Bridge.*.
]]

Bridge = {}

local RESOURCE = GetCurrentResourceName()

local FRAMEWORKS = {
    { id = 'qbx', resource = 'qbx_core' },
    { id = 'qb', resource = 'qb-core' },
    { id = 'esx', resource = 'es_extended' },
}

local ALIASES = {
    auto = 'auto',
    qbx = 'qbx', qbox = 'qbx', qbx_core = 'qbx',
    qb = 'qb', qbcore = 'qb', ['qb-core'] = 'qb',
    esx = 'esx', es_extended = 'esx',
    standalone = 'standalone', none = 'standalone', ox = 'standalone', ox_core = 'standalone',
}

local function warn(msg)
    print(('^3[%s]^7 %s'):format(RESOURCE, msg))
end

local function detectFramework()
    local wanted = ALIASES[tostring(Config.Framework or 'auto'):lower()]
    if not wanted then
        warn(('Config.Framework = "%s" no es válido; se usa detección automática.'):format(tostring(Config.Framework)))
        wanted = 'auto'
    end

    if wanted == 'standalone' then return 'standalone' end

    for _, fw in ipairs(FRAMEWORKS) do
        if wanted == 'auto' or wanted == fw.id then
            if GetResourceState(fw.resource) ~= 'missing' then
                return fw.id
            elseif wanted == fw.id then
                warn(('Config.Framework = "%s" pero %s no existe; se usa modo standalone.'):format(fw.id, fw.resource))
                return 'standalone'
            end
        end
    end

    return 'standalone'
end

Bridge.Framework = detectFramework()
Bridge.HasOxCore = GetResourceState('ox_core') ~= 'missing'

-- El objeto del framework se obtiene de forma perezosa (en el primer uso),
-- así no falla si el script carga antes de que el framework termine de arrancar.
local coreObject

local function getCore()
    if coreObject then return coreObject end

    local ok, obj
    if Bridge.Framework == 'qb' then
        ok, obj = pcall(function() return exports['qb-core']:GetCoreObject() end)
    elseif Bridge.Framework == 'esx' then
        ok, obj = pcall(function() return exports.es_extended:getSharedObject() end)
    end

    if ok and type(obj) == 'table' then coreObject = obj end
    return coreObject
end

local QB_TYPES = { inform = 'primary', info = 'primary', success = 'success', error = 'error', warning = 'error' }
local ESX_TYPES = { inform = 'info', info = 'info', success = 'success', error = 'error', warning = 'error' }

local function nativeNotify(msg)
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(false, false)
end

local function oxNotify(msg, ntype)
    if type(lib) == 'table' and type(lib.notify) == 'function' then
        lib.notify({ description = msg, type = ntype })
        return true
    end
    return false
end

local function frameworkNotify(msg, ntype)
    local fw = Bridge.Framework
    if fw == 'qbx' and GetResourceState('qbx_core') == 'started' then
        exports.qbx_core:Notify(msg, ntype)
        return true
    end

    local core = (fw == 'qb' or fw == 'esx') and getCore()
    if not core then return false end

    if fw == 'qb' and core.Functions and core.Functions.Notify then
        core.Functions.Notify(msg, QB_TYPES[ntype] or ntype)
        return true
    elseif fw == 'esx' and core.ShowNotification then
        core.ShowNotification(msg, ESX_TYPES[ntype] or ntype)
        return true
    end
    return false
end

--- Muestra una notificación al jugador local.
--- @param msg string
--- @param ntype? 'inform'|'success'|'error'|'warning'
function Bridge.Notify(msg, ntype)
    ntype = ntype or 'inform'
    local mode = Config.Notify or 'auto'

    if mode == 'native' then return nativeNotify(msg) end
    if mode ~= 'ox_lib' and frameworkNotify(msg, ntype) then return end
    if oxNotify(msg, ntype) then return end
    nativeNotify(msg)
end
