# -*- coding: utf-8 -*-
require 'CHaserConnect.rb'

#　書き換えない
target = CHaserConnect.new("model") # ()の中好きな名前
values = Array.new(10)
random = Random.new # 乱数生成
# ループ前変数
initPosi = nil # 初期値判定 0=左上 1=左下 2=右下 3=右上
i = 0 # for文
wallCountA = 0 # 壁A測定一回目
itemCountA = 0 # アイテムA測定二回目
wallCountB = 0 # 壁B測定一回目
itemCountB = 0 # アイテムB測定二回目
judgA = 0 # 初期移動方向判定一回目
judgB = 0 # 初期移動方向判定二回目
#ループ内変数
tar = nil #　Walk,Put,Lookの分岐　0=put,1=walk,2=look
put = nil # Put 0=Up,1=Left,2=Down,3=Right
look = nil # Look 0=Up,1=Left,2=Down,3=Right
go = nil # 移動先 0=Up,1=Left,2=Down,3=Right
tarn = 4 # ターンカウント(初期移動の分の4)

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
	values = target.searchDown
	if values[9] == 2
		values = target.getReady
		values = target.searchRight
		if values[9] == 2
			intPosi = 2
		else
			intPosi = 1
		end
	end
end

# マップ左上にいた時の行動
if intPosi == 0
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
    wallCountA - item_countA = judgA
    wallCountB - item_countB = judgB
    if judgA < judgB
    	go = 3
    else
    	go = 2
    end

# マップ左下にいた時の行動
elsif intPosi == 1
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
    wallCountA - item_countA = judgA
    wallCountB - item_countB = judgB
    if judgA < judgB
    	go = 3
    else
    	go = 0
    end

# マップ右下にいた時の行動
elsif intPosi == 2
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
    wallCountA - item_countA = judgA
    wallCountB - item_countB = judgB
    if judgA < judgB
    	go = 1
    else
    	go = 0
    end

# マップ右上にいた時の行動
elsif intPosi == 3
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
    wallCountA - item_countA = judgA
    wallCountB - item_countB = judgB
    if judgA < judgB
    	go = 1
    else
    	go = 2
    end
end


loop do # ここからループ

#-----ここから-----
  values = target.getReady
  if values[0] == 0
    break
  end
#-----ここまで書き換えない-----

# アイテムが斜めにあった時
  if values[1] == 3
    rand = random.rand(0..1)
    if rand == 0
      go = 0 # 上に歩く
      tar = 1 # walkする
      if values[2] == 2
        go = 1 # 左に歩く
        tar = 1 # walkする
      end
    else
      go = 1 # 左に歩く
      tar = 1 #walkする
      if values[4] == 2
        go = 0 # 上に歩く
        tar = 1 # walkする
      end
    end
    elsif values[3] == 3
      rand = random.rand(0..1)
      if rand == 0
        go = 0 # 上に歩く
        tar = 1 # walkする
        if values[2] == 2
          go = 3 # 右に歩く
          tar = 1 # walkする
        end
      else
        go = 3 # 右に歩く
        tar = 1 #walkする
        if values[6] == 2
          go = 0 # 上に歩く
          tar = 1　# walkする
        end
      end
    elsif values[7] == 3
      rand = random.rand(0..1)
      if rand == 0
        go = 1 # 左に歩く
        tar = 1 # walkする
        if values[4] == 2
          go = 2 # 下に歩く
          tar = 1 # walkする
        end
      else
        go = 2 # 下に歩く
        tar = 1 # walkする
        if values[8] == 2
          go = 1 # 左に歩く
          tar = 1 # walkする
        end
      end
    elsif values[9] == 3
      rand = random.rand(0..1)
      if rand == 0
        go = 2 # 下に歩く
        tar = 1 # walkする
        if values[8] == 2
          go = 3 # 右に歩く
          tar = 1 # walkする
        end
      else
        go = 3 # 右に歩く
        tar = 1  # walkする
        if values[6] == 2
          go = 2 # 下に歩く
          tar = 1  # walkする
        end
      end
    end

# 斜めに敵がいたとき
  if values[1] == 1
    rand = random.rand(0..1)
    if rand == 0
      go = 3 # 右に歩く
      tar = 1  # walkする
      if values[6] == 2
        go = 2 # 下に歩く
        tar = 1  # walkする
        if values[8] == 2
          look = 0 # 上を見る
          tar = 2 # lookする
        end
      end
    else
      go = 2 # 下に歩く
      tar = 1  # walkする
      if values[8] == 2
        go = 3 # 右に歩く
        tar = 1  # walkする
        if values[6] == 2
          look = 0 # 上を見る
          tar = 2  # lookする
        end
      end
    end
    elsif values[3] == 1
      rand = random.rand(0..1)
      if rand == 0
        go = 1 # 左に歩く
        tar = 1  # walkする
        if values[4] == 2
          go = 2 # 下に歩く
          tar = 1 # walkする
          if values[8] == 2
            look = 0 # 上を見る
            tar = 2 # walkする
          end
        end
      else
        go = 2 # 下に歩く
        tar = 1 # walkする
        if values[8] == 2
          go = 1 # 左に歩く
          tar = 1  # walkする
          if values[4] == 2
            look = 0 # 上を見る
            tar = 2  # lookする
          end
        end
      end
    elsif values[7] == 1
      rand = random.rand(0..1)
      if rand == 0
        go = 3 # 右に歩く
        tar = 1  # walkする
        if values[6] == 2
          go = 0 # 上に歩く
          tar = 1 # walkする
          if values[2] == 2
            look = 2 # 下を見る
            tar = 2  # lookする
          end
        end
      else
        go = 0 # 上に歩く
        tar = 1  # walkする
        if values[2] == 2
          go = 3 # 右に歩く
          tar = 1  # walkする
          if values[6] == 2
            look = 2 # 下を見る
            tar = 2  # lookする
          end
        end
      end
    elsif values[9] == 1
      rand = random.rand(0..1)
      if rand == 0
        go = 1 # 左に歩く
        tar = 1  # walkする
        if values[4] == 2
          go = 0 # 上に歩く
          tar = 1  # walkする
          if values[2] == 2
            look = 2 # 下を見る
            tar = 2  # lookする
          end
        end
      else
        go = 0 # 上に歩く
        tar = 1 # walkする
        if values[2] == 2
          go = 1 # 左に歩く
          tar = 1  # walkする
          if values[4] == 2
            look = 2 # 下を見る
            tar = 2  # lookする
          end
        end
      end
  end
# 壁除け
  if go == 0 # 上を向いているとき
    if values[2] == 2
      rand = random.rand(0..1)
      if rand == 0
        go = 1 # 左に歩く
        tar = 1  # walkする
        if values[4] == 2
          go = 3 # 右に歩く
          tar = 1  # walkする
          if values[6] == 2
            go = 2 # 下に歩く
            tar = 1  # walkする
          end
        end
      else
        go = 3 # 右に歩く
        tar = 1 # walkする
        if values[6] == 2
          go = 1 # 左に歩く
          tar = 1 # walkする
          if values[4] == 2
            go = 2 # 下に歩く
            tar = 1  # walkする
          end
        end
      end
    end
    tar = 1  # walkする
  end

  if go == 1 # 左を向いていた時
    if values[4] == 2
      rand = random.rand(0..1)
      if rand == 0
        go = 0 # 上に歩く
        tar = 1 # walkする
        if values[2] == 2
          go = 2 # 下に歩く
          tar = 1 # walkする
          if values[8] == 2
            go = 3 # 右に歩く
            tar = 1 # walkする
          end
        end
      else
        go = 2 # 下に歩く
        tar = 1 # walkする
        if values[8] == 2
          go = 0 # 上に歩く
          tar = 1 # walkする
          if values[2] == 2
            go = 3 # 右に歩く
            tar = 1　 # walkする
          end
        end
      end
    end
    tar = 1　 # walkする
  end

  if go == 2 # 下を向いていた時
    if values[8] == 2
      rand = random.rand(0..1)
      if rand == 0
        go = 1 # 左に歩く
        tar = 1 # walkする
        if values[4] == 2
          go = 3 # 右に歩く
          tar = 1 # walkする
          if values[6] == 2
            go = 0 # 上に歩く
            tar = 1 # walkする
          end
        end
      else
        go = 3 # 右に歩く
        tar = 1 # walkする
        if values[6] == 2
          go = 1 # 左に歩く
          tar = 1  # walkする
          if values[4] == 2
            go = 0 # 上に歩く
            tar = 1 # walkする
          end
        end
      end
    end
    tar = 1 # walkする
  end

  if go == 3 # 右を向いていた時
    if values[6] == 2
      rand = random.rand(0..1)
      if rand == 0
        go = 0 # 上に歩く
        tar = 1 # walkする
        if values[2] == 2
          go = 2 # 下に歩く
          tar = 1  # walkする
          if values[8] == 2
            go = 1 # 左に歩く
            tar = 1  # walkする
          end
        end
      else
        go = 2 # 下に歩く
        tar = 1 # walkする
        if values[8] == 2
          go = 0 # 上に歩く
          tar = 1 # walkする
          if values[2] == 2
            go = 1 # 左に歩く
            tar = 1 # walkする
          end
        end
      end
    end
    tar = 1 # walkする
  end

# アイテムを取りに行く
  if values[2] == 3
    go = 0 # 上に歩く
    tar = 1 # walkする
  elsif values[4] == 3
    go = 1 #　左に歩く
    tar = 1 # walkする
  elsif values[6] == 3
    go = 3 #右に歩く
    tar = 1 # walkする
  elsif values[8] == 3
    go = 2 #下に歩く
    tar = 1 # walkする
  end

# cher
  if values[2] == 1
    put = 0 #上にputする
    tar = 0 # putする
  elsif values[4] == 1
    put = 1 #左にputする
    tar = 0 # putする
  elsif values[6] == 1
    put = 2 #下にputする
    tar = 0 # putする
  elsif values[8] == 1
    put = 3 #右にputする
    tar = 0 # putする
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
