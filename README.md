# 🚀 Jump Boost Module - Tutorial & Reference

This example module demonstrates the **new simplified architecture** for creating stackable features. It's designed to be a complete tutorial and reference for developers.

## 📁 **File Structure (New & Improved)**

```
jump_boost/
├── manifest.tres           # Module metadata (was: feature_config.tres)
├── example_module.gd       # Main feature implementation
├── config.gd              # Configuration schema (was: example_module_config.gd)
├── config_default.tres    # Default configuration values
├── api.gd                 # Lightweight API (90% smaller!)
├── presets/               # Optional preset configurations
│   ├── speedrun.tres
│   ├── casual.tres
│   └── debug.tres
└── README.md              # This tutorial
```

## 🎯 **Key Improvements**

### **Before (Old Architecture):**
- ❌ 400+ lines of boilerplate across multiple files
- ❌ Repetitive config management in every API
- ❌ Confusing file names (`feature_config.tres`?)
- ❌ Hard to understand and modify

### **After (New Architecture):**
- ✅ ~50 lines of actual feature logic
- ✅ Common functions handled by `ModuleRegistry`
- ✅ Clear file names (`manifest.tres`, `config.gd`)
- ✅ Easy to understand and extend

## 🔧 **How to Use This Module**

### **External Access (The New Way):**

```gdscript
# Get the module API for unique functions
var jumpboost = ModuleRegistry.get_api("jump_boost")

# Use module-specific functions
jumpboost.activate_boost()
jumpboost.set_boost_multiplier(2.5)
var status = jumpboost.get_boost_status()

# Use common functions directly from ModuleRegistry
ModuleRegistry.load_preset("jump_boost", "speedrun")
ModuleRegistry.save_config("jump_boost", "user://my_setup.tres")
var config = ModuleRegistry.get_config("jump_boost")
```

### **No More Boilerplate!**
```gdscript
# OLD WAY (lots of boilerplate in every API):
var api = module.get_api()
api.get_config()           # 20 lines of code
api.set_config(config)     # 15 lines of code  
api.load_preset("name")    # 25 lines of code
api.save_config("path")    # 15 lines of code

# NEW WAY (handled centrally):
ModuleRegistry.get_config("jump_boost")        # 1 line
ModuleRegistry.set_config("jump_boost", config) # 1 line
ModuleRegistry.load_preset("jump_boost", "name") # 1 line
ModuleRegistry.save_config("jump_boost", "path") # 1 line
```

## 📋 **File-by-File Breakdown**

### **1. `manifest.tres` - Module Metadata**
```tres
[resource]
id = "jump_boost"                      # Unique module identifier for API calls
name = "Jump Boost"                    # Human-readable display name
version = "1.0.0"                     # Semantic versioning
description = "Jump height booster"   # What this module does
author = "Your Name"                  # Module creator
entry_point = "example_module.gd"     # Main script file
engine_versions = ["4.3", "4.4"]     # Supported Godot versions
module_config = ExtResource("...")    # Default config reference
```

**Purpose:** Tells the system about your module - id for API calls, name for display, version, what file to load, etc.

### **2. `example_module.gd` - Main Implementation**
```gdscript
extends FeatureModule

var config: JumpBoostConfig  # Your config
var _api: JumpBoostAPI      # Your API

func get_module_name() -> String:
    return "jump_boost"

func init(module_config: ModuleConfig) -> void:
    config = module_config
    # Your initialization logic

# Your actual feature functions
func activate_boost() -> bool:
    # Implementation here
```

**Purpose:** Contains your actual feature logic. Focus on what makes your module unique!

### **3. `config.gd` - Configuration Schema**
```gdscript
extends ModuleConfig

@export var boost_multiplier: float = 1.5
@export var boost_duration: float = 0.5
@export var visual_effect: bool = true
# ... other settings

func is_valid() -> bool:
    return boost_multiplier > 0.0 and boost_duration > 0.0
```

**Purpose:** Defines what configuration options your module has.

### **4. `config_default.tres` - Default Values**
```tres
[resource]
script = ExtResource("config.gd")
boost_multiplier = 1.5
boost_duration = 0.5
visual_effect = true
# ... default values
```

**Purpose:** Provides sensible default configuration values.

### **5. `api.gd` - Lightweight API**
```gdscript
extends ModuleAPI

# ONLY module-specific functions!
func activate_boost() -> bool:
    return _module.activate_boost()

func get_boost_status() -> Dictionary:
    return _module.get_boost_status()

# NO MORE: get_config, set_config, load_preset, etc.
# Those are handled by ModuleRegistry!
```

**Purpose:** Exposes only the unique functions of your module. Common stuff is handled elsewhere!

## 🎮 **Creating Your Own Module**

### **Step 1: Copy This Template**
```bash
cp -r stackable_features/example_module stackable_features/my_module
cd stackable_features/my_module
```

### **Step 2: Update the Manifest**
Edit `manifest.tres`:
```tres
id = "my_module"
name = "My Module"
description = "What my module does"
entry_point = "my_module.gd"
```

### **Step 3: Create Your Config**
Edit `config.gd`:
```gdscript
extends ModuleConfig

@export var my_setting: float = 1.0
@export var my_option: bool = true
```

### **Step 4: Implement Your Feature**
Rename and edit `example_module.gd` → `my_module.gd`:
```gdscript
extends FeatureModule

var config: MyModuleConfig

func get_module_name() -> String:
    return "my_module"

func my_unique_function() -> void:
    # Your feature logic here
```

### **Step 5: Create Your API**
Edit `api.gd`:
```gdscript
extends ModuleAPI

func my_unique_function() -> void:
    _module.my_unique_function()

# Don't add get_config, set_config, etc. - use ModuleRegistry!
```

### **Step 6: Test It**
```gdscript
# In your game code:
var my_module = ModuleRegistry.get_api("my_module")
my_module.my_unique_function()

# Configure it:
ModuleRegistry.load_preset("my_module", "my_preset")
```

## 🔥 **Advanced Usage Examples**

### **Runtime Configuration:**
```gdscript
# Get current config
var config = ModuleRegistry.get_config("jump_boost")
config.boost_multiplier = 3.0

# Apply changes
ModuleRegistry.set_config("jump_boost", config)

# Or use the convenience API
var jumpboost = ModuleRegistry.get_api("jump_boost")
jumpboost.set_boost_multiplier(3.0)
```

### **Preset Management:**
```gdscript
# Load a preset
ModuleRegistry.load_preset("jump_boost", "speedrun")

# Save current settings
ModuleRegistry.save_config("jump_boost", "user://my_perfect_setup.tres")

# Get available presets
var presets = ModuleRegistry.get_presets("jump_boost")
for preset in presets:
    print("Available preset: ", preset)
```

### **Module Management:**
```gdscript
# Check if loaded
if ModuleRegistry.is_loaded("jump_boost"):
    print("Jump boost is ready!")

# Load/unload modules
ModuleRegistry.load("jump_boost")
ModuleRegistry.unload("jump_boost")

# Enable/disable modules
ModuleRegistry.set_enabled("jump_boost", false)
```

## 🚀 **Benefits for Developers**

### **1. Less Code to Write**
- **Before:** 400+ lines per module
- **After:** ~50 lines per module
- **Savings:** 90% less boilerplate!

### **2. Consistent APIs**
- All modules work the same way
- `ModuleRegistry.get_api("name")` always works
- Common functions always available

### **3. Easy to Learn**
- Clear file structure
- Obvious what each file does
- Focus on your unique logic

### **4. Easy to Maintain**
- Bug fixes in base classes help everyone
- New features auto-propagate
- Less code to maintain per module

## 📚 **API Reference**

### **ModuleRegistry Functions:**
```gdscript
# Module access
get_api(module_name) -> ModuleAPI
get_module(module_name) -> FeatureModule
is_loaded(module_name) -> bool

# Module management  
load(module_name) -> bool
unload(module_name) -> bool
set_enabled(module_name, enabled) -> bool

# Configuration (common to all modules)
get_config(module_name) -> ModuleConfig
set_config(module_name, config) -> bool
load_preset(module_name, preset) -> bool
save_config(module_name, path) -> bool
get_presets(module_name) -> Array[String]
reset_config(module_name) -> bool
```

### **Jump Boost Specific Functions:**
```gdscript
var jumpboost = ModuleRegistry.get_api("jump_boost")

# Unique to this module
jumpboost.activate_boost() -> bool
jumpboost.deactivate_boost() -> bool
jumpboost.get_boost_status() -> Dictionary
jumpboost.set_boost_multiplier(value) -> void
jumpboost.get_boost_multiplier() -> float
```

## 🎯 **Best Practices**

### **DO:**
- ✅ Keep APIs lightweight (only unique functions)
- ✅ Use `ModuleRegistry` for common operations
- ✅ Make configs with sensible defaults
- ✅ Document your unique functions well
- ✅ Test with different presets

### **DON'T:**
- ❌ Add config management to your API
- ❌ Duplicate preset loading logic
- ❌ Hardcode file paths in your module
- ❌ Forget to validate your config
- ❌ Make modules depend on each other

## 🔮 **What's Next?**

This architecture is designed to grow:
- **Editor Tools:** Visual module browser and config editor
- **Runtime Modding:** Load modules from `user://` at runtime
- **Auto-Discovery:** Modules register themselves automatically
- **Dependency Management:** Optional soft dependencies
- **Module Marketplace:** Share modules with the community

**Start building your modules with this pattern and they'll be ready for all future enhancements!**

---

## 💡 **Need Help?**

1. **Copy this example** and modify it
2. **Focus on your unique logic** - ignore the boilerplate
3. **Use ModuleRegistry** for common operations
4. **Test early and often** with different configs

**Happy modding! 🎮** 