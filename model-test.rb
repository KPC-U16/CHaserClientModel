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

def _unJudgementDirection
  return random.rand(0..3)*3
end


def _PrepareAutomatically values
  values = target.getReady
end


def _initialPositionGrasp values, target  # 初期位置把握
  upvalue = nil
  leftvalue = nil

  # 1ターン目
  _PrepareAutomatically(values)
  upvalue = target.searchUp

  # 2ターン目
  _PrepareAutomatically(values)
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
  valuesUD = 0
  valuesLR = 0
  wallCountUD = 0
  wallCountLR = 0
  itemCountUD = 0
  itemCountLR = 0
  scoreUD = 0
  scoreLR = 0

  # 3ターン目
  _PrepareAutomatically(values)
  if $initPosi == 0 || $initPosi == 3 then
    # マップの上側にいる時
    valuesUD = target.lookDown
  elsif $initPosi == 1 || $initPosi == 2 then
    # マップの下側にいる時
    valuesUD = target.lookUp
  end
  values.each{ |i| do
    if valuesUD[i] == 2
      wallCountUD += 1
    elsif valuesUD[i] == 3
      itemCountUD += 1
    end
  }

  # 4ターン目
  _PrepareAutomatically(values)
  if $initPosi == 0 || $initPosi == 1 then
    # マップの左側にいる時
    valuesLR = target.lookRight
  elsif $initPosi == 2 || $initPosi == 3 then
    # マップの右側にいる時
    valuesLR = target.lookLeft
  end
  values.each{ |i| do
    if valuesLR[i] == 2
      wallCountLR += 1
    elsif valuesLR[i] == 3
      itemCountLR += 1
    end
  }

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
    $direction = _unJudgementDirection # 何処かに向かうんじゃない？(本当はエラーry)
  end

  print "direction = "
  puts $direction
end


def _obliqueItemGet values  # 斜めのアイテムに隣接しに行く
  preactflg = $actflg
  $actflg = 0 # walkフラグを立てる

  if values[1] == 3 # 左上にアイテムがある時
    if values[2] == 0 && values[4] == 0 then    # 上も左も進める時
      rand = random.rand(0..1)
      if rand == 0
        $direction = 0  # 0時方向に進む
      else
        $direction = 9  # 9時方向に進む
      end
    elsif values[2] != 0 && values[4] == 0 then # 左にしか進めない時
      $direction = 9    # 9時方向に進む
    elsif values[2] == 0 && values[4] != 0 then # 上にしか進めない時
      $direction = 0    # 0時方向に進む
    elsif values[2] != 0 && values[4] != 0 then # 左も上も進めない時
      # 来てない方向へ進む
      if $direction ==0     # 上を目指していたので
        $direction = 3      # 右に進む
      elsif $direction ==9  # 左を目指していたので
        $direction = 6      # 下に進む
      else
        #なんかよくわかんない時
        $direction = _unJudgementDirection # 何処かに向かうんじゃない？(本当はエラーry)
      end
    end
  end

  if values[3] == 3 # 右上にアイテムがある時
    if values[2] == 0 && values[6] == 0 then    # 上も右も進める時
      rand = random.rand(0..1)
      if rand == 0
        $direction = 0  # 0時方向に進む
      else
        $direction = 3  # 3時方向に進む
      end
    elsif values[2] != 0 && values[6] == 0 then # 右にしか進めない時
      $direction = 3    # 3時方向に進む
    elsif values[2] == 0 && values[6] != 0 then # 上にしか進めない時
      $direction = 0    # 0時方向に進む
    elsif values[2] != 0 && values[6] != 0 then # 右も上も進めない時
      # 来てない方向へ進む
      if $direction ==0     # 上を目指していたので
        $direction = 9      # 左へ進む
      elsif $direction ==3  # 右を目指していたので
        $direction = 6      # 下へ進む
      else
        #なんかよくわかんない時
        $direction = _unJudgementDirection # 何処かに向かうんじゃない？(本当はエラーry)
      end
    end
  end

  if values[7] == 3 # 左下にアイテムがある時
    if values[4] == 0 && values[8] == 0 then    # 左も下も進める時
      rand = random.rand(0..1)
      if rand == 0
        $direction = 6  # 6時方向に進む
      else
        $direction = 9  # 9時方向に進む
      end
    elsif values[4] != 0 && values[8] == 0 then # 下にしか進めない時
      $direction = 6    # 6時方向に進む
    elsif values[4] == 0 && values[8] != 0 then # 左にしか進めない時
      $direction = 9    # 9時方向に進む
    elsif values[4] != 0 && values[8] != 0 then # 右も上も進めない時
      # 来てない方向へ進む
      if $direction ==6     # 下を目指していたので
        $direction = 3      # 右へ進む
      elsif $direction ==9  # 左を目指していたので
        $direction = 0      # 上へ進む
      else
        #なんかよくわかんない時
        $direction = _unJudgementDirection # 何処かに向かうんじゃない？(本当はエラーry)
      end
    end
  end

  if values[9] == 3 # 右下にアイテムがある時
    if values[6] == 0 && values[8] == 0 then    # 右も下も進める時
      rand = random.rand(0..1)
      if rand == 0
        $direction = 6  # 6時方向に進む
      else
        $direction = 3  # 3時方向に進む
      end
    elsif values[6] != 0 && values[8] == 0 then # 下にしか進めない時
      $direction = 6    # 6時方向に進む
    elsif values[6] == 0 && values[8] != 0 then # 右にしか進めない時
      $direction = 3    # 9時方向に進む
    elsif values[6] != 0 && values[8] != 0 then # 右も下も進めない時
      # 来てない方向へ進む
      if $direction ==3     # 右を目指していたので
        $direction = 0      # 上へ進む
      elsif $direction ==6  # 下を目指していたので
        $direction = 9      # 左へ進む
      else
        #なんかよくわかんない時
        $direction = _unJudgementDirection # 何処かに向かうんじゃない？(本当はエラーry)
      end
    end
  else
  end
end

def _itemGet values # 隣接するアイテムを取りに行く(要再構築)
  preactflg = $actflg
  $actflg = 0
  if values[2] == 3 then
    $direction = 0
  elsif values[4] == 3 then
    $direction = 9
  elsif values[6] == 3 then
    $direction = 3
  elsif values[8] == 3 then
    $direction = 6
  else
    $actflg = preactflg # フラグを戻しておく
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

def _enemy values  # 隣接した敵を壁で埋める
  preactflg = $actflg
  $actflg = 2 # フラグをputにする
  if values[2] == 1
    $direction = 0
  elsif values[4] == 1
    $direction = 9
  elsif values[6] == 1
    $direction = 3
  elsif values[8] == 1
    $direction = 6
  else
    $actflg = preactflg # フラグを戻しておく
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

def _action values
  case $actflg
  when 0 # walk
    case $direction
    when 0
      values = target.walkUp
    when 3
      values = target.walkRight
    when 6
      values = target.walkDown
    when 9
      values = target.walkLeft
    end
  when 1 # look
    case $direction
    when 0
      values = target.lookUp
    when 3
      values = target.lookRight
    when 6
      values = target.lookDown
    when 9
      values = target.lookLeft
    end
  when 2 # put
    case $direction
    when 0
      values = target.putUp
    when 3
      values = target.putRight
    when 6
      values = target.putDown
    when 9
      values = target.putLeft
    end
  when 3 # search
    case $direction
    when 0
      values = target.searchUp
    when 3
      values = target.searchRight
    when 6
      values = target.searchDown
    when 9
      values = target.searchLeft
    end
  end
end


# ここから実行するメソッドを書いていく

_initialPositionGrasp(values, target) # 初期位置把握

_initialAction(values, target) # 初期行動

loop do # ここからループ

#---------ここから---------
  _PrepareAutomatically(values)

  if values[0] == 0
    break
  end
#-----ここまで書き換えない-----

_obliqueItemGet(values) #斜めのアイテムを取りに行く

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