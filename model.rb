# -*- coding: utf-8 -*-
require 'CHaserConnect.rb' #呼び出すおまじない

#　書き換えない
target = CHaserConnect.new("model") # ()の中好きな名前
values = Array.new(10)
random = Random.new # 乱数生成

# ループ前変数
$initPosi = nil # 初期値判定 0=左上 1=左下 2=右下 3=右上
i = 0 # for文
wallCountA = 0 # 壁A測定一回目
itemCountA = 0 # アイテムA測定二回目
wallCountB = 0 # 壁B測定一回目
itemCountB = 0 # アイテムB測定二回目
judgA = 0 # 初期移動方向判定一回目
judgB = 0 # 初期移動方向判定二回目

#ループ内変数
$tar = nil #　Walk,$put,Lookの分岐　0=$put,1=walk,2=$look
$put = nil # $put 0=Up,1=Left,2=Down,3=Right
$look = nil # $look 0=Up,1=Left,2=Down,3=Right
$go = nil # 移動先 0=Up,1=Left,2=Down,3=Right
$tarn = 4 # ターンカウント(初期移動の分の4)

#ここからメソッド定義

def _initialPositionGrasp(values, target) # 初期位置把握
  values = target.getReady
  values = target.searchUp
  if values[9] == 2
	  values = target.getReady
	  values = target.searchLeft
    if values[9] == 2
	 	  $initPosi = 0
	  else
	 	  $initPosi = 3
    end
  else
	  values = target.getReady
	  values = target.searchDown
	  if values[9] == 2
	  	values = target.getReady
	  	values = target.searchRight
	  	if values[9] == 2
	  		$initPosi = 2
	  	else
	  		$initPosi = 1
	  	end
	  end
  end
  print "initposi"
  puts $initPosi
end

def _initialAction(values, target, i,wallCountA, wallCountB, itemCountA ,itemCountB, judgA, judgB) # 初期行動
  if $initPosi == 0 # マップ左上にいた時の行動
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
    	$go = 3
    else
    	$go = 2
    end
  elsif  $initPosi == 1 # マップ左下にいた時の行動
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
    	$go = 3
    else
    	$go = 0
    end
  elsif $initPosi == 2 # マップ右下にいた時の行動
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
    	$go = 1
    else
    	$go = 0
    end
  elsif  $initPosi == 3 # マップ右上にいた時の行動
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
    	$go = 1
    else
    	$go = 2
    end
  end
end

def _obliqueItemGet(values,  random) #斜めのアイテムを取りに行く
 if values[1] == 3
    rand = random.rand(0..1)
    if rand == 0
      $go = 0 # 上に歩く
      $tar = 1 # walkする
      if values[2] == 2
        $go = 1 # 左に歩く
        $tar = 1 # walkする
      end
    else
      $go = 1 # 左に歩く
      $tar = 1 #walkする
      if values[4] == 2
        $go = 0 # 上に歩く
        $tar = 1 # walkする
      end
    end
  elsif values[3] == 3
    rand = random.rand(0..1)
    if rand == 0
      $go = 0 # 上に歩く
      $tar = 1 # walkする
      if values[2] == 2
        $go = 3 # 右に歩く
        $tar = 1 # walkする
      end
    else
      $go = 3 # 右に歩く
      $tar = 1 #walkする
      if values[6] == 2
        $go = 0 # 上に歩く
        $tar = 1 # walkする
      end
    end
    elsif values[7] == 3
    rand = random.rand(0..1)
    if rand == 0
      $go = 1 # 左に歩く
      $tar = 1 # walkする
      if values[4] == 2
        $go = 2 # 下に歩く
        $tar = 1 # walkする
      end
    else
      $go = 2 # 下に歩く
      $tar = 1 # walkする
      if values[8] == 2
        $go = 1 # 左に歩く
        $tar = 1 # walkする
      end
    end
  elsif values[9] == 3
    rand = random.rand(0..1)
    if rand == 0
      $go = 2 # 下に歩く
      $tar = 1 # walkする
      if values[8] == 2
        $go = 3 # 右に歩く
        $tar = 1 # walkする
      end
    else
      $go = 3 # 右に歩く
      $tar = 1  # walkする
      if values[6] == 2
        $go = 2 # 下に歩く
        $tar = 1  # walkする
      end
    end
  end
end

def _itemGet(values) # 隣接するアイテムを取りに行く
  if values[2] == 3
    $go = 0 # 上に歩く
    $tar = 1 # walkする
  elsif values[4] == 3
    $go = 1 #　左に歩く
    $tar = 1 # walkする
  elsif values[6] == 3
    $go = 3 #右に歩く
    $tar = 1 # walkする
  elsif values[8] == 3
    $go = 2 #下に歩く
    $tar = 1 # walkする
  end
end

def _obliqueEnemy(values, random) #斜めに敵がいた時の行動
  if values[1] == 1
    rand = random.rand(0..1)
    if rand == 0
      $go = 3 # 右に歩く
      $tar = 1  # walkする
      if values[6] == 2
        $go = 2 # 下に歩く
        $tar = 1  # walkする
        if values[8] == 2
          $look = 0 # 上を見る
          $tar = 2 # lookする
        end
      end
    else
      $go = 2 # 下に歩く
      $tar = 1  # walkする
      if values[8] == 2
        $go = 3 # 右に歩く
        $tar = 1  # walkする
        if values[6] == 2
          $look = 0 # 上を見る
          $tar = 2  # lookする
        end
      end
    end
    elsif values[3] == 1
      rand = random.rand(0..1)
      if rand == 0
        $go = 1 # 左に歩く
        $tar = 1  # walkする
        if values[4] == 2
          $go = 2 # 下に歩く
          $tar = 1 # walkする
          if values[8] == 2
            $look = 0 # 上を見る
            $tar = 2 # walkする
          end
        end
      else
        $go = 2 # 下に歩く
        $tar = 1 # walkする
        if values[8] == 2
          $go = 1 # 左に歩く
          $tar = 1  # walkする
          if values[4] == 2
            $look = 0 # 上を見る
            $tar = 2  # lookする
          end
        end
      end
    elsif values[7] == 1
      rand = random.rand(0..1)
      if rand == 0
        $go = 3 # 右に歩く
        $tar = 1  # walkする
        if values[6] == 2
          $go = 0 # 上に歩く
          $tar = 1 # walkする
          if values[2] == 2
            $look = 2 # 下を見る
            $tar = 2  # lookする
          end
        end
      else
        $go = 0 # 上に歩く
        $tar = 1  # walkする
        if values[2] == 2
          $go = 3 # 右に歩く
          $tar = 1  # walkする
          if values[6] == 2
            $look = 2 # 下を見る
            $tar = 2  # lookする
          end
        end
      end
    elsif values[9] == 1
      rand = random.rand(0..1)
      if rand == 0
        $go = 1 # 左に歩く
        $tar = 1  # walkする
        if values[4] == 2
          $go = 0 # 上に歩く
          $tar = 1  # walkする
          if values[2] == 2
            $look = 2 # 下を見る
            $tar = 2  # lookする
          end
        end
      else
        $go = 0 # 上に歩く
        $tar = 1 # walkする
        if values[2] == 2
          $go = 1 # 左に歩く
          $tar = 1  # walkする
          if values[4] == 2
            $look = 2 # 下を見る
            $tar = 2  # lookする
          end
        end
      end
  end
end

def _enemy(values) # 隣接した敵に攻撃する
  if values[2] == 1
    $put = 0 #上にputする
    $tar = 0 # putする
  elsif values[4] == 1
    $put = 1 #左にputする
    $tar = 0 # putする
  elsif values[6] == 1
    $put = 3 #右にputする
    $tar = 0 # putする
  elsif values[8] == 1
    $put = 2 #下にputする
    $tar = 0 # putする
  end
end

def _avoidBlock(values, random) # 壁にめり込まない
  if $go == 0 # 上を向いているとき
    if values[2] == 2
      rand = random.rand(0..1)
      if rand == 0
        $go = 1 # 左に歩く
        $tar = 1  # walkする
        if values[4] == 2
          $go = 3 # 右に歩く
          $tar = 1  # walkする
          if values[6] == 2
            $go = 2 # 下に歩く
            $tar = 1  # walkする
          end
        end
      else
        $go = 3 # 右に歩く
        $tar = 1 # walkする
        if values[6] == 2
          $go = 1 # 左に歩く
          $tar = 1 # walkする
          if values[4] == 2
            $go = 2 # 下に歩く
            $tar = 1  # walkする
          end
        end
      end
    end
    $tar = 1  # walkする
  end

  if $go == 1 # 左を向いていた時
    if values[4] == 2
      rand = random.rand(0..1)
      if rand == 0
        $go = 0 # 上に歩く
        $tar = 1 # walkする
        if values[2] == 2
          $go = 2 # 下に歩く
          $tar = 1 # walkする
          if values[8] == 2
            $go = 3 # 右に歩く
            $tar = 1 # walkする
          end
        end
      else
        $go = 2 # 下に歩く
        $tar = 1 # walkする
        if values[8] == 2
          $go = 0 # 上に歩く
          $tar = 1 # walkする
          if values[2] == 2
            $go = 3 # 右に歩く
            $tar = 1 # walkする
          end
        end
      end
    end
    $tar = 1 # walkする
  end

  if $go == 2 # 下を向いていた時
    if values[8] == 2
      rand = random.rand(0..1)
      if rand == 0
        $go = 1 # 左に歩く
        $tar = 1 # walkする
        if values[4] == 2
          $go = 3 # 右に歩く
          $tar = 1 # walkする
          if values[6] == 2
            $go = 0 # 上に歩く
            $tar = 1 # walkする
          end
        end
      else
        $go = 3 # 右に歩く
        $tar = 1 # walkする
        if values[6] == 2
          $go = 1 # 左に歩く
          $tar = 1  # walkする
          if values[4] == 2
            $go = 0 # 上に歩く
            $tar = 1 # walkする
          end
        end
      end
    end
    $tar = 1 # walkする
  end

  if $go == 3 # 右を向いていた時
    if values[6] == 2
      rand = random.rand(0..1)
      if rand == 0
        $go = 0 # 上に歩く
        $tar = 1 # walkする
        if values[2] == 2
          $go = 2 # 下に歩く
          $tar = 1  # walkする
          if values[8] == 2
            $go = 1 # 左に歩く
            $tar = 1  # walkする
          end
        end
      else
        $go = 2 # 下に歩く
        $tar = 1 # walkする
        if values[8] == 2
          $go = 0 # 上に歩く
          $tar = 1 # walkする
          if values[2] == 2
            $go = 1 # 左に歩く
            $tar = 1 # walkする
          end
        end
      end
    end
    $tar = 1 # walkする
  end
end

def _act(values, target) # 行動する
  puts $tar
  puts $put
  puts $look
  puts $go
  case $tar
    when 0
      case $put
        when 0
          values = target.putUp
          $tarn += 1
        when 1
          values = target.putLeft
          $tarn += 1
        when 2
          values =  target.putDown
          $tarn += 1
        when 3
          values =  target.putRight
          $tarn += 1
      end
    when 1
      case $go
        when 0
          values = target.walkUp
          $tarn += 1
        when 1
          values = target.walkLeft
          $tarn += 1
        when 2
          values =  target.walkDown
          $tarn += 1
        when 3
          values =  target.walkRight
          $tarn += 1
      end
    when 2
      case $look
      when 0
        values = target.lookUp
        $tarn += 
      when 1
        values = target.lookLeft
        $tarn += 1
      when 2
        values =  target.lookDown
        $tarn += 1
      when 3
        values =  target.lookRight
        $tarn += 1
      end
  end
end

# ここから実行するメソッドを書いていく

_initialPositionGrasp(values, target) # 初期位置把握

_initialAction(values, target, i, wallCountA, wallCountB, itemCountA ,itemCountB, judgA, judgB) # 初期行動

loop do # ここからループ

#---------ここから---------
  values = target.getReady

  if values[0] == 0
    brea
  end
#-----ここまで書き換えない-----

_obliqueItemGet(values, random) #斜めのアイテムを取りに行く

_obliqueEnemy(values, random) #斜めに敵がいたときの行動

_avoidBlock(values, random) # 壁にめり込まない

_itemGet(values) # 隣接するアイテムを取りに行く

_enemy(values) # 隣接する敵に攻撃を仕掛ける

_act(values, target) #行動する

#---------ここから---------
  if values[0] == 0
    break
  end

end # ループここまで
target.close
#-----ここまで書き換えない-----
