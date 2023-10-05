# 行動を数字にまとめる列挙型(order関数用)
module Action
    
    WALK = 0
    LOOK = 1
    SEARCH = 2
    PUT = 3
    
end 


# 行動方向とその処理をまとめる列挙型(order関数用)
module Direction

    UP = 2
    LEFT = 4
    RIGHT = 6
    DOWN = 8
    
    def Reverse(x)
        return 10 - x
    end
    
    module_function :Reverse
end

# サーバから取得できる情報をまとめる列挙型
module MapInfo

    FLOOR = 0
    ENEMY = 1
    BLOCK = 2
    ITEM = 3

end
