# -*- coding: utf-8 -*-
require 'CHaserConnect.rb'

# サーバに接続
target = CHaserConnect.new("P1") # この名前を4文字までで変更する

# main
values = Array.new(10) # 書き換えない
random = Random.new    # 乱数生成


loop do # 無限ループ
  values = target.getReady

  values = target.walkUp

  if values[0] == 0             # 先頭が0になったら終了
    break
  end
  #----- ここから -----

  #----- ここまで -----
end

target.close # ソケットを閉じる
