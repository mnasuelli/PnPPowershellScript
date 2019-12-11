#VARIABLES
$userName = "**********"
$password = "**********"
$securePassword = ConvertTo-SecureString $password –AsPlainText –force
$O365Credential = New-Object System.Management.Automation.PsCredential($username, $securePassword)
$siteSource = "https://contoso.sharepoint.com/sites/***********/"
$SourceLib = "NameList"
$OriginLibrary = "/sites/********"
$RootFolderPath = "C:\****"
 
Remove-Item -Path "C:\......\*" -Recurse

Connect-PnPOnline -Url $siteSource -Credentials($O365Credential)
$ListItem = Get-PnPListItem -List $SourceLib

foreach ($item in $ListItem) {
	
     $Source = $item.FieldValues.FileRef
	
     if (($item.FileSystemObjectType) -eq "Folder") {

          $FolderName = $item["FileLeafRef"]

          $FolderPath = $item["FileDirRef"].Replace($OriginLibrary, $RootFolderPath)

          New-Item -Path $($FolderPath + "\" + $FolderName) -ItemType Directory
			
     }	
        
     if (($item.FileSystemObjectType) -ne "Folder") {
          $x = $Source.Replace($OriginLibrary, $RootFolderPath)
          $y = $x.Replace("/", "\")
          $FilePath = $y.Replace($item["FileLeafRef"], "")

          Get-PnPFile -Url $Source -Path $FilePath -AsFile -Force
     }	    
}
Disconnect-PnPOnline
