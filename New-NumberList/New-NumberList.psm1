#requires -Version 2.0
Function New-NumberList
{
    <#
    .SYNOPSIS
    Crea una lista de numeros.
    
    .DESCRIPTION
    Se encarga de crear una lista de numeros y puede cargarla en una variable del tipo [String]

    .EXAMPLE
    $Nl = New-NumberList 1 6
    $Us = New-NumberList 1 30
    $NM = "11"
    For($j = 1; $j -lt $Us.Length; $j++)
    {
        For($i = 1; $i -lt $Nl.Length; $i++)
        {
            $Concatenar = "M" + $NM + "-" + $Nl[$i] + $Us[$j]
            Write-Host $Concatenar
        }
    }
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>

    [CmdletBinding()]
	Param
	(
		[parameter(mandatory=$true,position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Inicio del contador.")]
		[ValidateNotNullorEmpty()]
		[int]$Start,

        [parameter(mandatory=$true,position=1,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Fin del contador.")]
		[ValidateNotNullorEmpty()]
		[int]$End
	)
    
    Process
    {
        [String[]]$Contar
        For ($i = $Start; $i -le $End; $i++)
        {
            if ($i -le 9)
            {
                $tmp = '0' + $i
            }
            else
            {
                $tmp = $i + ""
            }
            $Count += @($tmp)
        }
    }
    End
    {
        Return $Count
    }
}

Export-ModuleMember New-NumberList



