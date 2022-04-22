
# Quick registry key/value search
#
# Make sure you have the Registry-Search.ps1 available to run the script




# The only thing you have to update are the following variables below:

[string[]]$keysvalues = "deltek", "Cobra"#, ""#, "compare"  # Registry keys and values to search
[string]$searchregistry = ".\Search-Registry.ps1"  # Location of Search-Registry.ps1
[string]$out_file = "C:\Users\abraham.baquilod.su\Documents\Search_Result.txt" # Output result to the log file

# Add variable check whether we want to show GUID information; maybe add it to log file also


# Locations to search
[string[]]$paths = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths",
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
            "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths",
            "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
            #"HKLM:\SOFTWARE"
            


                   

# You do not have to update the main code to run the script
# Main 

try {

    Set-ExecutionPolicy bypass -Force # allows script execution
    
    try {
        if ( gcm Search-Registry -ErrorAction SilentlyContinue ) {
            Write-Host "Search-Registry function exists"
        
        }
        else {
            powershell.exe -executionpolicy bypass -file $searchregistry
            Write-Host "Ran Set-Execution bypass for Search-Registry.ps1"
        }
    }

    Catch {
        Write-Host "Search registry precheck fail" 
    }
      
    
    Write-host "Start to search registry at: $(get-date -Format G)" | Out-File -FilePath $out_file -ErrorAction SilentlyContinue -Append
    

    foreach ($path in $paths) {

        foreach ($keyvalue in $keysvalues) {
                
            try {
                Search-Registry -Path $path -Recurse -SearchRegex $keyvalue -ErrorAction SilentlyContinue | Out-File -FilePath $out_file -ErrorAction SilentlyContinue -Append
                Search-Registry -Path $path -Recurse -KeyNameRegex $keyvalue -ErrorAction SilentlyContinue | Out-File -FilePath $out_file -ErrorAction SilentlyContinue -Append
                Search-Registry -Path $path -Recurse -ValueNameRegex $keyvalue -ErrorAction SilentlyContinue | Out-File -FilePath $out_file -ErrorAction SilentlyContinue -Append
                Search-Registry -Path $path -Recurse -SearchRegex $keyvalue -ErrorAction SilentlyContinue 
                Search-Registry -Path $path -Recurse -KeyNameRegex $keyvalue -ErrorAction SilentlyContinue
                Search-Registry -Path $path -Recurse -ValueNameRegex $keyvalue -ErrorAction SilentlyContinue

            }
        
            catch # Catch registry access denied error
            {
                Write-host "Registry:  Access Denied."
            }  
        
        }    
    }

    Write-Host ""
    Write-host "Completed searching the registry at: $(get-date -Format G)" | Out-File -FilePath $out_file -ErrorAction SilentlyContinue -Append
}

Catch {
    write-host "Error in the main code. Please check the script."
}




# Uncomment to identify the GUIDs
# Use Registry hive abreviation for -Path. e.g. HKLM:   

#Get-ItemProperty -path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{5C108849-0571-4208-B762-A0587DA8726C}"
#Get-ItemProperty -LiteralPath 