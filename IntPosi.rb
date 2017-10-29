# -*- coding: utf-8 -*-
require 'CHaserConnect.rb'
target = CHaserConnect.new("「  」")

initPosi = nil #初期位置判定 0=左上 1=左下 2=右下 3=右上
i = 0 # for文
wallCountA = 0 # 壁A測定一回目
itemCountA = 0 # アイテムA測定二回目
wallCountB = 0 # 壁B測定一回目
itemCountB = 0 # アイテムB測定二回目
judgA = 0 # 初期移動方向判定一回目
judgB = 0 # 初期移動方向判定二回目

# 初期位置把握
values = target.getReady
values = target.searchUp
if values[9] == 2
	values = target.getReady
	values = target.searchLeft
    if values[9] == 2
		intPosi = 0
	else
		intPosi = 3
	end
else
		values = target.getReady
		values = target.searchLeft
		if values[9] == 2
			intPosi = 1
		else
			intPosi = 2
		end
end

# マップ左上にいた時の行動
if intPosi == 0
	values = target.getReady
	values = target.lookDown
	for i in 1..9
          if values[i] == 2
          	wallCountA -= 2
          elsif values[i] == 3
          	itemCountA += 3
          end
  end

  values = target.getReady
	values = target.lookRight
	for i in 1..9
          if values[i] == 2
          	wallCountB -= 2
          elsif values[i] == 3
          	itemCountB += 3
          end
  end
    wallCountA - item_countA = judgA
    wallCountB - item_countB = judgB
    if judgA < judgB
    	values = target.walkRight
    else
    	values = target.walkDown
    end

# マップ左下にいた時の行動
elsif intPosi == 1
	values = target.getReady
	values = target.lookUp
	for i in 1..9
          if values[i] == 2
          	wallCountA -= 2
          elsif values[i] == 3
          	itemCountA += 3
          end
  end

  values = target.getReady
	values = target.lookRight
	for i in 1..9
          if values[i] == 2
          	wallCountB -= 2
          elsif values[i] == 3
          	itemCountB += 3
          end
  end
    wallCountA - item_countA = judgA
    wallCountB - item_countB = judgB
    if judgA < judgB
    	values = target.walkRight
    else
    	values = target.walkUp
    end

# マップ右下にいた時の行動
elsif intPosi == 2
	values = target.getReady
	values = target.lookUp
	for i in 1..9
          if values[i] == 2
          	wallCountA -= 2
          elsif values[i] == 3
          	itemCountA += 3
          end
  end

  values = target.getReady
	values = target.lookLeft
	for i in 1..9
          if values[i] == 2
          	wallCountB -= 2
          elsif values[i] == 3
          	itemCountB += 3
          end
  end
    wallCountA - item_countA = judgA
    wallCountB - item_countB = judgB
    if judgA < judgB
    	values = target.walkLeft
    else
    	values = target.walkUp
    end

# マップ右上にいた時の行動
elsif intPosi == 3
	values = target.getReady
	values = target.lookDown
	for i in 1..9
          if values[i] == 2
          	wallCountA -= 2
          elsif values[i] == 3
          	itemCountA += 3
          end
  end

  values = target.getReady
	values = target.lookLeft
	for i in 1..9
          if values[i] == 2
          	wallCountB -= 2
          elsif values[i] == 3
          	itemCountB += 3
          end
  end
    wallCountA - item_countA = judgA
    wallCountB - item_countB = judgB
    if judgA < judgB
    	values = target.walkLeft
    else
    	values = target.walkDown
    end
end
