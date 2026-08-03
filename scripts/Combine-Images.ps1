param (
    [Parameter(Mandatory=$true)]
    [string]$Image1Path,
    
    [Parameter(Mandatory=$true)]
    [string]$Image2Path,
    
    [Parameter(Mandatory=$true)]
    [string]$OutputPath
)

# Load the System.Drawing assembly
Add-Type -AssemblyName System.Drawing

# Check if files exist
if (-not (Test-Path $Image1Path) -or -not (Test-Path $Image2Path)) {
    Write-Error "One or both input image files do not exist."
    exit
}

# Load images
$img1 = [System.Drawing.Image]::FromFile((Resolve-Path $Image1Path).Path)
$img2 = [System.Drawing.Image]::FromFile((Resolve-Path $Image2Path).Path)

# Calculate dimensions (resize img2 to match img1 height to maintain a clean rectangle)
$newHeight = $img1.Height
$aspectRatio = $img2.Width / $img2.Height
$newWidth = [math]::Round($newHeight * $aspectRatio)

# Create a new resized version of img2
$resizedImg2 = New-Object System.Drawing.Bitmap($newWidth, $newHeight)
$graphics2 = [System.Drawing.Graphics]::FromImage($resizedImg2)
$graphics2.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$graphics2.DrawImage($img2, 0, 0, $newWidth, $newHeight)
$graphics2.Dispose()

# Create the final combined image surface
$totalWidth = $img1.Width + $newWidth
$combinedImage = New-Object System.Drawing.Bitmap($totalWidth, $newHeight)

$graphicsFinal = [System.Drawing.Graphics]::FromImage($combinedImage)
$graphicsFinal.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

# Draw both images side-by-side
$graphicsFinal.DrawImage($img1, 0, 0, $img1.Width, $img1.Height)
$graphicsFinal.DrawImage($resizedImg2, $img1.Width, 0, $newWidth, $newHeight)
$graphicsFinal.Dispose()

# Save the final image
$combinedImage.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)

# Cleanup resources
$img1.Dispose()
$img2.Dispose()
$resizedImg2.Dispose()
$combinedImage.Dispose()

Write-Host "Image successfully combined and saved to: $OutputPath" -ForegroundColor Green
