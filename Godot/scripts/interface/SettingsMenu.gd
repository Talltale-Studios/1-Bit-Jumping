extends Control


onready var _gameplay_button : Button = $Overlay/SettingsTabs/GameplayButton
onready var _audio_button : Button = $Overlay/SettingsTabs/AudioButton
onready var _graphics_button : Button = $Overlay/SettingsTabs/GraphicsButton
onready var _controls_button : Button = $Overlay/SettingsTabs/ControlsButton
onready var _accessibility_button : Button = $Overlay/SettingsTabs/AccessibilityButton
onready var _gameplay_settings : Control = $Overlay/GameplaySettings
onready var _audio_settings : Control = $Overlay/AudioSettings
onready var _graphics_settings : Control = $Overlay/GraphicsSettings
onready var _controls_settings : Control = $Overlay/ControlsSettings
onready var _accessibility_settings : Control = $Overlay/AccessibilitySettings


func _physics_process(_delta) -> void:
	pass


func _on_VSlider_value_changed(value) -> void:
	#target.rect_position.y = value
	pass
