#requires -Version 2.0
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
		[int]$End
	)
	Begin
	{
		[array]$List = $null
	}
	
	Process
	{
		$Start..$End | % {
			if ($_ -le 9) { $t = '0' + $_ }
			$List += "$Prefix" + "$t"
		}
	}
	End
	{
		return $List
	}
}