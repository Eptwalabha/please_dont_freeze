extends Node

signal temperature_changed(temp)

signal dialog_started(dialog_id)
signal dialog_ended(dialog_id)

#signal phone_message_received(dialog)
#signal phone_message_opened
#signal phone_change_screen(screen_name)
#signal phone_drawn
#signal phone_hidden

signal game_start
signal game_over
signal final_scene

signal force_trigger_entered(trigger)
signal force_trigger_exited
signal force_trigger_opened(trigger)

signal ui_agility_pressed
signal ui_agility_released
signal ui_agility_score(score)

signal flashlight_found
signal bob_arrived
signal player_grabbed_by_bob

const DRAWN_SPEED: float = 5.0

var audio: AudioHandler
var is_music_muted: bool = false
var is_sound_muted: bool = false
var current_checkpoint_id: int = 0
var active_force_trigger: ForceTrigger


func _ready() -> void:
	audio = preload("res://scene/core/audio.tscn").instantiate()
	add_child(audio)


func reload_game() -> void:
	game_start.emit()


func open_sms() -> void:
	pass


func show_phone() -> void:
	GameUI.phone_drawn.emit()


func hide_phone() -> void:
	GameUI.phone_hidden.emit()


func trigger(trigger_id: StringName) -> void:
	match trigger_id:
		"player-dies":
			game_over.emit()
		"summon-bob":
			bob_arrived.emit()
		"scare-enemies":
			despawn_enemies()


func trigger_dialog(trigger_id: StringName, dialog_id: StringName) -> void:
	match trigger_id:
		"dialog-player":
			GameUI.request_dialog_line(trigger_id, dialog_id)
		"dialog-phone":
			GameUI.phone_sms_received.emit()
			GameUI.request_dialog_line(trigger_id, dialog_id)


func force_available(the_trigger: ForceTrigger, available: bool) -> void:
	if available:
		active_force_trigger = the_trigger
		force_trigger_entered.emit(the_trigger)
		GameUI.show_action_context(the_trigger.context_line)
	else:
		force_trigger_exited.emit()
		GameUI.hide_action_context()


func current_force_score(score: float) -> void:
	if active_force_trigger != null:
		active_force_trigger.force_score(score)
	GameData.ui_agility_score.emit(score)


func car_battery_died() -> void:
	await get_tree().create_timer(2.0).timeout
	flashlight_found.emit()


func is_checkpoint_passed(checkpoint_id: int) -> bool:
	return checkpoint_id == -1 or current_checkpoint_id >= checkpoint_id


func despawn_enemies() -> void:
	for enemy in get_tree().get_nodes_in_group("shadow"):
		enemy.escape()
