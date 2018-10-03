param (
    [Parameter(Mandatory=$False,Position=1)][string]$OutputFolder = "\\nas01.woolworths.co.za\poc_window10_migration\exonline"
)

# pst files
$outputfile = $OutputFolder + "\" + $env:COMPUTERNAME + "_PST.csv"
Get-ChildItem C:\ -Filter *.pst -Recurse -ErrorAction SilentlyContinue | Select-Object FullName,Length | Export-Csv -Path $outputfile -Encoding ASCII -NoTypeInformation

# office files
$Exclusions = ("Administrator", "Default", "Public", "sfb_cache_clear_01.txt")
$outputfile = $OutputFolder + "\" + $env:COMPUTERNAME + "_OFF.csv"
Get-ChildItem -Path C:\ -Include *.doc, *.dot, *.wbk, *.docx, *.docm, *.dotx, *.dotm, *.docb, *.xls, *.xlt, *.xlm, *.xlsx, *.xlsm, *.xltx, *.xltm, *.xlsb, *.xla, *.xlam, *.xll, *.xlw, *.ppt, *.pot, *.pps, *.pptx, *.pptm, *.potx, *.potm, *.ppam, *.ppsx, *.ppsm, *.sldx, *.sldm, *.accdb, *.accde, *.accdt, *.accdr, *.pub, *.xps -Recurse -ErrorAction SilentlyContinue | Select-Object FullName,Length | Export-Csv -Path $outputfile -Encoding ASCII -NoTypeInformation

# media files
$outputfile = $OutputFolder + "\" + $env:COMPUTERNAME + "_MED.csv"
Get-ChildItem -Path C:\ -Include *.avi,*.m4a,*.m4p,*.m4v,*.mobi,*.mov,*.mp3,*.mp4,*.mpeg,*.mpg,*.VOB,*.wav,*.wma,*.wmv, *.flv -Recurse -ErrorAction SilentlyContinue | Select-Object FullName,Length | Export-Csv -Path $outputfile -Encoding ASCII -NoTypeInformation

# picture files
$outputfile = $OutputFolder + "\" + $env:COMPUTERNAME + "_PIC.csv"
Get-ChildItem -Path C:\ -Include *.bmp,*.jpg,*.jpeg,*.png,*.gif,*.tif,*.tiff,*.jpe,*.ico,*.dip,*.jfif -Recurse -ErrorAction SilentlyContinue | Select-Object FullName,Length | Export-Csv -Path $outputfile -Encoding ASCII -NoTypeInformation

# profiles
$File = $OutputFolder + "\ProfileSizeReport.csv"

#Exclude these accounts from reporting
$Exclusions = ("Administrator", "Default", "Public", "sfb_cache_clear_01.txt")

#Get the list of profiles
#$Profiles = Get-ChildItem -Path $env:SystemDrive"\Users" -Exclude *.txt | Where-Object { $_ -notin $Exclusions }
$Profiles = Get-ChildItem -Path $env:SystemDrive"\Users" | Where-Object { $_ -notin $Exclusions }

#Create the object array
$AllProfiles = @()

#Create the custom object
foreach ($Profile in $Profiles) {
	$object = New-Object -TypeName System.Management.Automation.PSObject
	#Get the size of the Documents and Desktop combined and round with no decimal places
	$FolderSizes = [System.Math]::Round("{0:N2}" -f ((Get-ChildItem ($Profile.FullName + '\Documents'), ($Profile.FullName + '\Desktop'), ($Profile.FullName + '\Pictures'), ($Profile.FullName + '\Videos') -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum))
    #$FolderSizes = [System.Math]::Round("{0:N2}" -f ((Get-ChildItem ($Profile.FullName) -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum))
    #Get-ChildItem ($Profile.FullName) -Include *.pst -Recurse #| Measure-Object -Property Length -Sum -ErrorAction Stop).Sum))
	$object | Add-Member -MemberType NoteProperty -Name ComputerName -Value $env:COMPUTERNAME.ToUpper()
	$object | Add-Member -MemberType NoteProperty -Name Profile -Value $Profile
	$Object | Add-Member -MemberType NoteProperty -Name Size -Value $FolderSizes
	$AllProfiles += $object
}

#Create the formatted entry to write to the file
[string]$Output = $null
foreach ($Entry in $AllProfiles) {
	[string]$Output += $Entry.ComputerName + ',' + $Entry.Profile + ',' + $Entry.Size + [char]13   
    #Write-Host $Entry.ComputerName $Entry.Profile ($Entry.Size / 100)
}

#Remove the last line break
$Output = $Output.Substring(0,$Output.Length-1)

#Write the output to the specified CSV file. If the file is opened by another machine, continue trying to open until successful
Do {
	Try {
		$Output | Out-File -FilePath $File -Encoding UTF8 -Append -Force
		$Success = $true
	} Catch {
		$Success = $false
	}
} while ($Success = $false)  