## Module: JumpBoostModule  
## Purpose: Jump Boost feature implementation - enhances player jump height
## Dependencies: FeatureModule, JumpBoostConfig
##

# Jump Boost feature module implementation
# Provides configurable jump height enhancement with visual effects and cooldown system

@tool
extends FeatureModule

## Module variables
var config: JumpBoostConfig
var _api: JumpBoostAPI

## Boost state tracking
var current_uses: int = 0
var is_cooling_down: bool = false
var boost_active: bool = false
var original_jump_velocity: float = 0.0

## Timers
var cooldown_timer: Timer
var boost_timer: Timer

## Visual effects
var particles: GPUParticles2D
# Note: boost_label removed - external tester handles UI display

## Initialize the jump boost module with typed configuration taking [module_config] [br]
## [code]module.init(jump_boost_config)[/code]
func init(module_config: ModuleConfig) -> void:
	if module_config is JumpBoostConfig:
		config = module_config as JumpBoostConfig
		print("JumpBoost: Initializing with config - Multiplier: ", config.boost_multiplier, "x, Duration: ", config.boost_duration, "s")
	else:
		print("JumpBoost: Invalid configuration type received, using defaults")
		config = JumpBoostConfig.new()
		config = config.get_default_config() as JumpBoostConfig

## Called when the module is ready [br]
## [code]module.ready()[/code]
func ready() -> void:
	print("JumpBoost: Module ready! Boost: ", config.boost_multiplier, "x for ", config.boost_duration, "s")
	
	# Create API interface
	_api = JumpBoostAPI.new(self)
	
	# Setup timers
	setup_timers()
	
	# Setup visual effects
	setup_visual_effects()
	
	# Note: Simulation logic moved to external test scene

## Called when the module is being unloaded [br]
## [code]module.shutdown()[/code]
func shutdown() -> void:
	print("JumpBoost: Shutting down")
	if cooldown_timer:
		cooldown_timer.queue_free()
	if boost_timer:
		boost_timer.queue_free()
	if particles:
		particles.queue_free()
	# Note: boost_label removed - external tester handles UI

## Returns the name of this module [br]
## [code]var name = module.get_module_name()[/code]
func get_module_name() -> String:
	return "jump_boost"

## Returns the API interface for this module [br]
## [code]var api = module.get_api()[/code]
func get_api() -> ModuleAPI:
	return _api

## Initialize the cooldown and boost timers [br]
## [code]setup_timers()[/code]
func setup_timers() -> void:
	# Cooldown timer
	cooldown_timer = Timer.new()
	cooldown_timer.wait_time = config.cooldown_time
	cooldown_timer.one_shot = true
	cooldown_timer.timeout.connect(_on_cooldown_finished)
	add_child(cooldown_timer)
	
	# Boost duration timer
	boost_timer = Timer.new()
	boost_timer.wait_time = config.boost_duration
	boost_timer.one_shot = true
	boost_timer.timeout.connect(_on_boost_finished)
	add_child(boost_timer)

## Initialize visual effects for the boost [br]
## [code]setup_visual_effects()[/code]
func setup_visual_effects() -> void:
	# Create particles for visual effect
	particles = GPUParticles2D.new()
	particles.emitting = false
	particles.amount = 50
	particles.lifetime = config.boost_duration
	add_child(particles)
	
	# Note: Status label removed - external tester handles UI display

## Loads the default configuration for this module [br]
## [code]module.load_default_config()[/code]
func load_default_config() -> void:
	# Use the new portable resource loading
	var module_path = get_script().resource_path.get_base_dir()
	var default_config = FeatureConfig.load_module_resource(
		module_path + "/config_default.tres",
		module_path + "/config.gd"
	)
	
	if default_config:
		config = default_config
		print("JumpBoostModule: Default configuration loaded successfully")
	else:
		# Fallback to creating a new config
		config = JumpBoostConfig.new()
		print("JumpBoostModule: Created new default configuration")

## Activates the jump boost if available [br]
## [code]var success = activate_boost()[/code]
func activate_boost() -> bool:
	if is_cooling_down or boost_active:
		return false
	
	if current_uses >= config.max_uses:
		start_cooldown()
		return false
	
	# Activate boost
	boost_active = true
	current_uses += 1
	
	# Start boost timer
	boost_timer.wait_time = config.boost_duration
	boost_timer.start()
	
	# Visual effects
	if config.visual_effect:
		particles.emitting = true
		particles.modulate = config.particle_color
	
	# Audio effect (simulated)
	if config.boost_sound:
		print("JumpBoost: *BOOST SOUND*")
	
	print("JumpBoost: Boost activated! (", current_uses, "/", config.max_uses, " uses)")
	update_status_display()
	return true

## Deactivates the current boost early [br]
## [code]var success = deactivate_boost()[/code]
func deactivate_boost() -> bool:
	if not boost_active:
		return false
	
	boost_active = false
	boost_timer.stop()
	particles.emitting = false
	print("JumpBoost: Boost deactivated manually")
	update_status_display()
	return true

## Starts the cooldown period [br]
## [code]start_cooldown()[/code]
func start_cooldown() -> void:
	is_cooling_down = true
	current_uses = 0
	cooldown_timer.wait_time = config.cooldown_time
	cooldown_timer.start()
	print("JumpBoost: Cooldown started (", config.cooldown_time, "s)")
	update_status_display()

## Updates the status display with current boost information [br]
## [code]update_status_display()[/code]
func update_status_display() -> void:
	# Status display removed - external tester handles UI
	# This function is kept for compatibility but does nothing
	pass

## Handle cooldown timer completion [br]
## [code]_on_cooldown_finished()[/code]
func _on_cooldown_finished() -> void:
	is_cooling_down = false
	current_uses = 0
	print("JumpBoost: Cooldown finished - ready to boost!")
	update_status_display()

## Handle boost duration timer completion [br]
## [code]_on_boost_finished()[/code]
func _on_boost_finished() -> void:
	boost_active = false
	particles.emitting = false
	print("JumpBoost: Boost effect ended")
	update_status_display()

 