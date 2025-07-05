## Module: JumpBoostConfig
## Purpose: Configuration resource for the Jump Boost feature
## Dependencies: ModuleConfig
##

# Configuration resource for the Jump Boost feature
# Provides typed configuration for jump enhancement mechanics

@tool
class_name JumpBoostConfig
extends ModuleConfig

## Jump Boost Configuration Properties
@export_group("Boost Settings")
@export var boost_multiplier: float = 1.5  ## How much to multiply jump height (1.0 = normal, 2.0 = double)
@export var boost_duration: float = 0.5    ## How long the boost effect lasts (seconds)
@export var visual_effect: bool = true     ## Whether to show visual effects

@export_group("Usage Limits")
@export var max_uses: int = 3              ## Maximum consecutive uses before cooldown
@export var cooldown_time: float = 5.0     ## Cooldown duration after max uses (seconds)
@export var auto_activate: bool = false    ## Whether boost activates automatically on jump

@export_group("Audio & Visual")
@export var boost_sound: bool = true       ## Play sound effect when boost activates
@export var particle_color: Color = Color.CYAN  ## Color of boost particles

## Validates the jump boost configuration
## [code]if config.is_valid():[/code]
func is_valid() -> bool:
	return boost_multiplier > 0.0 and boost_duration > 0.0 and max_uses > 0 and cooldown_time >= 0.0

## Returns a default configuration instance
## [code]var default = config.get_default_config()[/code]
func get_default_config() -> ModuleConfig:
	var config = JumpBoostConfig.new()
	config.boost_multiplier = 1.5
	config.boost_duration = 0.5
	config.visual_effect = true
	config.max_uses = 3
	config.cooldown_time = 5.0
	config.auto_activate = false
	config.boost_sound = true
	config.particle_color = Color.CYAN
	return config

## Merges another JumpBoostConfig into this one taking [other_config]
## [code]config.merge_config(other_config)[/code]
func merge_config(other_config: ModuleConfig) -> void:
	if other_config is JumpBoostConfig:
		var other = other_config as JumpBoostConfig
		if other.boost_multiplier > 0.0:
			boost_multiplier = other.boost_multiplier
		if other.boost_duration > 0.0:
			boost_duration = other.boost_duration
		if other.max_uses > 0:
			max_uses = other.max_uses
		if other.cooldown_time >= 0.0:
			cooldown_time = other.cooldown_time
		# Always merge boolean and color properties
		visual_effect = other.visual_effect
		auto_activate = other.auto_activate
		boost_sound = other.boost_sound
		particle_color = other.particle_color

## Returns the name of this configuration type
## [code]var name = config.get_config_name()[/code]
func get_config_name() -> String:
	return "JumpBoostConfig" 