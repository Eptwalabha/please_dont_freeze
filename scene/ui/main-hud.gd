class_name UI
extends CanvasLayer

@onready var nokia: PhoneUI = %Nokia
@onready var ui_context: Label = %UIContext
@onready var context_bar: NinePatchRect = $ContextBar
@onready var agility: Node2D = $Agility
@onready var dialog_ui: DialogUI = $DialogUI


func _ready() -> void:
	context_bar.visible = false
	agility.visible = false
	GameUI.dialog_requested.connect(_on_dialog_requested)
	GameUI.dialog_stopped.connect(_on_dialog_stopped)
	GameUI.action_context_shown.connect(_on_action_context_shown)
	GameUI.action_context_hidden.connect(_on_action_context_hidden)
	GameUI.phone_drawn.connect(_on_phone_drawn)
	GameUI.phone_hidden.connect(_on_phone_hidden)

	GameData.ui_agility_pressed.connect(_on_action_context_hidden)


func clear() -> void:
	dialog_ui.stop()
	context_bar.visible = false


func _on_dialog_requested(dialog_id: StringName, dialog_lines: Array[StringName]) -> void:
	dialog_ui.set_dialog_lines(dialog_id, dialog_lines)
	dialog_ui.next_dialog()


func _on_dialog_stopped() -> void:
	dialog_ui.stop()


func _on_action_context_hidden() -> void:
	context_bar.visible = false


func _on_action_context_shown(context_label: StringName) -> void:
	ui_context.text = tr(context_label)
	context_bar.visible = true


func _on_phone_drawn() -> void:
	nokia.toggle(true)


func _on_phone_hidden() -> void:
	nokia.toggle(false)
