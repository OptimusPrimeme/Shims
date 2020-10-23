function command_files {
    (Get-ChildItem  $psscriptroot\..\libexec) `
        | Where-Object { $_.name -match 'Shims-.*?\.ps1$' }
}

function commands {
    command_files | ForEach-Object { command_name $_ }
}

function command_name($filename) {
    $filename.name | Select-String 'Shims-(.*?)\.ps1$' | ForEach-Object { $_.matches[0].groups[1].value }
}

function command_path($cmd) {
    $cmd_path = "$psscriptroot\..\libexec\shims-$cmd.ps1"

    # # built in commands
    # if (!(Test-Path $cmd_path)) {
    #     # get path from shim
    #     $shim_path = "$scoopdir\shims\shims-$cmd.ps1"
    #     $line = ((Get-Content $shim_path) | Where-Object { $_.startswith('$path') })
    #     if($line) {
    #         Invoke-Expression -command "$line"
    #         $cmd_path = $path
    #     }
    #     else { $cmd_path = $shim_path }
    # }

    $cmd_path
}

function exec($cmd, $arguments) {
    $cmd_path = command_path $cmd

    & $cmd_path @arguments
}