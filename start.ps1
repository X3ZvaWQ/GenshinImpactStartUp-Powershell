Add-Type -AssemblyName 'System.Windows.Forms'

# ��������
$browserPath = "msedge"
$url = "https://geshin.x3zvawq.xyz/"

# �ж�һ����������Ƿ��ǰ�ɫ����ֵ
$BrightnessThreshold = 0.8  # 80%
# �ж��ٱ��������ص����ȴ�����ֵʱ������!
$brightnessPercentage = 0.9 # 90%
# ÿ�μ����Ļ�������ص�����
$SampleSize = 1000
# ��������룩
$Interval = 1

$primaryScreen = [System.Windows.Forms.Screen]::PrimaryScreen
$screenWidth = $primaryScreen.Bounds.Width
$screenHeight = $primaryScreen.Bounds.Height

function Start-YuanShen {
    Write-Host "ԭ��������"
    Start-Process -FilePath $browserPath -ArgumentList "--kiosk $url", "--edge-kiosk-type=fullscreen" -WindowStyle Maximized
}
# �����Ļ����
function CheckScreenBrightness {
    # ��ͼ
    $bmp = New-Object Drawing.Bitmap $screenWidth, $screenHeight
    $graphics = [System.Drawing.Graphics]::FromImage($bmp)
    $rect = [System.Drawing.Rectangle]::FromLTRB(0, 0, $screenWidth, $screenHeight)
    $graphics.CopyFromScreen($rect.Location, [System.Drawing.Point]::Empty, $rect.Size)
    $bmp.Save("screenshot.png", [System.Drawing.Imaging.ImageFormat]::Png)

    $totalPixels = 0
    $brightPixels = 0
    for ($i = 0; $i -lt $SampleSize; $i++) {
        $x = Get-Random -Minimum 0 -Maximum $screenWidth
        $y = Get-Random -Minimum 0 -Maximum $screenHeight
        $color = $bmp.GetPixel($x, $y)

        $brightness = ($color.R + $color.G + $color.B) / (3 * 255)
        $totalPixels++

        if ($brightness -gt $BrightnessThreshold) {
            $brightPixels++
        }
    }

    $brightnessPercentage = $brightPixels / $totalPixels
    $graphics.Dispose()
    $bmp.Dispose()
    Write-Host "brightnessPercentage:" $brightnessPercentage
    return $brightnessPercentage
}

while ($true) {
    $brightnessPercentage = CheckScreenBrightness

    if ($brightnessPercentage -gt 0.9) {
        Start-YuanShen
        break
    }
    Start-Sleep -Seconds $Interval
}