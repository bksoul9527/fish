Add-Type -AssemblyName PresentationFramework

# 读取配置文件
$configPath = "config.json"
$config = Get-Content -Path $configPath -Raw | ConvertFrom-Json

# 创建一个窗口
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Transparent Window" Width="$($config.windowWidth)" WindowStyle="None"
        AllowsTransparency="True" Background="Transparent">
    <Grid>
        <StackPanel>
            <TextBlock x:Name="TextBlock" FontSize="$($config.fontSize)" Margin="10"
                       HorizontalAlignment="Center" VerticalAlignment="Center"
                       TextAlignment="Center" Foreground="$($config.textColor)"
                       TextWrapping="Wrap" Opacity="1"/>
        </StackPanel>
    </Grid>
</Window>
"@

# 加载XAML
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

# 文件路径和行索引初始化
$filePath = $config.filePath

try {
    $script:lines = Get-Content -Path $filePath -Encoding UTF8
} catch {
    $script:lines = @()
    $window.FindName("TextBlock").Text = "path error"
}

# 使用配置中的currentIndex
$script:currentIndex = [int]$config.currentIndex
$script:currentPart = 0 # Initialize the current part index

# Function to save the current index to the config file
function Save-CurrentIndex {
    $config.currentIndex = $script:currentIndex
    $config | ConvertTo-Json | Set-Content -Path $configPath -Encoding UTF8
}

# 更新文本显示并调整窗口高度
$script:updateText = {
    if ($script:lines.Count -gt 0) {
        $textBlock = $window.FindName("TextBlock")

        # Ensure currentIndex is within bounds
        if ($script:currentIndex -ge $script:lines.Count) {
            $script:currentIndex = $script:lines.Count - 1
        }

        # Find the next non-empty line
        while ($script:currentIndex -lt $script:lines.Count -and [string]::IsNullOrWhiteSpace($script:lines[$script:currentIndex])) {
            $script:currentIndex++
        }

        if ($script:currentIndex -lt $script:lines.Count) {
            $currentLine = $script:lines[$script:currentIndex]
            $maxLineLength = [int]$config.maxLineLength

            # Split the line into parts if it's too long
            $parts = [System.Text.RegularExpressions.Regex]::Matches($currentLine, ".{1,$maxLineLength}")
            $partCount = $parts.Count

            # Update the text with the current part
            $textBlock.Text = $parts[$script:currentPart].Value

            # Measure the size of the TextBlock content
            $textBlock.Measure([System.Windows.Size]::new($window.Width, [System.Double]::PositiveInfinity))
            $desiredHeight = $textBlock.DesiredSize.Height

            # Set the window height based on the measured size
            $window.Height = [Math]::Max($config.windowHeight, $desiredHeight + 20) # Add some padding

            # Save the current index after updating the text
            Save-CurrentIndex
        } else {
            $textBlock.Text = "not found"
        }
    } else {
        $window.FindName("TextBlock").Text = "not found"
    }
}

# 初始文本更新
$updateText.Invoke()

# 处理键盘事件
$window.Add_KeyDown({
    param($sender, $e)
    switch ($e.Key) {
        # Navigate to the previous part or line
        $config.previousKey {
            if ($script:currentPart -gt 0) {
                $script:currentPart--
                $updateText.Invoke()
            } else {
                # Move to the previous non-empty line
                do {
                    $script:currentIndex--
                } while ($script:currentIndex -ge 0 -and [string]::IsNullOrWhiteSpace($script:lines[$script:currentIndex]))

                if ($script:currentIndex -ge 0) {
                    $script:currentPart = 0
                    $updateText.Invoke()
                }
            }
        }
        # Navigate to the next part or line
        $config.nextKey {
            $currentLine = $script:lines[$script:currentIndex]
            $maxLineLength = [int]$config.maxLineLength
            $parts = [System.Text.RegularExpressions.Regex]::Matches($currentLine, ".{1,$maxLineLength}")

            if ($script:currentPart -lt ($parts.Count - 1)) {
                $script:currentPart++
                $updateText.Invoke()
            } else {
                # Move to the next non-empty line
                do {
                    $script:currentIndex++
                } while ($script:currentIndex -lt $script:lines.Count -and [string]::IsNullOrWhiteSpace($script:lines[$script:currentIndex]))

                if ($script:currentIndex -lt $script:lines.Count) {
                    $script:currentPart = 0
                    $updateText.Invoke()
                }
            }
        }
        # Toggle text opacity
        $config.toggleOpacityKey {
            $textBlock = $window.FindName("TextBlock")
            if ($textBlock.Opacity -eq 1) {
                $textBlock.Opacity = 0
            } else {
                $textBlock.Opacity = 1
            }
        }
        # 退出窗口
        $config.exitKey {
            $window.Close()
        }
    }
})

# 允许窗口拖动
$window.Add_MouseLeftButtonDown({
    $window.DragMove()
})

# 使用Activated事件设置焦点
$window.Add_Activated({
    $window.Focus()
})

# 处理窗口关闭事件以保存当前索引
$window.Add_Closed({
    Save-CurrentIndex
})

# 显示窗口
$window.ShowDialog()