# JGR Doors — Entrada por puerta

Entra al vehículo por la puerta que tienes delante y siéntate en el asiento que le corresponde, en lugar de que GTA elija el asiento por ti.

`Versión 1.1.0` · `QBCore · Qbox · ESX · Standalone (ox_core)` · `Requiere ox_lib`

---

## Características

- **Detección por huesos del modelo**: usa los huesos reales de las puertas (`door_dside_f`, `door_pside_f`, `door_dside_r`, `door_pside_r`) para saber junto a qué puerta estás.
- **Puerta → asiento**: puerta del conductor → conductor; puerta delantera derecha → copiloto; puertas traseras → asientos traseros izquierdo y derecho. Si estás cerca de varias puertas, se usa la más cercana.
- **Solo asientos que existen**: en vehículos de dos plazas no se ofrecen las puertas traseras.
- **Respeta los cierres**: si el vehículo está cerrado con llave (estado de cierre ≥ 2 o cerrado para ti), recibes el aviso «Vehículo cerrado» y no entras. Se puede desactivar.
- **Texto de ayuda** con `lib.showTextUI` de ox_lib («Pulsa [E] para entrar»).
- **Ligero**: comprueba cada 1000 ms si no hay vehículos cerca, cada 250 ms si hay uno a menos de `Config.SearchRadius` y cada frame solo cuando estás junto a una puerta.
- **Multi-framework** con detección automática (solo se usa para las notificaciones; el script no necesita datos del jugador).
- **Aviso de actualizaciones** en la consola del servidor.

La entrada normal de GTA con **F** sigue funcionando igual; este script añade la entrada con **E** por la puerta concreta.

## Requisitos

| Recurso | ¿Obligatorio? | Uso |
| :--- | :--- | :--- |
| [ox_lib](https://github.com/overextended/ox_lib) | Sí | Texto de ayuda, búsqueda del vehículo cercano y notificaciones |
| qbx_core / qb-core / es_extended / ox_core | No | Si hay framework, se usan sus notificaciones |

## Instalación

1. Descarga el repositorio y deja la carpeta en `resources` con el nombre exacto **`JGR_Doors`**.
2. Añade a tu `server.cfg`, **después** de ox_lib y de tu framework:

   ```cfg
   ensure ox_lib
   # ensure qbx_core / qb-core / es_extended (si usas alguno)
   ensure JGR_Doors
   ```

3. Reinicia el servidor. No hay SQL ni items.

## Configuración (`config.lua`)

| Opción | Por defecto | Descripción |
| :--- | :--- | :--- |
| `Config.Framework` | `'auto'` | `'auto'`, `'qbx'`, `'qb'`, `'esx'` o `'standalone'`. En `auto` se detecta en el orden qbx_core → qb-core → es_extended → standalone. |
| `Config.Notify` | `'auto'` | `'auto'` (notificación del framework y, si no hay, ox_lib), `'ox_lib'` o `'native'` (feed de GTA). |
| `Config.InteractKey` | `38` (E) | Control de GTA para entrar. Si lo cambias, cambia también `Config.Text.enter`. [Lista de controles](https://docs.fivem.net/docs/game-references/controls/). |
| `Config.DoorDistance` | `1.5` | Distancia máxima (m) a la puerta. |
| `Config.SearchRadius` | `6.0` | Radio (m) en el que se busca el vehículo más cercano. |
| `Config.RunToSeat` | `true` | `true`: el personaje corre al asiento; `false`: camina. |
| `Config.RespectLocks` | `true` | Impide entrar en vehículos cerrados. |
| `Config.Text` | — | Textos `enter` y `locked`. |
| `Config.TextUI` | — | Opciones de `lib.showTextUI` (`position`, `icon`…). |

## Compatibilidad con frameworks

| Framework | Funciona | Notas |
| :--- | :--- | :--- |
| **QBCore** (`qb-core`) | Sí | Notificaciones con `QBCore.Functions.Notify`. |
| **Qbox** (`qbx_core`) | Sí | Notificaciones con `exports.qbx_core:Notify`. Ya no se carga ningún módulo de qbx_core. |
| **ESX Legacy** (`es_extended`) | Sí | Notificaciones con `ESX.ShowNotification`. |
| **Standalone / ox_core** | Sí | Notificaciones con `lib.notify` (ox_lib). |

El cierre del vehículo se lee con los nativos de GTA (`GetVehicleDoorLockStatus`, `GetVehicleDoorsLockedForPlayer`), así que funciona con cualquier script de llaves que use los cierres nativos.

## Comandos, exports y eventos

No tiene comandos, exports ni eventos públicos.

## Actualizaciones

Al arrancar, el servidor comprueba la versión publicada (clave `JGR_Doors` del `versions.json` central de JGR) y muestra en consola si estás actualizado o si hay una versión nueva con el enlace de descarga.

Para desactivar el aviso, añade a tu `server.cfg`:

```cfg
set jgr_versioncheck 0
```

## Changelog

### 1.1.0
- Compatible con **QBCore, Qbox, ESX y standalone/ox_core**: se quitan `dependency 'qbx_core'` y los módulos `@qbx_core/...` del fxmanifest; nuevo `bridge/client.lua` con detección automática y `Config.Framework`.
- Nuevo `config.lua` (tecla, distancias, textos, cierres, notificaciones).
- Nuevo comprobador de versiones común (`server/version_check.lua`). Se elimina `updates.lua`, que se presentaba como «JGR Flip-car» y comparaba versiones quitando los puntos (1.10.0 se consideraba menor que 1.9.0).
- Se usa la puerta **más cercana** en vez de la primera que entraba en el rango.
- No se ofrecen puertas traseras si el vehículo no tiene esos asientos.
- El aviso de vehículo cerrado usa la notificación del framework (configurable con `Config.Notify`) y también tiene en cuenta los vehículos cerrados solo para el jugador.
- El texto de ayuda ya no se vuelve a pintar en cada frame, no aparece mientras el personaje está entrando y se oculta al parar el recurso.
- Respuesta más rápida al acercarse a un vehículo (250 ms en vez de 1000 ms) y detección de la tecla en cada frame junto a la puerta.
- Se quita la variable global `QBCore` que se creaba sin uso.

### 1.0.1
- Versión anterior (solo Qbox).

## Soporte y créditos

Autor: **JGR** — GitHub [jgr-ry](https://github.com/jgr-ry). Para dudas o errores, abre un issue en este repositorio.
