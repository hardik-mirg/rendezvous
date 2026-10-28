# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Rendezvous** is a **2D space simulation game** inspired by **Space Flight Simulator (SFS)** and **Kerbal Space Program (KSP)**. The project is designed for **macOS native, Android native, and web deployment** with a focus on **orbital mechanics, spacecraft building, and real-time navigation**.

### Key Features
- **Orbital Mechanics**: Hohmann transfer calculations, rendezvous points, and ΔV management.
- **Spacecraft Building**: Modular components with drag-and-drop assembly.
- **UI/UX**: Intuitive navigation menus, real-time data displays, and responsive design.
- **Cross-Platform**: Optimized for macOS, Android, and web.

## Code Architecture

### High-Level Structure

The project follows a modular architecture with the following key components:

1. **Physics Engine**: Handles orbital mechanics and spacecraft dynamics.
   - Located in `/src/physics_engine/` (to be created).
   - Implements Hohmann transfer calculations and real-time orbital updates.

2. **Game Engine**: Core logic for game state, rendering, and user interactions.
   - Located in `/src/game_engine/` (to be created).
   - Manages game loop, input handling, and component interactions.

3. **UI/UX Components**: Modular UI elements for navigation, mission planning, and cockpit displays.
   - Located in `/src/ui_components/` (to be created).
   - Includes responsive layouts for desktop and mobile.

4. **Build Scripts**: Cross-platform build pipelines for macOS, Android, and web.
   - Located in `/build_scripts/` (to be created).
   - Uses tools like `LibGDX` (Android), `SwiftUI/Cocoa` (macOS), and `WebAssembly` (web).

5. **Configuration Files**: Project settings, build configurations, and environment variables.
   - Located in `/config/` (to be created).
   - Manages game settings, physics parameters, and platform-specific configurations.

### Key Files and Directories

- **`/src/physics_engine/`**: Physics calculations and orbital mechanics.
- **`/src/game_engine/`**: Core game logic and state management.
- **`/src/ui_components/`**: UI/UX components and layouts.
- **`/build_scripts/`**: Build configurations and deployment scripts.
- **`/config/`**: Project settings and configurations.

## Development Workflow

### Common Commands

#### Build
- **Build for macOS**:
  ```bash
  # Command to build the macOS native app (to be defined based on the tech stack)
  
  # Example: Using Swift for macOS
  swift build -c release
  ```

- **Build for Android**:
  ```bash
  # Command to build the Android app (to be defined based on the tech stack)
  
  # Example: Using Kotlin/Java with LibGDX
  ./gradlew assembleRelease
  ```

- **Build for Web**:
  ```bash
  # Command to build the web app (using WebAssembly)
  
  # Example: Using Rust and wasm-pack
  wasm-pack build --target web
  ```

#### Linting
- **Lint Code**:
  ```bash
  # Command to run code linters (e.g., ESLint, SwiftLint, Kotlin lint)
  
  # Example: Using SwiftLint for Swift code
  swiftlint lint
  ```

#### Testing
- **Run Unit Tests**:
  ```bash
  # Command to run unit tests
  
  # Example: Using pytest for Python tests
  pytest tests/unit/
  ```

- **Run Integration Tests**:
  ```bash
  # Command to run integration tests
  
  # Example: Using pytest for integration tests
  pytest tests/integration/
  ```

#### Run
- **Run the Game**:
  ```bash
  # Command to run the game in development mode
  
  # Example: Using a custom script to launch the game
  ./run_dev.sh
  ```

## Project-Specific Notes

- **Tech Stack**: Use **Swift** for macOS, **Kotlin/Java** for Android, and **Rust/WebAssembly** for web.
- **Performance**: Optimize rendering and physics calculations for smooth gameplay.
- **Cross-Platform**: Ensure consistent UI/UX across all platforms.

## Additional Resources

- **Design Files**: Located in `/plans/` for UI/UX mockups and wireframes.
- **Documentation**: Refer to the `plan.md` for high-level design and implementation details.

---