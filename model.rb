# -*- coding: utf-8 -*-
require 'CHaserConnect.rb'

#　書き換えない
target = CHaserConnect.new("model") # ()の中好きな名前
values = Array.new(10)
random = Random.new # 乱数生成
# ループ前変数
InitPosi = nil # 初期値判定 0=左上 1=左下 2=右下 3=右上
i = 0 # for文
wallCountA = 0 # 壁A測定一回目
itemCountA = 0 # アイテムA測定二回目
wallCountB = 0 # 壁B測定一回目
itemCountB = 0 # アイテムB測定二回目
JudgA = 0 # 初期移動方向判定一回目
JudgB = 0 # 初期移動方向判定二回目
#ループ内変数
tar = nil # 0=put,1=walk,2=look
put = nil # 0=U,1=L,2=D,3=R
look = nil # 0=U,1=L,2=D,3=R
go = nil # 0=U,1=L,2=D,3=R
tarn = 0 # ターンカウント

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
    	go = 3
    else
    	go = 2
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
    	go = 3
    else
    	go = 0
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
    	go = 1
    else
    	go = 0
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
    	go = 1
    else
    	go = 2
    end
end


loop do # loop-start

#-----Non-rewritable-----
  values = target.getReady
  if values[0] == 0
    break
  end
#-----Non-rewritable-end-----

#var-init
  tar = nil

# item-sle
  if values[1] == 3
    rand = random.rand(0..1)
    if rand == 0
      go = 0 # U
      tar = 1
      if values[2] == 2
        go = 1 # L
        tar = 1
      end
    else
      go = 1 # L
      tar = 1
      if values[4] == 2
        go = 0 # U
        tar = 1
      end
    end
    elsif values[3] == 3
      rand = random.rand(0..1)
      if rand == 0
        go = 0 # U
        tar = 1
        if values[2] == 2
          go = 3 # R
          tar = 1
        end
      else
        go = 3 # R
        tar = 1
        if values[6] == 2
          go = 0 # U
          tar = 1
        end
      end
    elsif values[7] == 3
      rand = random.rand(0..1)
      if rand == 0
        go = 1 # L
        tar = 1
        if values[4] == 2
          go = 2 # D
          tar = 1
        end
      else
        go = 2 # D
        tar = 1
        if values[8] == 2
          go = 1 # L
          tar = 1
        end
      end
    elsif values[9] == 3
      rand = random.rand(0..1)
      if rand == 0
        go = 2 # D
        tar = 1
        if values[8] == 2
          go = 3 # R
          tar = 1
        end
      else
        go = 3 # R
        tar = 1
        if values[6] == 2
          go = 2 # D
          tar = 1
        end
      end
    end

# char-sle
  if values[1] == 1
    rand = random.rand(0..1)
    if rand == 0
      go = 3 # R
      tar = 1
      if values[6] == 2
        go = 2 # D
        tar = 1
        if values[8] == 2
          look = 0 # U
          tar = 2
        end
      end
    else
      go = 2 # D
      tar = 1
      if values[8] == 2
        go = 3 # R
        tar = 1
        if values[6] == 2
          look = 0 # U
          tar = 2
        end
      end
    end
    elsif values[3] == 1
      rand = random.rand(0..1)
      if rand == 0
        go = 1 # L
        tar = 1
        if values[4] == 2
          go = 2 # D
          tar = 1
          if values[8] == 2
            look = 0 # U
            tar = 2
          end
        end
      else
        go = 2 # D
        tar = 1
        if values[8] == 2
          go = 1 # L
          tar = 1
          if values[4] == 2
            look = 0 # U
            tar = 2
          end
        end
      end
    elsif values[7] == 1
      rand = random.rand(0..1)
      if rand == 0
        go = 3 # R
        tar = 1
        if values[6] == 2
          go = 0 # U
          tar = 1
          if values[2] == 2
            look = 2 # D
            tar = 2
          end
        end
      else
        go = 0 # U
        tar = 1
        if values[2] == 2
          go = 3 # R
          tar = 1
          if values[6] == 2
            look = 2 # D
            tar = 2
          end
        end
      end
    elsif values[9] == 1
      rand = random.rand(0..1)
      if rand == 0
        go = 1 # L
        tar = 1
        if values[4] == 2
          go = 0 # U
          tar = 1
          if values[2] == 2
            look = 2 # D
            tar = 2
          end
        end
      else
        go = 0 # U
        tar = 1
        if values[2] == 2
          go = 1 # L
          tar = 1
          if values[4] == 2
            look = 2 # D
            tar = 2
          end
        end
      end
  end
# block
  if go == 0 # Up
    if values[2] == 2
      rand = random.rand(0..1)
      if rand == 0
        go = 1 # L
        tar = 1
        if values[4] == 2
          go = 3 # R
          tar = 1
          if values[6] == 2
            go = 2 # D
            tar = 1
          end
        end
      else
        go = 3 # R
        tar = 1
        if values[6] == 2
          go = 1 # L
          tar = 1
          if values[4] == 2
            go = 2 # D
            tar = 1
          end
        end
      end
    end
    tar = 1
  end

  if go == 1 # Left
    if values[4] == 2
      rand = random.rand(0..1)
      if rand == 0
        go = 0 # U
        tar = 1
        if values[2] == 2
          go = 2 # D
          tar = 1
          if values[8] == 2
            go = 3 # R
            tar = 1
          end
        end
      else
        go = 2 # D
        tar = 1
        if values[8] == 2
          go = 0 # U
          tar = 1
          if values[2] == 2
            go = 3 # R
            tar = 1
          end
        end
      end
    end
    tar = 1
  end

  if go == 2 # Down
    if values[8] == 2
      rand = random.rand(0..1)
      if rand == 0
        go = 1 # L
        tar = 1
        if values[4] == 2
          go = 3 # R
          tar = 1
          if values[6] == 2
            go = 0 # U
            tar = 1
          end
        end
      else
        go = 3 # R
        tar = 1
        if values[6] == 2
          go = 1 # L
          tar = 1
          if values[4] == 2
            go = 0 # U
            tar = 1
          end
        end
      end
    end
    tar = 1
  end

  if go == 3 # Right
    if values[6] == 2
      rand = random.rand(0..1)
      if rand == 0
        go = 0 # U
        tar = 1
        if values[2] == 2
          go = 2 # D
          tar = 1
          if values[8] == 2
            go = 1 # L
            tar = 1
          end
        end
      else
        go = 2 # D
        tar = 1
        if values[8] == 2
          go = 0 # U
          tar = 1
          if values[2] == 2
            go = 1 # L
            tar = 1
          end
        end
      end
    end
    tar = 1
  end

# item
  if values[2] == 3
    go = 0
    tar = 1
  elsif values[4] == 3
    go = 1
    tar = 1
  elsif values[6] == 3
    go = 3
    tar = 1
  elsif values[8] == 3
    go = 2
    tar = 1
  end

# cher
  if values[2] == 1
    put = 0
    tar = 0
  elsif values[4] == 1
    put = 1
    tar = 0
  elsif values[6] == 1
    put = 2
    tar = 0
  elsif values[8] == 1
    put = 3
    tar = 0
  end

# target
  case tar
    when 0
      case put
        when 0
          values = target.putUp
          tarn += 1
        when 1
          values = target.putLeft
          tarn += 1
        when 2
          values =  target.putDown
          tarn += 1
        when 3
          values =  target.putRight
          tarn += 1
      end
    when 1
      case go
        when 0
          values = target.walkUp
          tarn += 1
        when 1
          values = target.walkLeft
          tarn += 1
        when 2
          values =  target.walkDown
          tarn += 1
        when 3
          values =  target.walkRight
          tarn += 1
      end
    when 2
      case look
      when 0
        values = target.lookUp
        tarn += 1
      when 1
        values = target.lookLeft
        tarn += 1
      when 2
        values =  target.lookDown
        tarn += 1
      when 3
        values =  target.lookRight
        tarn += 1
      end
  end

#-----Non-rewritable-----
  if values[0] == 0
    break
  end

end #loop end
target.close
#-----Non-rewritable-end-----
