# Spawner.gd (몬스터 스폰을 담당하는 노드에 연결)
extends Node2D

# [설정] 몬스터가 생성되는 주기 (초). 2.0초로 설정.
@export var spawn_interval: float = 2.0

# 몬스터 스폰 간격을 조절하기 위한 타이머
var spawn_timer: Timer

func _ready():
	# 타이머 설정 및 시작
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.wait_time = spawn_interval # 1초마다 스폰
	spawn_timer.timeout.connect(spawn_monster)
	spawn_timer.start()

func spawn_monster():
	var monster_1_follow_scene = preload("res://monster/monster_1_path.tscn")
	# 1. 몬스터 인스턴스 생성
	var monster = monster_1_follow_scene.instantiate()

	# 2. 몬스터를 PathFollow2D의 자식으로 추가
	# 이렇게 하면 몬스터는 PathFollow2D를 따라 움직이게 됩니다.
	add_child(monster)

	# 3. 몬스터의 초기 오프셋을 0으로 설정하여 경로 시작 지점에서 시작하도록 합니다.
	#path_2d.progress_ratio = 0.0

	# 몬스터 스크립트에 필요한 초기값을 설정할 수 있습니다. (예: 속도)
	if monster.has_method("set_movement_speed"):
		monster.set_movement_speed(200) # 몬스터가 이동할 속도 (픽셀/초)
