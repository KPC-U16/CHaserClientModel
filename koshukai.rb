# -*- coding: utf-8 -*-
require  'CHaserConnect.rb' #呼び出すおまじない

# 書き換えない
target = CHaserConnect.new("prac") # ()の中好きな名前
values = Array.new(10)

direction = 0

#--------ここから--------
loop do # ここからループ

#---------ここから---------
  values = target.getReady

  if values[0] == 0
    break
  end
#-----ここまで書き換えない-----

#ここに処理を書く
	loop do
		if direction == 0
			if values[2] != 2 
				values = target.walkUp()
				break
			else
				direction = 3
			end
		elsif direction == 3
			if values[6] != 2 
				values = target.walkRight()
				break
			else
				direction = 6
			end
		elsif direction == 6
			if values[8] != 2 
				values = target.walkDown()
				break
			else
				direction = 9
			end
		elsif direction == 9
			if values[4] != 2 
				values = target.walkLeft()
				break
			else
				direction = 0
			end
		end
	end


#前に壁があったら右に曲がろう

#---------ここから---------
  if values[0] == 0
    break
  end

end # ループここまで
target.close
#-----ここまで書き換えない-----