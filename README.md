# EL QUE SALTA 68k

> Un juego de plataformas retro en 2D escrito íntegramente en **ensamblador Motorola 68000** para el simulador **EASy68K**.
> **Proyecto académico:** Desarrollado para la asignatura *Estructura de Computadores II*, curso académico 2023–2024.

---

## EL QUE SALTA

**EL QUE SALTA** es un juego de plataformas 2D de bajo nivel desarrollado desde cero en **lenguaje ensamblador 68000**. Diseñado sin bibliotecas de alto nivel ni motores de terceros, cuenta con un renderizador gráfico personalizado, un motor de mapas de tiles, un sistema de detección de colisiones, un bucle de físicas y reproducción de audio.

El jugador controla a un héroe alienígena que debe avanzar verticalmente a través de **11 mapas de tiles** hasta alcanzar la plataforma superior y conseguir la victoria.

---

## Características técnicas

* **Motor gráfico personalizado:** Renderizado mediante doble búfer (*double buffering*) a una resolución de **640×480**, utilizando traps del sistema de dibujo directo y comandos de primitivas vectoriales.
* **Sincronización mediante interrupciones hardware:** Bucle de ejecución preciso a **100 FPS**, controlado mediante interrupciones de temporizador *autovectorizadas* del Motorola 68000.
* **Motor de físicas y colisiones:** Sistema personalizado de gravedad vertical, cálculo parabólico de la trayectoria de salto y detección de colisiones basada en tiles mediante *Axis-Aligned Bounding Boxes (AABB)*.
* **Sistema de mapas multinivel:** Carga de escenarios verticales en tiempo real, con soporte para **11 diseños de niveles diferentes**.
* **Arquitectura basada en máquina de estados:** Separación clara de los diferentes estados del sistema: pantalla de título, juego, pausa y pantalla de victoria.
* **Sistema de audio:** Reproducción de efectos de sonido `.WAV` en tiempo real mediante múltiples canales y reproducción de música de fondo en bucle.

---

## Controles

| Acción                   | Control                              |
| :----------------------- | :----------------------------------- |
| **Mover a la izquierda** | `A`                                  |
| **Mover a la derecha**   | `D`                                  |
| **Saltar**               | `W`                                  |
| **Pausar el juego**      | `Q`                                  |
| **Iniciar / Hacer clic** | Botón izquierdo del ratón            |
| **Salir del juego**      | `SPACE` (en la pantalla de victoria) |

---

## Estructura de la arquitectura y del código

```text
OPTIMITRIX/
├── MAIN.X68        # Punto de entrada principal y bucle de sincronización a 100 FPS
├── SYSTEM.X68      # Inicialización del hardware, rutinas de interrupción del temporizador y doble búfer
├── STATES.X68      # Máquina de estados del juego (inicialización, juego, pausa y pantalla de victoria)
├── PLAYER.X68      # Físicas del jugador, parábola del salto y rutinas de colisión
├── GFX.X68         # Intérprete de primitivas gráficas y gestor de sprites
├── GFXDATA.X68     # Definiciones de gráficos vectoriales y datos sin procesar del sprite del alienígena
├── MAP.X68         # Motor de renderizado de mapas de tiles y lógica de transición entre pantallas
├── MAPDATA.X68     # Definiciones de los diseños de los niveles (mapas del 1 al 11)
├── AUDIO.X68       # Integración del sistema de audio y reproductor de archivos WAV
├── SYSCONST.X68    # Direcciones del hardware del sistema, códigos de teclas y TRAPs
├── SYSVARS.X68     # Variables del sistema de bajo nivel y contadores de interrupciones
├── VARS.X68        # Variables del estado del juego y punteros a los mapas
└── SOUND/          # Efectos de sonido WAV y pistas de música de fondo
```

---

## Cómo ejecutar

1. **Descargar EASy68K:** Descarga e instala el simulador de código abierto [EASy68K](http://www.easy68k.com/).
2. **Abrir el proyecto:** Inicia `Edit68K.exe` y abre `MAIN.X68`.
3. **Ensamblar:** Pulsa `F9` (o selecciona `Execute -> Assemble and Run`).
4. **Ejecutar:** En la ventana de `Sim68K`, pulsa **Play (F5)** para iniciar el juego. Se abrirá automáticamente una ventana gráfica con una resolución de **640×480**.

---
