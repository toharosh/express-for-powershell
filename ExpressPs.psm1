Install-Module Polaris

$Classes = @( Get-ChildItem -Path $PSScriptRoot\classes\*.ps1 -ErrorAction SilentlyContinue | where {$_.Name -ne "ExpressPs.Class.ps1"})
$Classes += @( Get-ChildItem -Path $PSScriptRoot\classes\ExpressPs.Class.ps1 -ErrorAction SilentlyContinue )

Foreach ($import in @($Classes)) {
    Try {
        . $import.fullname
    }
    Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

function Get-ExpressPs()
{
  return [ExpressPs]::new()
}

# Export the function, which can generate a new instance of the class
Export-ModuleMember -Function Get-ExpressPs