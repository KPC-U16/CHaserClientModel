# -*- coding: utf-8 -*-
# Test用プログラム 周りを調べながら行動する

require 'CHaserConnect.rb' # CHaserConnect.rbを読み込む Windows

def _put(up, left, right, down)
  if up == 1
    target.putUp
  elsif left == 1
    target.putLeft
  elsif right == 1
    target.putRight
  elsif down == 1
    target.putDown
  end
end


def _escape(up, left, right, down, turn)
  if (up + left + right + down) == 9
    if up != 2
      target.walkUp
    elsif left != 2
      target.walkLeft
    elsif right != 2
      target.walkRight
    elsif down != 2
      target.walkDown
    end
    turn -= 1
  end
end


def _search(turn)
  case turn % 4
  when 0
    target.searchUp
  when 1
    target.searchLeft
  when 2
    target.searchRight
  when 3
    target.searchDown
  end


# サーバに接続
target = CHaserConnect.new("ONI") # この名前を4文字までで変更する

values = Array.new(10) # 書き換えない
mode = 1
turn = 0

# 優勢攻撃作戦(とにかくput負けしない)
# 一回目の勝負で「アイテム数で負けつつput勝ち」を達成できた時の二回目のプログラム（2017年ルール上）


loop do
  values = target.getReady
  turn += 1

  # 隣接したらput勝ちする
  _put(values[2], values[4], values[6], values[8])

  # 3方向を壁に囲まれていると生き埋めになりかねないので脱出する
  _escape(values[2], values[4], values[6], values[8], turn)

  # 基本は動かない


end

target.close
