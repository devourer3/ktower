extends TileMapLayer

# === 인스펙터에서 설정해야 하는 값들 ===
#@export var main_map_layer_index: int = 0 
#@export var build_overlay_layer_index: int = 1 
#@export var build_data_layer_name: String = "placeable" 

# TileSet에서 초록색 타일의 정보
@export var buildable_tile_source_id: int = 0
@export var buildable_tile_atlas: TileSet

# TileSet에서 빨간색 타일의 정보
@export var unbuildable_tile_source_id: int = 1
@export var unbuildable_tile_atlas: TileSetAtlasSource
# ====================================

func _ready():
	# 게임 시작 시 오버레이를 숨깁니다.
	toggle_build_overlay(false)

func update_build_overlay():
	# 1. 오버레이 레이어를 비웁니다.
	# clear_layer() 메서드는 새 노드에도 존재한다고 가정합니다.
	# 2. 메인 맵 레이어에 사용된 모든 셀 좌표를 가져옵니다.
	# get_used_cells() 메서드도 존재한다고 가정합니다.
	var used_cells: Array[Vector2i] = get_used_cells()
	for cell_coords in used_cells:
		# 3. get_cell_tile_data()를 사용하여 TileData 객체를 가져옵니다.
		# 이 메서드는 새 노드에서도 타일 데이터를 접근하는 표준 방법이라고 가정합니다.
		var tile_data: TileData = get_cell_tile_data(cell_coords)
		
		if tile_data != null:
			var can_build = tile_data.get_custom_data('placeable')
			# 4. 값에 따라 set_cell()을 사용하여 타일을 그립니다.
			# set_cell() 메서드도 동일하게 레이어 인덱스를 첫 인자로 받는다고 가정합니다.
			#if can_build:
				#set_cell(cell_coords, buildable_tile_source_id, buildable_tile_atlas, 0)
			#else:
				#set_cell(cell_coords, buildable_tile_source_id, buildable_tile_atlas, 0)


func toggle_build_overlay(show: bool):
	#if show:
	update_build_overlay()
