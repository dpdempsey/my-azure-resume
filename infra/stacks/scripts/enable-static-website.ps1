
# Get storage account context
$storageAccount = Get-AzStorageAccount -ResourceGroupName $env:ResourceGroupName -AccountName $env:StorageAccountName
$ctx = $storageAccount.Context

# Enable static website hosting with correct index and error document references
Enable-AzStorageStaticWebsite -Context $ctx -IndexDocument $env:IndexDocumentPath -ErrorDocument404Path $env:ErrorDocument404Path

# Path to the frontend folder (relative to script location)
$frontendPath = Join-Path $PSScriptRoot '..\..\..\frontend'

# Upload all files in the frontend folder to the $web container
Write-Host "Uploading frontend files from $frontendPath to the $web container..."
Get-ChildItem -Path $frontendPath -Recurse | Where-Object { -not $_.PSIsContainer } | ForEach-Object {
	$relativePath = $_.FullName.Substring($frontendPath.Length + 1) -replace '\\', '/'
	Set-AzStorageBlobContent -File $_.FullName -Container '$web' -Blob $relativePath -Context $ctx -Force
}
Write-Host "Upload complete."

