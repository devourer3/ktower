# Monster.gd (몬스터 씬의 루트 노드에 연결)

extends CharacterBody2D # 또는 Area2D 등

# 이동 속도 (픽셀/초)
@export var speed: float = 100 

# PathFollow2D의 progress_ratio를 저장할 변수
var path_progress: float = 0.0

# 부모 노드(PathFollow2D)에 접근하기 위한 변수
var path_follow: PathFollow2D

func _ready():
	# 부모 노드가 PathFollow2D인지 확인
	if get_parent() is PathFollow2D:
		path_follow = get_parent()
	else:
		print("경고: 몬스터는 PathFollow2D의 자식이어야 합니다.")
		queue_free() # 잘못 배치되었으면 제거

func set_movement_speed(new_speed: float):
	speed = new_speed

func _process(delta):
	if path_follow == null:
		return

	# delta (초) * speed (픽셀/초) = 이동할 거리 (픽셀)
	var distance_to_move = speed * delta 
	
	# 몬스터가 이동해야 할 경로의 길이를 가져옵니다.
	var path_length = path_follow.get_parent().curve.get_baked_length()
	
	# 이동할 거리를 PathFollow2D의 progress_ratio(0.0~1.0) 증가분으로 변환합니다.
	var progress_increase = distance_to_move / path_length
	
	# path_progress를 업데이트
	path_progress += progress_increase
	
	# PathFollow2D의 progress_ratio를 업데이트하여 몬스터를 이동시킵니다.
	path_follow.progress_ratio = path_progress

	# 몬스터가 경로의 끝에 도달했는지 확인 (progress_ratio가 1.0을 초과)
	if path_progress >= 1.0:
		target_reached()

func target_reached():
	print("몬스터가 목표 지점에 도달했습니다!")
	# 여기에 게임에 피해를 주거나, 몬스터를 제거하는 등의 로직을 추가합니다.
	queue_free() # 몬스터 제거

	# 필요한 경우, 게임 관리자(Game Manager) 노드에게 목표 도달 사실을 알립니다.
	# get_tree().get_root().find_child("GameManager").take_damage()
