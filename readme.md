第六章：組譯器（Assembler）

在第六章中，目標是使用高階語言（如 Python、Java 或 C++）實作一個 Hack 組譯器，將人類可讀的 Hack 組合語言（.asm）轉換為 Hack 電腦能直接執行的 16 位元機器碼（.hack）。
由於前五章已完成 Hack 電腦的硬體設計，但硬體只能理解 0 與 1，因此本章的核心任務，就是在軟體層建立「程式語言」與「硬體指令」之間的轉換橋樑。

此組譯器需支援三種語法：

A 指令（如 @21、@i）

C 指令（dest=comp;jump）

標籤（Label）（如 (LOOP)）

實作上採用 兩遍掃描（two-pass assembler）：

第一遍：掃描整個程式，記錄所有標籤對應的 ROM 位址。

第二遍：將每一行指令實際翻譯成二進位機器碼，並同時處理符號查表與變數配置（從 RAM 位址 16 開始）。

完成本章後，可以清楚理解 CPU 指令如何被編碼、符號表在程式轉換中的角色，以及組譯器在整體電腦系統中的關鍵位置，這也為後續 VM 與編譯器章節奠定基礎。

第七章：虛擬機（Virtual Machine）
VM 的角色：中介層

在 Nand2Tetris 的設計中，若直接將高階語言（如 Jack）編譯成機器碼，實作難度極高，因此引入了 虛擬機（VM Layer） 作為中介層：

Jack 程式先被編譯成 VM 指令（.vm）

VM Translator 將 VM 指令轉成 Hack Assembly

再由第六章的組譯器轉成機器碼

這樣的設計類似 Java 的 Bytecode 或 .NET 的中介語言，使整個編譯流程模組化、可維護且易於實作。

堆疊式運算模型（Stack-based Computing）

VM 採用 堆疊架構，所有運算皆透過堆疊完成：

算術指令（如 add）：從堆疊頂端取出兩個值，相加後再壓回

比較指令（eq, gt, lt）：結果為真時推入 -1，否則推入 0

本章需實作 9 個基本算術與邏輯指令：
add, sub, neg, eq, gt, lt, and, or, not

記憶體區段（Memory Segments）

VM 抽象出多個記憶體區段來管理變數：

local, argument, this, that：對應 RAM 中不同區域

pointer, temp：固定位置暫存區

static：靜態變數

constant：僅用於產生數值，不實際佔用記憶體

你需要將像 push argument 0 這樣的 VM 指令，翻譯成一連串 Hack Assembly 的暫存器與記憶體操作，這也是本章最具挑戰性的部分。

第八章：流程控制與函式呼叫
流程控制（Program Flow）

本章首先實作三個流程控制指令：

label

goto

if-goto

這些會被轉換成 Hack Assembly 中的標籤與跳躍指令（如 JMP, JNE）。

函式呼叫與堆疊幀（Function Stack Frame）

當執行 call FunctionName nArgs 時，必須在堆疊中建立一個完整的 堆疊框架（Frame），以確保函式結束後能正確返回。堆疊中需保存：

返回位址（Return Address）

呼叫者的 LCL, ARG, THIS, THAT

新函式的 LCL 會指向這個新框架的起點。

函式返回（Return）

return 是本章最困難的部分，需完成：

將回傳值放回 ARG[0]

還原呼叫者的暫存器狀態

跳回先前保存的返回位址

啟動程式（Bootstrap Code）

VM Translator 必須自動產生啟動碼：

初始化 SP = 256

呼叫 Sys.init()，作為整個系統的進入點

第九章：Jack 高階語言實作

第九章是首次真正使用整套系統來執行 高階語言程式。
你會用 Jack 撰寫完整應用（如 Square），並透過 OS 提供的 Screen、Keyboard 等類別進行互動，而不需關心底層 CPU 或 VM 的實作細節。

重點不在程式功能多複雜，而是確認你理解：

Jack 的語法結構

物件、方法、條件與迴圈
這也是後續撰寫編譯器的重要準備。

第十章：編譯器前半段（語法分析）

本章負責實作 Jack 編譯器的前端：

將 Jack 程式切分成 Token（關鍵字、符號、識別字、常數）

依照語法規則組成語法結構（Parse Tree / XML）

驗證程式語法是否正確

此階段尚未產生 VM code，重點是讓電腦「理解 Jack 程式在寫什麼」。

第十一章：完整編譯器（Jack → VM）

第十一章將編譯器升級為完整版本，除了語法分析，還要：

將 Jack 程式翻譯成對應的 VM 指令

處理變數配置、運算、流程控制、函式呼叫與返回

確保邏輯正確，並正確使用 local, argument, static, this 等段

最終產生的 VM 程式，能透過 VM Translator 與組譯器，在 Hack CPU 上實際執行。

第十二章：作業系統（Operating System）

第十二章的目標是為 Hack 電腦撰寫一套 作業系統（OS），將常用功能封裝成 Jack 類別，讓應用程式不需直接操作底層硬體。

需實作的核心模組包含：

Math：乘法、除法、平方根（常用二分搜尋）

Memory：動態配置與回收記憶體（Free List）

Screen：直接操作記憶體映射區，實作畫線、畫圓

Output：字元顯示、游標控制與捲動

String / Array：字串與陣列操作

Keyboard：鍵盤輸入處理

Sys：系統啟動、延遲與結束控制

完成本章後，你將真正擁有一台「從 NAND Gate 到作業系統」全自製的電腦。