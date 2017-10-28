# -*- coding: utf-8 -*-
require 'CHaserConnect.rb'
target = CHaserConnect.new("「  」")

initPosi = nil #初期値判定 0=左上 1=左下 2=右下 3=右上
i = 0 # for文
wallCountA = 0 # 壁A測定一回目
itemCountA = 0 # アイテムA測定二回目
wallCountB = 0 # 壁B測定一回目
itemCountB = 0 # アイテムB測定二回目
JudgA = 0 # 初期移動方向判定一回目
JudgB = 0 # 初期移動方向判定二回目

# 初期位置把握
values = target.getReady
values = target.searchUp
if values[9] == 2
	values = target.getReady
	values = target.searchLeft
    if values[9] == 2
		IntPosi = 0
	else
		IntPosi = 3
	end
else
	values = target.getReady
	values = target.searchDown
	if values[9] == 2
		values = target.getReady
		values = target.searchRight
		if values[9] == 2
			IntPosi = 2
		else
			IntPosi = 1
		end
	end
end

# マップ左上にいた時の行動
if IntPosi == 0
	values = target.getReady
	values = target.lookDown
	for i in 1..9
          if values[i] == 2
          	wallCountA += 1
          elsif values[i] == 3
          	itemCountA += 1
          end
    end

    values = target.getReady
	values = target.lookRight
	for i in 1..9
          if values[i] == 2
          	wallCountB += 1
          elsif values[i] == 3
          	itemCountB += 1
          end
    end
    wallCountA - item_countA = JudgA
    wallCountB - item_countB = JudgB
    if JudgA < JudgB
    	values = target.walkRight
    else
    	values = target.walkDown
    end

# マップ左下にいた時の行動
elsif IntPosi == 1
	values = target.getReady
	values = target.lookUp
	for i in 1..9
          if values[i] == 2
          	wallCountA += 1
          elsif values[i] == 3
          	itemCountA += 1
          end
    end

    values = target.getReady
	values = target.lookRight
	for i in 1..9
          if values[i] == 2
          	wallCountB += 1
          elsif values[i] == 3
          	itemCountB += 1
          end
    end
    wallCountA - item_countA = JudgA
    wallCountB - item_countB = JudgB
    if JudgA < JudgB
    	values = target.walkRight
    else
    	values = target.walkUp
    end

# マップ右下にいた時の行動
elsif IntPosi == 2
	values = target.getReady
	values = target.lookUp
	for i in 1..9
          if values[i] == 2
          	wallCountA += 1
          elsif values[i] == 3
          	itemCountA += 1
          end
    end

    values = target.getReady
	values = target.lookLeft
	for i in 1..9
          if values[i] == 2
          	wallCountB += 1
          elsif values[i] == 3
          	itemCountB += 1
          end
    end
    wallCountA - item_countA = JudgA
    wallCountB - item_countB = JudgB
    if JudgA < JudgB
    	values = target.walkLeft
    else
    	values = target.walkUp
    end

# マップ右上にいた時の行動
elsif IntPosi == 3
	values = target.getReady
	values = target.lookDown
	for i in 1..9
          if values[i] == 2
          	wallCountA += 1
          elsif values[i] == 3
          	itemCountA += 1
          end
    end

    values = target.getReady
	values = target.lookLeft
	for i in 1..9
          if values[i] == 2
          	wallCountB += 1
          elsif values[i] == 3
          	itemCountB += 1
          end
    end
    wallCountA - item_countA = JudgA
    wallCountB - item_countB = JudgB
    if JudgA < JudgB
    	values = target.walkLeft
    else
    	values = target.walkDown
    end
end
