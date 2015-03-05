#requires -Version 4.0
Function New-List
{
    <#
    .SYNOPSIS
    Devuelve una lista.
    
    .DESCRIPTION
    Se encarga de crear una lista de numeros se puede agregar un prefijo para generar una lista de combres con un formato común, esta lista puede cargarse en una variable del tipo [String[]]

    .EXAMPLE
    New-List -Prefix ($ENV:ComputerName + "-") -Start 1 -End 2,10
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>
	
	Param (
		[parameter(position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Prefijo para la tabla.")]
		[String]$Prefix,
		[parameter(mandatory = $true, position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Inicio del contador.")]
		[ValidateNotNullorEmpty()]
		[int]$Start,
		[parameter(mandatory = $true, position = 2, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Fin del primer contador en el campo 1 y fin del segundo contado en el campo 2.")]
		[ValidateNotNullorEmpty()]
		[int[]]$End
	)
	
	Process
	{
		function Count($Start, $End)
		{
			[String[]]$Contar
			For ($i = $Start; $i -le $End; $i++)
			{
				If ($i -le 9)
				{
					$tmp = '0' + $i
				}
				Else
				{
					$tmp = $i + ""
				}
				$Count += @($tmp)
			}
			Return $Count
		}
		$Cont1 = Count $Start $End[0]
		$Cont2 = Count 1 $End[1]
		[String[]]$List
		For ($f = ($Start - 1); $f -lt $Start; $f++)
		{
			For ($j = 1; $j -lt $Cont1.Length; $j++)
			{
				For ($i = 1; $i -lt $Cont2.Length; $i++)
				{
					$List += @($Prefix + $Cont1[$j] + $Cont2[$i])
				}
			}
		}
	}
	End
	{
		Return $List
	}
}