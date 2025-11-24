extends CharacterBody2D


const MOTION_SPEED = 200 # Pixels/second.

var lastDirection = 0

# 자식 노드인 AnimatedSprite2D를 가져옵니다.
@onready var animatedSprite = $AnimatedSprite2D

func _physics_process(delta: float):
	# Add the gravity.
	#if not is_on_floor():
	var motion = Vector2()
	motion.x = Input.get_action_strength(&"move_right") - Input.get_action_strength(&"move_left")
	motion.y = Input.get_action_strength(&"move_down") - Input.get_action_strength(&"move_up")
	motion.y /= 2
	motion = motion.normalized() * MOTION_SPEED
	
	set_velocity(motion)
	var dir = velocity
	var xPosition: int = dir.x
	var direction = dir.length()
	#var yPosition: int = dir.y;
	if direction > 0: # 0 이상이면 움직이는거
		update_animation("walk", xPosition)
	else:
		update_animation("idle", xPosition)
	move_and_slide()
	return;
	
func update_animation(anim_set: String, xPosition: int):
	if anim_set == "walk":
		animatedSprite.animation = "right_walk"
		if xPosition > 0:
			animatedSprite.flip_h = false
		elif(xPosition < 0):
			animatedSprite.flip_h = true
		lastDirection = xPosition
	else:
		animatedSprite.animation = "idle"
