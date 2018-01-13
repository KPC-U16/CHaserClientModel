# -*- coding: utf-8 -*-
require 'CHaserConnect.rb' #呼び出すおまじない

#　書き換えない
target = CHaserConnect.new("model") # ()の中好きな名前(最大全角四文字)
values = Array.new(10)              # [0]にシステムの割り込み変数が入る [1]~[9]
random = Random.new                 # 乱数生成

# ループ前変数
# 各メソッドで使用する変数(テスト中に追加されたやつ)
$initPosi = nil   # 初期位置を把握する(0=左上, 1=左下, 2=左右下, 3=右上)
$direction = nil  # キャラクタの進行方向を決める（向きは時計の数字に合わせる)


#ループ内変数
$tar = nil #　Walk,$put,Lookの分岐　0=$put,1=walk,2=$look
$put = nil # $put 0=Up,1=Left,2=Down,3=Right
$look = nil # $look 0=Up,1=Left,2=Down,3=Right
$go = nil # 移動先 0=Up,1=Left,2=Down,3=Right
$tarn = 4 # ターンカウント(初期移動の分の4)

#ここからメソッド定義
def _initialPositionGrasp values, target  # 初期位置把握
  upvalue = nil
  leftvalue = nil

  # 1ターン目
  values = target.getReady
  upvalue = target.searchUp

  # 2ターン目
  values = target.getReady
  leftvalue = target.searchLeft

  if upvalue[9] == 2 && leftvalue[9] == 2 then
    # 上と左に壁があった時
    $initPosi = 0 # 自分は左上にいる
  elsif upvalue[9] != 2 && leftvalue[9] == 2 then
    # 上に壁はないけど左に壁があった時
    $initPosi = 1 # 自分は左下にいる
  elsif upvalue[9] != 2 && leftvalue[9] != 2 then
    # 上と左に壁がなかった時
    $initPosi = 2 # 自分は右下にいる
  elsif upvalue[9] == 2 && leftvalue[9] != 2 then
    # 上に壁はあるけど左に壁がなかった時
    $initPosi = 3 # 自分は右上にいる
  else
    # なんかよくわかんない時
    $initPosi = random.rand(0..3) # 何処かにいるんじゃない？(本当はエラー対処すべき)
  end

  print "initPosi = "
  puts $initPosi
end

def _initialAction values, target
  valuesUD = nil
  valuesLR = nil
  wallCountUD = nil
  wallCountLR = nil
  itemCountUD = nil
  itemCountLR = nil
  scoreUD = nil
  scoreLR = nil

  # 3ターン目
  values = target.getReady
  if $initPosi == 0 || $initPosi == 3 then
    # マップの上側にいる時
    valuesUD = target.lookDown
  elsif $initPosi == 1 || $initPosi == 2 then
    # マップの下側にいる時
    valuesUD = target.lookUp
  end
  for i in 1..9 do
    if valuesUD[i] == 2
      wallCountUD += 1
    elsif valuesUD[i] == 3
      itemCountUD += 1
    end
  end

  # 4ターン目
  values = target.getReady
  if $initPosi == 0 || $initPosi == 1 then
    # マップの左側にいる時
    valuesLR = target.lookRight
  elsif $initPosi == 2 || $initPosi == 3 then
    # マップの右側にいる時
    valuesLR = target.lookLeft
  end
  for i in 1..9 do
    if valuesLR[i] == 2
      wallCountLR += 1
    elsif valuesLR[i] == 3
      itemCountLR += 1
    end
  end

  wallCountUD - itemCountUD = scoreUD
  wallCountLR - itemCountLR = scoreLR
  if scoreUD <= scoreLR
    # 上下のスコアが左右のスコア以下の時(上下方向に進む)
    if $initPosi == 0 || $initPosi == 3
      # マップの上側にいる時
      $direction = 6 # 6時の方向
    elsif $initPosi == 1 || $initPosi == 2
      # マップの下側にいる時
      $direction = 0 # 0時の方向
    end
  elsif scoreUD > scoreLR
    # 上下のスコアが左右のスコアより大きい時(左右方向に進む)
    if $initPosi == 0 || $initPosi == 1
      # マップの左側にいる時
      $direction = 3 # 3時の方向
    elsif $initPosi == 2 || $initPosi == 3
      # マップの右側にいる時
      $direction = 9 # 9時の方向
    end
  else
    # なんかよくわかんない時
    $direction = random.rand(0..3) * 3 # 何処かに向かうんじゃない？(本当はエラーry)
  end
  
  print "direction = "
  puts $direction
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
          puts "1"
        when 1
          values = target.putLeft
          $tarn += 1
          puts "2"
        when 2
          values =  target.putDown
          $tarn += 1
          puts "3"
        when 3
          values =  target.putRight
          $tarn += 1
          puts "4"
      end
    when 1
      case $go
        when 0
          values = target.walkUp
          $tarn += 1
          puts "5"
        when 1
          values = target.walkLeft
          $tarn += 1
          puts "6"
        when 2
          values =  target.walkDown
          $tarn += 1
          puts "7"
        when 3
          values =  target.walkRight
          $tarn += 1
          puts "8"
      end
    when 2
      case $look
      when 0
        values = target.lookUp
        $tarn += 1
        puts "9"
      when 1
        values = target.lookLeft
        $tarn += 1
        puts "1-0"
      when 2
        values =  target.lookDown
        $tarn += 1
        puts "1-1"
      when 3
        values =  target.lookRight
        $tarn += 1
        puts "1-2"
      end
      puts "1-3"
  end
  puts "1-4"
end

# ここから実行するメソッドを書いていく

_initialPositionGrasp(values, target) # 初期位置把握

_initialAction(values, target, i, wallCountA, wallCountB, itemCountA ,itemCountB, judgA, judgB) # 初期行動

loop do # ここからループ

#---------ここから---------
  values = target.getReady
  print "aaa"
  if values[0] == 0
    break
  end
#-----ここまで書き換えない-----

_obliqueItemGet(values, random) #斜めのアイテムを取りに行く
print "bb"
_obliqueEnemy(values, random) #斜めに敵がいたときの行動
print"avb"
_avoidBlock(values, random) # 壁にめり込まない
print "ig"
_itemGet(values) # 隣接するアイテムを取りに行く
print "ene"
_enemy(values) # 隣接する敵に攻撃を仕掛ける
print "act"
_act(values, target) #行動する
print "fin"
#---------ここから---------
  if values[0] == 0
    break
  end

end # ループここまで
target.close
#-----ここまで書き換えない-----
