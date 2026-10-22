Config = {}

-- Framework: 'auto' | 'qbx' | 'qb' | 'esx' | 'standalone'
-- En 'auto' se detecta en este orden: qbx_core -> qb-core -> es_extended -> ox_core/standalone.
-- Este script no necesita datos del jugador; el framework solo se usa para las notificaciones.
Config.Framework = 'auto'

-- Notificaciones: 'auto' (la del framework y, si no hay, ox_lib) | 'ox_lib' | 'native'
Config.Notify = 'auto'

-- Tecla de interacción (control de GTA). 38 = E. Lista: https://docs.fivem.net/docs/game-references/controls/
Config.InteractKey = 38

-- Distancia máxima (metros) a la puerta para poder entrar por ella.
Config.DoorDistance = 1.5

-- Radio (metros) en el que se busca el vehículo más cercano.
Config.SearchRadius = 6.0

-- Si es true, el jugador corre hacia el asiento; si es false, camina.
Config.RunToSeat = true

-- Si es true, no se puede entrar en vehículos cerrados con llave.
Config.RespectLocks = true

-- Textos
Config.Text = {
    enter = 'Pulsa [E] para entrar',
    locked = 'Vehículo cerrado',
}

-- Aspecto del texto de ayuda (ox_lib textUI)
Config.TextUI = {
    position = 'right-center',
    icon = 'car',
}
