if ("C:\Users\w6006381\Desktop\project planning.xlsx" -match '\\[w][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\\') {
    $wid = $Matches[0].Substring(1,8)
}

$wid
