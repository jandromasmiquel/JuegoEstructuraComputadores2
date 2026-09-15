# EL QUE SALTA 68k

> A 2D retro platformer game written entirely in **Motorola 68000 Assembly** for the **EASy68K** simulator framework.
>  **Academic Project:** Developed for the course *"Estructura de Computadores II"* (Computer Structure II), Academic Year 2023–2024.
---

##  EL QUE SALTA

**EL QUE SALTA** is a low-level 2D platformer game developed from scratch in **68000 Assembly Language**. Designed without high-level libraries or third-party engines, it features a custom-built graphics renderer, tilemap engine, collision system, physics loop, and audio playback.

The player controls an alien hero navigating vertically across 11 tilemaps to reach the top platform and achieve victory.



---

##  Technical Highlights

- **Custom Low-Level Graphics Engine:** Double-buffering renderer (640x480 resolution) using direct system drawing traps and vector primitive commands.
- **Hardware Interrupt Synchronization:** Precise 100 FPS execution loop powered by Motorola 68000 autovector hardware timer interrupts.
- **Physics & Collision Engine:** Custom vertical gravity, jump curve parabola calculation, and tile-based axis-aligned collision detection.
- **Multi-Level Tilemap System:** Real-time vertical stage loading supporting 11 distinct stage layouts.
- **State Machine Architecture:** Clean separation of system states (Title Screen, Gameplay, Pause State, Victory Screen).
- **Audio System:** Real-time multi-channel `.WAV` sound effects and looped background music player.

---

##  Controls

| Action | Control |
| :--- | :--- |
| **Move Left** | `A` |
| **Move Right** | `D` |
| **Jump** | `W` |
| **Pause Game** | `Q` |
| **Start / Click** | Left Mouse Button |
| **Exit Game** | `SPACE` (on Victory Screen) |

---

##  Architecture & Codebase Structure

```
OPTIMITRIX/
├── MAIN.X68        # Main entry point & 100 FPS synchronization loop
├── SYSTEM.X68      # Hardware init, timer interrupt service routines & double buffering
├── STATES.X68      # Game state machine (Init, Game, Pause, Victory screen)
├── PLAYER.X68      # Player physics, jump parabola, and collision routines
├── GFX.X68         # Graphics primitive interpreter & sprite dispatcher
├── GFXDATA.X68     # Vector graphics definitions and alien sprite raw data
├── MAP.X68         # Tilemap rendering engine and screen transition logic
├── MAPDATA.X68     # Stage layout definitions (Maps 1 to 11)
├── AUDIO.X68       # Audio system integration and WAV sound player
├── SYSCONST.X68    # System hardware addresses, keycodes, and TRAP definitions
├── SYSVARS.X68     # Low-level system variables & interrupt counters
├── VARS.X68        # Game state variables & map pointers
└── SOUND/          # WAV sound effects and background music tracks
```

---

##  How to Run

1. **Download EASy68K:** Download and install the open-source [EASy68K Simulator](http://www.easy68k.com/).
2. **Open Project:** Launch `Edit68K.exe` and open `MAIN.X68`.
3. **Assemble:** Press `F9` (or select `Execute -> Assemble and Run`).
4. **Execute:** In the `Sim68K` window, click **Play (F5)** to start the game. A 640x480 graphics window will open automatically.

---