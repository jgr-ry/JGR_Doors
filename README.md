# 🚗 JGR - Entrada por Puerta (Door Entry)

[![FiveM](https://img.shields.io/badge/FiveM-v1.0.1-orange.svg)](https://fivem.net/)
[![Framework](https://img.shields.io/badge/Framework-Qbox%20/%20QBCore-blue.svg)](https://github.com/qbox-project/qbx_core)
[![Dependency](https://img.shields.io/badge/Dependency-ox__lib-red.svg)](https://github.com/overextended/ox_lib)

Mejora el realismo de tu servidor de FiveM con este script de interacción física. Obliga a los jugadores a estar frente a una puerta específica para acceder al asiento correspondiente, detectando automáticamente el estado del vehículo.

---

## ✨ Características Principales

* 🎯 **Detección por Huesos (Bones):** Utiliza los identificadores reales del modelo del vehículo (`door_dside_f`, `door_pside_f`, `door_dside_r`, `door_pside_r`) para una precisión total.
* 💺 **Asignación de Asientos:** Mapeo automático de la puerta al índice de asiento correcto (conductor, copiloto y traseros).
* 🔒 **Sistema de Seguridad:** Integración con el estado de las cerraduras; si el vehículo está bloqueado, el jugador recibe un aviso y no puede entrar.
* 💉 **Integración con Ox Lib:** Aprovecha `lib.showTextUI` para alertas visuales y `lib.getClosestVehicle` para una detección eficiente.
* 🚀 **Optimización (Resync):** El script descansa a 1000ms cuando no hay vehículos cerca y baja a 5ms solo cuando detecta una puerta interactuable.

---

## 🛠️ Instalación

1. **Descarga:** Clona o descarga este repositorio en tu carpeta de `resources`.
2. **Dependencias:** Asegúrate de tener instalados y actualizados:
    * `ox_lib`
    * `qbx_core`
3. **Configuración del Servidor:** Añade la siguiente línea a tu archivo `server.cfg`:
   ```cfg
   ensure JGR_Doors
