extends Node3D

@onready var button_left = $Camera3D/PlayerUI/Left
@onready var button_right = $Camera3D/PlayerUI/Right

var target_rotation_y: float = 0.0
var able_to_turn = true

func _init() -> void:
	pass

func _process(delta: float) -> void:
	pass
	
func _on_left_pressed() -> void:
	if able_to_turn:
		target_rotation_y += 90
		animate_rotation()
	else:
		pass

func _on_right_pressed() -> void:
	if able_to_turn:
		target_rotation_y -= 90
		animate_rotation()
	else:
		pass

func animate_rotation() -> void:
	able_to_turn = false
	var tween = get_tree().create_tween()

	tween.tween_property(self, "rotation_degrees:y", target_rotation_y, 0.4).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	able_to_turn = true
