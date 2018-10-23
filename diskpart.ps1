# Andrew Kenny, Dimension Data WC, 23/10/2018
# 
# Clear the selected disk
#
# V01-00 | 23/10/2018 | AKenny | Original

function WipeDisk {
    Param
    (
         [Parameter(Mandatory=$true, Position=0)][int] $disknumber,
         [Parameter(Mandatory=$true, Position=1)][string] $partstyle
    )    
    
    switch ($partstyle) {
        "RAW" { Get-Disk $disknumber | Initialize-Disk -PartitionStyle MBR -PassThru | New-Partition -AssignDriveLetter -UseMaximumSize -IsActive | Format-Volume -FileSystem NTFS -NewFileSystemLabel "WINPE" }
        default { Get-Disk $disknumber | Clear-Disk -RemoveData 
                  Get-Disk $disknumber | Initialize-Disk -PartitionStyle MBR -PassThru | New-Partition -AssignDriveLetter -UseMaximumSize -IsActive | Format-Volume -FileSystem NTFS -NewFileSystemLabel "WINPE" }
    }
}

Write-Host "                " -ForegroundColor White -BackgroundColor Magenta
Write-Host " TTTTTTT FFFFFF " -ForegroundColor White -BackgroundColor Magenta
Write-Host "    T    F      " -ForegroundColor White -BackgroundColor Magenta
Write-Host "    T    FFF    " -ForegroundColor White -BackgroundColor Magenta
Write-Host "    T    F      " -ForegroundColor White -BackgroundColor Magenta
Write-Host "    T    F      " -ForegroundColor White -BackgroundColor Magenta
Write-Host "  GGGGGG F      " -ForegroundColor White -BackgroundColor Magenta
Write-Host " G              " -ForegroundColor White -BackgroundColor Magenta
Write-Host " G              " -ForegroundColor White -BackgroundColor Magenta
Write-Host " G   GGG        " -ForegroundColor White -BackgroundColor Magenta
Write-Host " G     G        " -ForegroundColor White -BackgroundColor Magenta
Write-Host "  GGGGG         " -ForegroundColor White -BackgroundColor Magenta
Write-Host ""

do {
    Write-Host "Welcome to the TFG HO Operating System Deployment System. Your system booted with a 64-bit boot image."
    Write-Host "If you need to build a 32-bit system, follow the instructions in this script."
    Write-Host "Only continue if you are sure that the data on the drive you select will NOT be needed."
    Write-Host "The disk you select will be formatted." -ForegroundColor Red
    Write-Host ""
    $prompt1 = Read-Host -Prompt "Do you want to continue? Confirm by typing Yes or No"
} until (($prompt1.ToLower() -eq "yes") -or ($prompt1.ToLower() -eq "no"))

switch ($prompt1.ToLower()) {
    "no" { Write-Host "Task cancelled. Select the Task Sequence to execute." }
    "yes" { 
            do {
                Write-Host "In the next step you will select the disk to format. Do you want to continue?"
                $prompt2 = Read-Host -Prompt "Confirm by typing WipeDisk or No"
            } until (($prompt2.ToLower() -eq "wipedisk") -or ($prompt2.ToLower() -eq "no"))

            switch ($prompt2.ToLower()) {
                "no" { Write-Host "Task cancelled. Select the Task Sequence to execute." }
                "wipedisk" { 
                    do {
                        Write-Host ""
                        $disks = Get-Disk | Select-Object Number, Model, Size, PartitionStyle 
                        
                        foreach ($obj in $disks)
                        {
                            Write-Host "Number `t Model" 
                            Write-Host $obj.Number "`t" $obj.Model "-"($obj.Size / 1024 / 1024 /1024) "GB -" $obj.PartitionStyle
                        }
                        $cnt = $disks.Number.count
                        $cnt = $cnt-1

                        Write-Host ""
                        do {
                            $disknr = Read-Host -Prompt "Select the disk number [0..$cnt]" 
                        } until (($disknr -le $cnt) -and ($disknr -ge 0))
                        
                        $prompt3 = Read-Host -Prompt "Do you want to continue? Confirm by typing Yes or No" 
                    } until (($prompt3.ToLower() -eq "yes") -or ($prompt3.ToLower() -eq "no"))

                    switch ($prompt3.ToLower()) {
                        "no" { Write-Host "Task cancelled. Select the Task Sequence to execute." }
                        "yes" { $disktowipe = Get-Disk | Where-Object { $_.Number -eq $disknr } | Select-Object Number, Model, Size, PartitionStyle
                                do {
                                    $diskmodel = $($disktowipe).Model
                                    $prompt4 = Read-Host -Prompt "$diskmodel will be wipe. Do you want to continue? Confirm by typing Yes or No"
                                } until (($prompt4.ToLower() -eq "yes") -or ($prompt4.ToLower() -eq "no"))

                                switch ($prompt4.ToLower()) {
                                    "no" { Write-Host "Select the Task Sequence to execute." }
                                    "yes" { Write-Host "Call function to wipe disk" 
                                            WipeDisk -disknumber $($disktowipe).Number -partstyle $($disktowipe).PartitionStyle
                                    }
                                }
                                
                        }
                 
                    }

                }
            }    
        }
}

Write-Host ""
#Read-Host -Prompt "Done. Press <Enter> to continue"

