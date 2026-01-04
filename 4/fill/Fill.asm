// 監聽鍵盤，按下按鍵時填滿螢幕，放開時清空螢幕

(RESTART)
    @SCREEN
    D=A
    @address
    M=D         // address = SCREEN (16384)

(KBDCHECK)
    @KBD
    D=M         // 讀取鍵盤輸入值值
    @BLACKEN
    D;JGT       // 如果鍵盤值 > 0 (有按鍵)，跳轉至塗黑邏輯

(WHITEN)
    D=0         // 白色對應數值 0
    @FILL
    0;JMP

(BLACKEN)
    D=-1        // 黑色對應數值 -1 (二進位全為 1)

(FILL)
    @value
    M=D         // 儲存目前要填入的顏色 (0 或 -1)

(FILL_LOOP)
    @value
    D=M
    @address
    A=M
    M=D         // 將顏色寫入目前的記憶體地址

    @address
    M=M+1       // address = address + 1
    D=M

    @24576      // 螢幕記憶體映射的上限 (KBD 的起始位置)
    D=A-D
    @FILL_LOOP
    D;JGT       // 如果還沒填完所有像素，繼續循環

    @RESTART
    0;JMP       // 回到開頭重新監聽鍵盤