# -*-coding: utf-8 -*-
require 'CHaserConnect.rb'
#　書き換えない
target = CHaserConnect.new("2019") # ()の中好きな名前
values = Array.new(10)
random = Random.new # 乱数生成

@aisle = 0
@enemy = 1
@kabe = 2
@item = 3

@up = 2
@left = 4
@right = 6
@down = 8

@walk = "walk"
@look = "look"
@search = "search"
@put = "put"

# ここから実行するメソッドを書いていく
def Move(target, direction)
	field = Array.new(10)
	case direction
	when @up
		field = target.walkUp
	when @left
		field = target.walkLeft
	when @right
		field = target.walkRight
	when @down
		field = target.walkDown
	end
	return field
end

def Look(target, direction)
	field = Array.new(10)
	case direction
	when @up
		field = target.lookUp
	when @left
		field = target.lookLeft
	when @right
		field = target.lookRight
	when @down
		field = target.lookDown
	end
	return field
end

def Search(target, direction)
	field = Array.new(10)
	case direction
	when @up
		field = target.searchUp
	when @left
		field = target.searchLeft
	when @right
		field = target.searchRight
	when @down
		field = target.searchDown
	end
	return field
end

def Put(target, direction)
	field = Array.new(10)
	case direction
	when @up
		field = target.putUp
	when @left
		field = target.putLeft
	when @right
		field = target.putRight
	when @down
		field = target.putDown
	end
	return field
end

def Action(mode, target, direction)
	field = Array.new(10)

	p mode, direction

	case mode
	when @walk
		field = Move(target, direction)
	when @look
		field = Look(target, direction)
	when @search
		field = Search(target, direction)
	when @put
		field = Put(target, direction)
	end
	return field, @walk
end

def ChangeDirection(random, direction)
	chengedDirection = random.rand(1..4) * 2
	if chengedDirection == direction
		ChangeDirection(random, direction)
	end
	return chengedDirection
end

def SuddenlyChangeDirection(elapsedTurns, random, direction)
	probability = random.rand(0..100)
	if probability < elapsedTurns * 25
		elapsedTurns = 0
		direction = ChangeDirection(random, direction)
		p 'Suddenly'
	else
		elapsedTurns += 1
	end
	return direction, elapsedTurns
end

# 規則性あり版
#def Kabeyoke(values, direction)
#	if values[direction] == @kabe
#		direction += 2
#		if direction > 8
#			direction -= 8
#		end
#		direction = Kabeyoke(values, direction)
#	end
#	return direction
#end

# 規則性なし版
def Kabeyoke(values, random, direction)
	if values[direction] == @kabe
		direction = Kabeyoke(values, random, ChangeDirection(random, direction))
	end
	return direction
end

def FindNeighbor(values, direction, mode)
	if values[@up] == @enemy
		direction = @up
		mode = @put
	elsif values[@right] == @enemy
		direction = @right
		mode = @put
	elsif values[@left] == @enemy
		direction = @left
		mode = @put
	elsif values[@down] == @enemy
		direction = @down
		mode = @put
	end
	return direction, mode
end

def FindNextItem(values, direction, mode)
	if values[@up] == @item
		direction = @up
		mode = @walk
	elsif values[@right] == @item
		direction = @right
		mode = @walk
	elsif values[@left] == @item
		direction = @left
		mode = @walk
	elsif values[@down] == @item
		direction = @down
		mode = @walk
	end
	return direction, mode
end

# ここまでに実行するメソッドを書いておく

# 初期化
direction = random.rand(1..4) * 2
elapsedTurns = 0
mode = @walk
# 初期化おわ


loop do # ここからループ
	#---------ここから---------
	values = target.getReady

	if values[0] == 0
		break
	end
	#-----ここまで書き換えない-----
	#---------ここから---------

	direction, elapsedTurns = SuddenlyChangeDirection(elapsedTurns, random, direction)
#	direction = Kabeyoke(values, direction)
	direction = Kabeyoke(values, random, direction)
	direction, mode = FindNextItem(values, direction, mode)
	direction, mode = FindNeighbor(values, direction, mode)
	if mode != "put"
		# look や search を使いこなそう
	end
	values, mode = Action(mode, target, direction)

	#---------ここまで---------
end # ループここまで
target.close
#-----ここまで書き換えない-----