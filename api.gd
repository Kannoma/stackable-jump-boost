## Module: JumpBoostAPI
## Purpose: Lightweight API interface for the Jump Boost feature
## Dependencies: ModuleAPI
##

# Lightweight API interface for the Jump Boost feature
# Contains only module-specific functions - common config management is handled by ModuleRegistry

@tool
class_name JumpBoostAPI
extends ModuleAPI

# =============================================================================
# MODULE-SPECIFIC FUNCTIONS ONLY
# =============================================================================
# All common functions (get_config, set_config, load_preset, save_config, etc.)
# are now handled by ModuleRegistry - no need to duplicate them here!

## Manually activates the jump boost [br]
## [code]var success = jumpboost.activate_boost()[/code]
func activate_boost() -> bool:
	if _module and _module.has_method("activate_boost"):
		return _module.activate_boost()
	return false

## Gets the current boost status information [br]
## [code]var status = jumpboost.get_boost_status()[/code]
func get_boost_status() -> Dictionary:
	if not _module:
		return {}
	
	return {
		"active": _module.boost_active,
		"cooling_down": _module.is_cooling_down,
		"current_uses": _module.current_uses,
		"max_uses": _module.config.max_uses,
		"cooldown_remaining": _module.cooldown_timer.time_left if _module.is_cooling_down else 0.0,
		"boost_remaining": _module.boost_timer.time_left if _module.boost_active else 0.0
	}

## Deactivates the current boost early [br]
## [code]var success = jumpboost.deactivate_boost()[/code]
func deactivate_boost() -> bool:
	if _module and _module.has_method("deactivate_boost"):
		return _module.deactivate_boost()
	return false

## Sets the boost multiplier directly (convenience function) taking [multiplier] [br]
## [code]jumpboost.set_boost_multiplier(2.0)[/code]
func set_boost_multiplier(multiplier: float) -> void:
	if _module and _module.config and multiplier > 0.0:
		_module.config.boost_multiplier = multiplier
		print("JumpBoostAPI: Boost multiplier set to ", multiplier)

## Sets the boost duration directly (convenience function) taking [duration] [br]
## [code]jumpboost.set_boost_duration(1.0)[/code]
func set_boost_duration(duration: float) -> void:
	if _module and _module.config and duration > 0.0:
		_module.config.boost_duration = duration
		if _module.boost_timer:
			_module.boost_timer.wait_time = duration
		print("JumpBoostAPI: Boost duration set to ", duration)

## Gets the current boost multiplier [br]
## [code]var multiplier = jumpboost.get_boost_multiplier()[/code]
func get_boost_multiplier() -> float:
	if _module and _module.config:
		return _module.config.boost_multiplier
	return 1.0

## Gets the current boost duration [br]
## [code]var duration = jumpboost.get_boost_duration()[/code]
func get_boost_duration() -> float:
	if _module and _module.config:
		return _module.config.boost_duration
	return 0.0

# Preset loading is now handled automatically by ModuleRegistry
# No need to override load_preset() or get_available_presets() anymore!

# =============================================================================
# TUTORIAL NOTE FOR DEVELOPERS:
# =============================================================================
# This API is now ULTRA-LIGHT! Preset loading is completely automatic.
# 
# ✅ AUTOMATIC (no code needed):
#   - ModuleRegistry.load_preset("jump_boost", "speedrun")  # Loads from /presets/ automatically
#   - ModuleRegistry.get_presets("jump_boost")              # Discovers presets automatically
#   - ModuleRegistry.get_config("jump_boost")               # Works automatically
#   - ModuleRegistry.set_config("jump_boost", config)       # Works automatically
#   - ModuleRegistry.save_config("jump_boost", "user://my_config.tres")
#   - ModuleRegistry.reset_config("jump_boost")
#
# 🎯 YOUR API ONLY NEEDS:
#   - Module-specific functions (like activate_boost, get_boost_status)
#   - Custom business logic unique to your module
#   - Everything else is handled automatically by the plugin!
#
# 📁 REQUIRED MODULE STRUCTURE:
#   my_module/
#   ├── manifest.json          # Default config
#   ├── presets/              # Optional - auto-discovered
#   │   ├── speedrun.tres
#   │   └── casual.tres
#   └── api.gd               # Only module-specific functions!
# ============================================================================= 