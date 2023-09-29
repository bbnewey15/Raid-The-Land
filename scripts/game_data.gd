extends Node

#DEBUG
var debug_mode : bool = true
var acting_as_enemy : bool = false
#

# State
var ui_active_slot_data : SlotData
var full_slot_array: Array[SlotData] = []

# setter
func set_ui_active_slot_data(slot_data: SlotData):
	ui_active_slot_data = slot_data
	EncounterBus.ui_active_slot_data_changed.emit()

# Encounter Data
const UNIT_SIZE = Vector2(110,110)
const COLUMN_SIZE = Vector2(150,520)
## Player
const backColumnLocation: Vector2 = Vector2(99, 20)
const backColumnRotation: float = 6.8
const frontColumnLocation: Vector2 = Vector2(273, 20)
const frontColumnRotation: float = 3.6
#const backColumnLocation: Vector2 = Vector2(442, 20)
#const backColumnRotation: float = .8

## Enemey
#const backEnemyColumnLocation: Vector2 = Vector2(945, 20)
#const backEnemyColumnRotation: float = -6.8
const backEnemyColumnLocation: Vector2 = Vector2(772, 20)
const backEnemyColumnRotation: float = -3.6
const frontEnemyColumnLocation: Vector2 = Vector2(602, 20)
const frontEnemyColumnRotation: float = -.8

# Columns
enum COLUMN_STRING {PLAYER_FRONT_COL, PLAYER_BACK_COL,ENEMY_FRONT_COL, ENEMY_BACK_COL  }
const PLAYER_FRONT_COL = "playerFrontCol"
const PLAYER_BACK_COL = "playerBackCol"
const ENEMY_FRONT_COL = "enemyFrontCol" 
const ENEMY_BACK_COL ="enemyBackCol"

static func getColumnStringByIndex(index : int) -> String:
	return GameData[GameData.COLUMN_STRING.keys()[index]]
	
func getColumnStringByColumnType(column_type: COLUMN_TYPE, isEnemy: bool =false)-> String:
	var return_value = null
	var test = COLUMN_TYPE.keys()[column_type]
	
	if isEnemy:
		match GameData[COLUMN_TYPE.keys()[column_type]]:
			FRONT:
				return_value = ENEMY_FRONT_COL
			BACK:
				return_value = ENEMY_BACK_COL
	else:
		match GameData[COLUMN_TYPE.keys()[column_type]]:
			FRONT:
				return_value = PLAYER_FRONT_COL
			BACK:
				return_value = PLAYER_BACK_COL
				
	assert(return_value)
	return return_value

enum COLUMN_TYPE {FRONT,BACK}
const FRONT = "front"
const BACK = "back"

enum MOVE_DIRECTION {LEFT, RIGHT}
const LEFT = 0
const RIGHT = 1

# Action related
enum UNIT_ACTIONS {ATTACK, DEFEND, SUPPORT}
const ATTACK = 0
const DEFEND = 1
const SUPPORT = 2

const ATTACK_ICON = preload("res://assets/attack_icon.png")
const DEFENSE_ICON = preload("res://assets/defense_icon.png")
const SUPPORT_ICON = preload("res://assets/support_icon.png")

func get_icon_by_action(action: GameData.UNIT_ACTIONS)-> Texture:
	assert(GameData.UNIT_ACTIONS.find_key(action))
	
	match action:
			GameData.UNIT_ACTIONS.ATTACK:
				return GameData.ATTACK_ICON
			GameData.UNIT_ACTIONS.DEFEND:
				return GameData.DEFENSE_ICON
			GameData.UNIT_ACTIONS.SUPPORT:
				return GameData.SUPPORT_ICON
	
	assert(false)
	return null


## State 
enum STATE_NAMES {START, DRAFT, PLAYER_TURN,ENEMY_TURN, POST_FIGHT}
const START = "Start"
const DRAFT = "Draft"
const PLAYER_TURN = "PlayerTurn"
const ENEMY_TURN = "EnemyTurn"
const POST_FIGHT = "PostFight"


const START_STATE_INTRO_TIMEOUT : float = 3.0


func eagernessOrderComparison(a : SlotData, b : SlotData):
		
	if typeof(a.unit_data.eagerness) != typeof(b.unit_data.eagerness):
		return typeof(a.unit_data.eagerness) > typeof(b.unit_data.eagerness)
	else:
		if  a.unit_data.eagerness == b.unit_data.eagerness:
			if !a.isEnemyUnit and b.isEnemyUnit:
				return true
			if !b.isEnemyUnit and a.isEnemyUnit:
				return false
				
		return a.unit_data.eagerness > b.unit_data.eagerness
