extends CanvasLayer

@onready var anim: AnimationPlayer = get_node("anim")

var scene_path: String = ""
var can_quit: bool = false

func fade_in() -> void:
	anim.play("fade_in")
	


func _on_anim_animation_finished(anim_name):
	if anim_name == "fade_in":
		
		if can_quit:
			get_tree().quit()
			return
			
		get_tree().change_scene_to_file(scene_path)
		anim.play("fade_out")
		
