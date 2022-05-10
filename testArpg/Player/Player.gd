tool
extends KinematicBody2D

enum{
	MOVE,
	ROLL,
	ATTACK,
}

const ACCELERATION = 500 # 加速度
const MAX_SPEED = 100 # 最大速度
const FRICTION = 400 # 摩擦力
var velocity = Vector2.ZERO #实际速度

var state = MOVE

onready var animationPlayer = $AnimationPlayer # 动画
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true

func _physics_process(delta):
	
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			pass
		ATTACK:
			attack_state(delta)
			

func move_state(delta):
	var input_velocity = Vector2.ZERO # 移动向量
	input_velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_velocity = input_velocity.normalized() # 使用向量，能解决对角线移动速度快的问题

	if input_velocity != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position",input_velocity)
		animationTree.set("parameters/Run/blend_position",input_velocity)
		animationTree.set("parameters/Attack/blend_position",input_velocity)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_velocity * MAX_SPEED , ACCELERATION * delta )  # 根据加速度 向输入*max的 速度靠近 ，起步
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO , FRICTION * delta)  # 根据摩擦力向 0 靠近， 停止
	#move_and_collide(velocity * delta) # 向量更新，*delta是上一帧时间 再乘上速度就是移动时间 自动解决物理碰撞问题
	velocity = move_and_slide(velocity) # 碰到物体会略微滑动 自动解决帧速问题  ，返回碰撞后的速度值，能解决卡角落的问题
	
	if Input.is_action_just_pressed("ui_attack"):
		state = ATTACK
	
func attack_state(delta):
	animationState.travel("Attack")
	
	
	
	
	
	
	
	
	
