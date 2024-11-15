本项目是基于windows的powershell写的上班摸鱼看书工具

### 运行：
点击run.bat

### 文本：
文本只支持UTF8类型的，其他类型可能会乱码。
如果你不会转码，可以先创建一个txt文件，然后把你要看的文本复制进去。

如果重新换了一本书，要把config.json文件里的currentIndex参数设置为0，才会从第一页开始阅读。


### config.json 配置说明：

~~~
{
    "windowWidth": 400,          // 窗口的宽度，单位为像素
    "windowHeight": 60,         // 窗口的最小高度，单位为像素
    "fontSize": 20,              // 文本的字体大小
    "textColor": "Black",        // 文本的颜色，可以使用颜色名称或十六进制值（例如 "#FFFFFF" 表示白色）
    "filePath": "text.txt",      // 要显示内容的文本文件路径
    "currentIndex": 0,           // 当前显示的行索引
    "maxLineLength": 100,         // 每行的最大字符数，用于分割长行
    "previousKey": "Left",       // 用于导航到上一个部分或行的键，例如 "Left" 表示左箭头键
    "nextKey": "Right",          // 用于导航到下一个部分或行的键，例如 "Right" 表示右箭头键
    "toggleOpacityKey": "Up",     // 用于切换文本不透明度的键，例如 "Up" 表示字母 Up 键
    "exitKey": "Escape"          // 用于关闭窗口的键，例如 "Escape" 表示 Esc 键
}
~~~ 


### 配置说明：
+ windowWidth 和 windowHeight: 定义窗口的初始尺寸。windowHeight 是窗口的最小高度，具体高度会根据文本内容自动调整。
+ fontSize: 定义显示文本的字体大小。
+ textColor: 设置文本的颜色，可以使用常见的颜色名称（如 "Black", "Red"）或使用十六进制颜色代码。
+ filePath: 指定要读取的文本文件的路径，确保文件存在且路径正确。
+ currentIndex: 指定从哪个行索引开始显示文本，程序会从配置文件中读取并在关闭时更新该值。
+ maxLineLength: 设置每行的最大字符数，如果一行文本超过该长度，将其分割为多个部分显示。
+ previousKey 和 nextKey: 指定用于在文本部分或行之间导航的键。可以使用键的名称，如 "Left", "Right", "Up", "Down" 等。
+ toggleOpacityKey: 指定用于切换文本不透明度的键。按下该键时，文本将从完全可见切换到不可见或反之。
+ exitKey: 指定用于关闭窗口的键。
