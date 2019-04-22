# -*- coding: utf-8 -*-
require 'CHaserConnect.rb'

# サーバに接続
target = CHaserConnect.new("P1") # この名前を4文字までで変更する

# main
values = Array.new(10) # 書き換えない
random = Random.new    # 乱数生成

destination = nil      # 向き (0=上, 1=右, 2=下, 3=左)
prev = 0			   # 直前の向き
actpat = 0             # 行動の種類 (0=default, 1=walk, 2=put, 3=look, 4=search)


def isThereWall(destination, values)
	case destination
		when 0 # 0 = 上
			if values[2] == 2
				ans = true
			else
				ans = false
			end
  		when 1 # 1 = 右
  			if values[6] == 2
				ans = true
			else
				ans = false
			end
	  	when 2 # 2 = 下
			if values[8] == 2
				ans = true
			else
				ans = false
			end
	  	when 3 # 3 = 左
	  		if values[4] == 2
				ans = true
			else
				ans = false
			end
  	end
  	return ans
end

def isPrevPos(destination, prev)
	if reverseDestination(destination) == prev
		return true
	else
		return false
	end
end

def isDeadEnd(values, prev)
	ans = true
	for i in 0..3
		if i != reverseDestination(prev) && !isThereWall(i, values)
			# print "not dead end\n"
			ans = false
			break
  		end
  	end
  	return ans
end


def isThereNeighbor(values)
	ans = false
	for i in 1..9
		if values[i] == 1
			ans = true
		end
	end
	return ans
end

def respondToNeighbor(values, destination, actpat)
	for i in 1..9
		if values[i] == 1
			case i
			when 2
				destination = 0
				actpat = 2
			when 4
				destination = 3
				actpat = 2
			when 6
				destination = 1
				actpat = 2
			when 8
				destination = 2
				actpat = 2
			end
		end
	end
	return destination, actpat
end


def isThereItem(values)
	ans = false
	for i in 1..9
		if values[i] == 3
			ans = true
		end
	end
	return ans
end

def respondToItem(values, destination, actpat)
	for i in 1..9
		if values[i] == 3
			case i
			when 2
				destination = 0
				actpat = 1
			when 4
				destination = 3
				actpat = 1
			when 6
				destination = 1
				actpat = 1
			when 8
				destination = 2
				actpat = 1
			end
		end
	end
	return destination, actpat
end


def reverseDestination(destination)
	return (destination + 2) % 4
end

def turnBack(prev)
	actpat = 1
	return reverseDestination(prev), actpat
end

def moveSomewhere(values, destination, random, prev)
	# ランダムウォーク
	loop do
		destination = random.rand(0..3)
		if !isThereWall(destination, values) && !isPrevPos(destination, prev)
			break
		end
	end
	actpat = 1
  	return destination, actpat
end


def putWall(values, destination, target)
	case destination
	when 0
		values = target.putUp
	when 1
		values = target.putRight
	when 2
		values = target.putDown
	when 3
		values = target.putLeft
	end
	return values
end

def walk(values, destination, target)
	case destination
  	when 0 # 0 = 上
		values = target.walkUp
  	when 1 # 1 = 右
  		values = target.walkRight
	when 2 # 2 = 下
		values = target.walkDown
	when 3 # 3 = 左
		values = target.walkLeft
  	end
  	return values, destination
end

def action(values, destination, target, prev, actpat) # 行動の種類 (0=default, 1=walk, 2=put, 3=look, 4=search)
	case actpat
	when 1
		values, prev = walk(values, destination, target)
	when 2
		values = putWall(values, destination, target)
	end
	return values, prev
end



loop do # 無限ループ
  values = target.getReady

  if values[0] == 0             # 先頭が0になったら終了
    break
  end
  #----- ここから -----
  if isThereNeighbor(values)
  	destination, actpat = respondToNeighbor(values, destination, actpat)
  elsif isThereItem(values)
  	destination, actpat = respondToItem(values, destination, actpat)
  elsif isDeadEnd(values, prev)
  	destination, actpat = turnBack(prev)
  else
  	destination, actpat = moveSomewhere(values, destination, random, prev)
  end

  values, prev = action(values, destination, target, prev, actpat)
  #----- ここまで -----
end

target.close # ソケットを閉じる
