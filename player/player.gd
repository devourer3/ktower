extends CharacterBody2D


const MOTION_SPEED = 200 # Pixels/second.

var lastDirection = 0

# 자식 노드인 AnimatedSprite2D를 가져옵니다.
@onready var animatedSprite = $AnimatedSprite2D
#@onready var tile_map_layer = get_parent().get_node("TileMapLayer")

@export var tile_map_layer: TileMapLayer

func ready():
	if tile_map_layer == null:
		push_error("TileMapLayer 노드가 Player 스크립트에 연결되지 않았습니다.")
	
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
	var is_placeable: bool = get_tile_custom_data('placeable', false)
	print('is_placeable: ', is_placeable)
	return;
	
# --- 타일 데이터 조회 함수 ---
func get_tile_custom_data(data_name: String, default_value: bool) -> bool:
	if tile_map_layer == null:
		return default_value
		# 1. 현재 플레이어의 글로벌 위치를 타일맵의 로컬 좌표로 변환
	#var local_pos = tile_map_layer.to_local(global_position)
	#print('local_pos: ', local_pos);
	
	# 1. 플레이어의 글로벌 위치를 TileMap 로컬 좌표로 변환
	var local_pos = tile_map_layer.to_local(global_position)
	# 2. 로컬 좌표를 타일 맵의 셀 좌표(Vector2i)로 변환
	var cell_coords: Vector2i = tile_map_layer.local_to_map(local_pos)
	# 3. 해당 셀 좌표의 TileData 객체 가져오기
	var tile_data: TileData = tile_map_layer.get_cell_tile_data(cell_coords)
	# 4. TileData가 존재하고 커스텀 데이터가 있다면 값을 반환
	if tile_data != null:
		var custom_data = tile_data.get_custom_data(data_name)
		return custom_data
	else:
		return false
	
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
