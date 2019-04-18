# -*- coding: utf-8 -*-
require 'CHaserConnect.rb'

# サーバに接続
target = CHaserConnect.new("P1") # この名前を4文字までで変更する

# main
values = Array.new(10) # 書き換えない
random = Random.new    # 乱数生成

def Direction(target, values, random)
	direction = 0
	# ランダムウォーク
	loop do
		direction = random.rand(0..3)

		if !isWall(direction, values)
			break
		end
	end


  	case direction
  		when 0 # 0 = 上
			values = target.walkUp
  		when 1 # 1 = 右
  			values = target.walkRight
	  	when 2 # 2 = ↓
	  		values = target.walkDown
	  	when 3
	  		values = target.walkLeft
  	end
end

def isWall(direction, values)
	case direction
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
	  	when 2 # 2 = ↓
			if values[8] == 2
				ans = true
			else
				ans = false
			end
	  	when 3
	  		if values[4] == 2
				ans = true
			else
				ans = false
			end
  	end
  	return ans
end



loop do # 無限ループ
  values = target.getReady

  Direction(target, values, random)

  if values[0] == 0             # 先頭が0になったら終了
    break
  end
  #----- ここから -----

  #----- ここまで -----
end

target.close # ソケットを閉じる
