# Jump Boost Example Module

This is a reference module for the [Stackable Features Manager](https://github.com/Kannoma/stackable-features-manager) Godot plugin. Use it as a template for building your own modular, hot-swappable features.

---

## What is This?
A simple, fully-documented module that adds a configurable jump boost feature. Designed to show best practices for the stackable module system.

---

## Navigating a Stackable Module

Each module follows a clear structure:

- **manifest.tres**: Metadata and registration. Tells the manager how to load your module.
- **config.gd**: Defines settings and options for your feature (e.g., boost strength, duration).
- **config_default.tres**: Default values for your config.
- **example_module.gd**: The main logic for your feature. Implements what the module actually does.
- **api.gd**: The public interface. Exposes only the unique functions of your module (e.g., `activate_boost()`). Common actions like loading/saving configs are handled by the manager.
- **presets/**: Optional. Pre-made config files for different setups (e.g., speedrun, debug).

**How to use the API:**
- Get the API for your module: `var api = ModuleRegistry.get_api("jump_boost")`
- Call unique functions: `api.activate_boost()`, `api.set_boost_multiplier(2.0)`
- Use `ModuleRegistry` for common actions: `ModuleRegistry.load_preset("jump_boost", "speedrun")`

**To modify or create a module:**
- Edit `config.gd` for new settings
- Add your logic to `example_module.gd`
- Expose new functions in `api.gd`

---

## Quick Start

1. **Install the Plugin:**
   - [Stackable Features Manager → GitHub](https://github.com/Kannoma/stackable-features-manager)
   - Copy `stackable_features_manager` to your `addons/` folder and enable it in Godot.
2. **Copy This Module:**
   - Place this `example_module` folder in your project's `stackable_features/` directory.
3. **Use in Code:**
   ```gdscript
   var jumpboost = ModuleRegistry.get_api("jump_boost")
   jumpboost.activate_boost()
   jumpboost.set_boost_multiplier(2.0)
   ModuleRegistry.load_preset("jump_boost", "speedrun")
   ```

---

## File Structure
```
example_module/
├── manifest.tres        # Module metadata
├── example_module.gd    # Feature logic
├── config.gd            # Config schema
├── config_default.tres  # Default config
├── api.gd               # Public API
├── presets/             # Preset configs
└── README.md            # This file
```

---

## How to Make Your Own Module
1. **Copy this folder.**
2. **Edit `manifest.tres`:** Change `id`, `name`, `entry_point`.
3. **Edit `config.gd`:** Define your settings.
4. **Edit `example_module.gd`:** Implement your feature logic.
5. **Edit `api.gd`:** Expose only unique functions.
6. **Test in your game:**
   ```gdscript
   var mymod = ModuleRegistry.get_api("my_module")
   mymod.my_unique_function()
   ```

---

## API Reference
- `ModuleRegistry.get_api("jump_boost")` → Returns the module's API
- `activate_boost()` / `deactivate_boost()`
- `set_boost_multiplier(value)` / `get_boost_multiplier()`
- `get_boost_status()`
- Preset/config management via `ModuleRegistry`

---

## Best Practices
- Only put unique logic in your API.
- Use presets for easy config switching.
- Let the manager handle loading, saving, and enabling modules.

---

**For more info, see the [Stackable Features Manager README](https://github.com/Kannoma/stackable-features-manager).** 