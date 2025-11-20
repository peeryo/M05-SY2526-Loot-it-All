extends Area2D
		
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	var tween := create_tween()
	var sprite_2d := get_node("Sprite2D")
	var target_position := Vector2(500,400)
	var animation_duration := 2.0
	tween.tween_property(sprite_2d, "position", target_position, animation_duration)
	play_floating_animation()
	
func play_floating_animation() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	var sprite2d := get_node("Sprite2D")
	var position_offset := Vector2(0.0,4.0)
	var duration = randf_range(0.8, 1.2)
	tween.tween_property(sprite2d, "position", position_offset, duration)
	tween.tween_property(sprite2d, "position", -1.0 * position_offset, duration)
	tween.set_loops()

func _on_area_entered(area_that_entered: Area2D) -> void:
	queue_free()
