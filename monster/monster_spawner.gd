# Spawner.gd (몬스터 스폰을 담당하는 노드에 연결)
extends Node2D

# 몬스터 씬을 미리 로드합니다.
# 인스펙터 창에서 몬스터 씬 파일(.tscn)을 연결해주세요.
@export var monster_scene: PackedScene 

# 몬스터가 이동할 경로(Path2D) 노드의 경로를 설정합니다.
# 씬 트리의 Path2D 노드를 인스펙터 창에서 연결해주세요.
@export var path_follow_node: PathFollow2D 

# 몬스터 스폰 간격을 조절하기 위한 타이머
var spawn_timer: Timer

func _ready():
	# 타이머 설정 및 시작
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.wait_time = 1.0 # 2초마다 스폰
	spawn_timer.timeout.connect(spawn_monster)
	spawn_timer.start()

func spawn_monster():
	if monster_scene == null:
		print("경고: 몬스터 씬이 설정되지 않았습니다.")
		return

	if path_follow_node == null:
		print("경고: PathFollow2D 노드가 설정되지 않았습니다.")
		return

	# 1. 몬스터 인스턴스 생성
	var monster = monster_scene.instantiate()

	# 2. 몬스터를 PathFollow2D의 자식으로 추가
	# 이렇게 하면 몬스터는 PathFollow2D를 따라 움직이게 됩니다.
	path_follow_node.add_child(monster) 

	# 3. 몬스터의 초기 오프셋을 0으로 설정하여 경로 시작 지점에서 시작하도록 합니다.
	path_follow_node.progress_ratio = 0.0

	# 몬스터 스크립트에 필요한 초기값을 설정할 수 있습니다. (예: 속도)
	if monster.has_method("set_movement_speed"):
		monster.set_movement_speed(50) # 몬스터가 이동할 속도 (픽셀/초)
