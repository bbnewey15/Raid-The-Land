extends Node

#DEBUG
var debug_mode : bool = true
var acting_as_enemy : bool = false
#

# State
var ui_active_slot_data : SlotData
# All slots ordered according to Eagerness
var full_slot_array: Array[SlotData] = []

# setter
func set_ui_active_slot_data(slot_data: SlotData):
	ui_active_slot_data = slot_data
	EncounterBus.ui_active_slot_data_changed.emit()

# Encounter Data
const UNIT_SIZE = Vector2(110,110)
const COLUMN_SIZE = Vector2(150,520)
## Player
const backColumnLocation: Vector2 = Vector2(99, 0)
const backColumnRotation: float = 6.8
const frontColumnLocation: Vector2 = Vector2(273, 0)
const frontColumnRotation: float = 3.6
#const backColumnLocation: Vector2 = Vector2(442, 20)
#const backColumnRotation: float = .8

## Enemey
#const backEnemyColumnLocation: Vector2 = Vector2(945, 20)
#const backEnemyColumnRotation: float = -6.8
const backEnemyColumnLocation: Vector2 = Vector2(772,0)
const backEnemyColumnRotation: float = -3.6
const frontEnemyColumnLocation: Vector2 = Vector2(602,0)
const frontEnemyColumnRotation: float = -.8

# Columns
enum COLUMN_STRING {PLAYER_FRONT_COL, PLAYER_BACK_COL,ENEMY_FRONT_COL, ENEMY_BACK_COL  }
const PLAYER_FRONT_COL = "playerFrontCol"
const PLAYER_BACK_COL = "playerBackCol"
const ENEMY_FRONT_COL = "enemyFrontCol" 
const ENEMY_BACK_COL ="enemyBackCol"



static func getColumnStringByIndex(index : int) -> String:
	return GameData[GameData.COLUMN_STRING.keys()[index]]
	
static func getStringEnumByIndex(enum_name: String, index : int) -> String:
	return GameData[GameData[enum_name].keys()[index]]
	
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

enum MOVE_DIRECTION {LEFT = 0, RIGHT = 1}

# Action related
enum UNIT_ACTIONS {ATTACK  , DEFEND , SUPPORT, DEBUFF }

# UNIT DATA ATTRIBUTES
enum UNIT_DATA_ATTRIBUTES { MAX_HEALTH = 0, MAX_AP = 1, DAMAGE =2, SUPPORT_AMOUNT=3, DEFEND_RATIO=4, EAGERNESS=5, EVASIVENESS=6}
const MAX_HEALTH ="max_health"
const MAX_AP = "max_ap"
const DAMAGE= "damage"
const SUPPORT_AMOUNT="support_amount"
const DEFEND_RATIO="defend_ratio"
const EAGERNESS="eagerness"
const EVASIVENESS="evasiveness"

const ATTACK_ICON = preload("res://assets/attack_icon.png")
const DEFENSE_ICON = preload("res://assets/defense_icon.png")
const SUPPORT_ICON = preload("res://assets/support_icon.png")

# Target Type
enum ACTION_TARGET_TYPE { TARGET_SELF  , TARGET_ALLY , TARGET_ENEMY}

# CONDITIONS
enum CONDITIONS { HEAL, WEAKEN,STRENGTHEN , SHAKEN, INSPIRED, INFECT , CURE}

# STATUS
enum UNIT_STATUS { ALIVE, DEAD }

# ACTION SLIDER
enum ACTION_SLIDER_HIT { MISS = 0, SLIGHT = 1, HIT = 2 }

## State 
enum STATE_NAMES {START, DRAFT, FIGHT, POST_FIGHT}
const START = "Start"
const DRAFT = "Draft"
const FIGHT = "Fight"
const POST_FIGHT = "PostFight"


const START_STATE_INTRO_TIMEOUT : float = 3.0

func sort_full_slot_datas(full_array: Array[SlotData]) -> Array[SlotData]:
	# We need to separate those who have already used their turn		
	var turn_over : Array[SlotData] = full_array.filter(func(x): return x.turn_over == true) 		
	var turn_not_over : Array[SlotData] = full_array.filter(func(x): return x.turn_over == false) 
	
	turn_over.sort_custom(GameData.eagernessOrderComparison)
	turn_not_over.sort_custom(GameData.eagernessOrderComparison)
	
	var final_array : Array[SlotData] = []
	final_array.append_array(turn_not_over)
	final_array.append_array(turn_over)
	return final_array

func eagernessOrderComparison(a : SlotData, b : SlotData):
	var a_eagerness = a.unit_data.stat_data.getAttribute(GameData.UNIT_DATA_ATTRIBUTES.EAGERNESS).value
	var b_eagerness = b.unit_data.stat_data.getAttribute(GameData.UNIT_DATA_ATTRIBUTES.EAGERNESS).value
	
		
	if typeof(a_eagerness) != typeof(b_eagerness):
		return typeof(a_eagerness) > typeof(b_eagerness)
	else:
		if  a_eagerness == b_eagerness:
			if !a.isEnemyUnit and b.isEnemyUnit:
				return true
			if !b.isEnemyUnit and a.isEnemyUnit:
				return false
				
		return a_eagerness > b_eagerness
