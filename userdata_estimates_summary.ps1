$reports = Get-ChildItem -Path .\data 

$pstObj = New-Object PSObject -Property @{
    Device  = $null
    PSTFile = $null
    Size  = $null
}

$PSTObjects = @()
$MEDObjects = @()
$PICObjects = @()
$OFFObjects = @()

$report_header = "Device;Type;File;Size (Bytes)"
$PSTObjects += $report_header
#$MEDObjects += $report_header
#$PICObjects += $report_header
#$OFFObjects += $report_header

foreach ($report in $reports) {
    $device = ($report.Name).Substring(0,9)
    $type = ($report.Name).Substring(10,3)
    
    switch ($type) {
        "MED" {
            Write-Host "Processing" $report.FullName
            $content = Import-Csv -Path $report.FullName
            $cnt = 0
            $total_size = 0
            foreach ($line in $content) {
                if (($line.FullName.ToLower() -like "*\program files*") -or ($line.FullName.ToLower() -like "*\windows*") -or ($line.FullName.ToLower() -like "*\onedrive*") -or ($line.FullName.ToLower() -like "*\administrator\*")) {

                }
                else {
                    $obj = $device + ";" + $type + ";" + $line.FullName + ";" + $line.Length #+ [char]13    
                    $cnt += 1
                    $total_size += $line.Length
                    $MEDObjects += $obj                   
                }
            }
            $sub_total = $device + ";" + $type + ";" + $cnt + ";" + $total_size
            $MEDObjects += $sub_total 
        }

        "PIC" {
            Write-Host "Processing" $report.FullName
            $content = Import-Csv -Path $report.FullName
            $cnt = 0
            $total_size = 0
            foreach ($line in $content) {
                if (($line.FullName.ToLower() -like "*\program files*") -or ($line.FullName.ToLower() -like "*\windows*") -or ($line.FullName.ToLower() -like "*\onedrive*") -or ($line.FullName.ToLower() -like "*\administrator\*")) {

                }
                else {
                    $obj = $device + ";" + $type + ";" + $line.FullName + ";" + $line.Length #+ [char]13    
                    $cnt += 1
                    $total_size += $line.Length
                    $PICObjects += $obj                   
                }
            }
            $sub_total = $device + ";" + $type + ";" + $cnt + ";" + $total_size
            $PICObjects += $sub_total 
        }

        "OFF" {
            Write-Host "Processing" $report.FullName
            $content = Import-Csv -Path $report.FullName
            $cnt = 0
            $total_size = 0
            foreach ($line in $content) {
                if (($line.FullName.ToLower() -like "*\program files*") -or ($line.FullName.ToLower() -like "*\windows*") -or ($line.FullName.ToLower() -like "*\onedrive*") -or ($line.FullName.ToLower() -like "*\administrator\*")) {

                }
                else {
                    $obj = $device + ";" + $type + ";" + $line.FullName + ";" + $line.Length #+ [char]13    
                    $cnt += 1
                    $total_size += $line.Length
                    $OFFObjects += $obj                   
                }
            }
            $sub_total = $device + ";" + $type + ";" + $cnt + ";" + $total_size
            $OFFObjects += $sub_total 
        }

        "PST" {
            Write-Host "Processing" $report.FullName
            $content = Import-Csv -Path $report.FullName
            $cnt = 0
            $total_size = 0
            foreach ($line in $content) {
                $obj = $device + ";" + $type + ";" + $line.FullName + ";" + $line.Length #+ [char]13   
                $cnt += 1
                $total_size += $line.Length
                $PSTObjects += $obj
            }
            $sub_total = $device + ";" + $type + ";" + $cnt + ";" + $total_size
            $PSTObjects += $sub_total 
        }
    }
    #$AllObjects += $obj 
    
}

# generate reports
$PSTObjects | Out-File -FilePath .\DATAReport_20181003_V0-01.csv -Encoding ascii -Force
$MEDObjects | Out-File -FilePath .\DATAReport_20181003_V0-01.csv -Encoding ascii -Force -Append
$PICObjects | Out-File -FilePath .\DATAReport_20181003_V0-01.csv -Encoding ascii -Force -Append
$OFFObjects | Out-File -FilePath .\DATAReport_20181003_V0-01.csv -Encoding ascii -Force -Append
