function Remove-NetworkDrive
{
	<#
    .SYNOPSIS
    Desmonta unidades de red.
    
    .DESCRIPTION
    Esta función necesita la letra de la unidad a desmontar "Letter". O utilice "All" para desmontar todas las unidades de red.
 
    .EXAMPLE
    Remove-NetworkDrive -Letter "C"
	Remove-NetworkDrive -All
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>
	
	Param (
		[Parameter(Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Letra de la unidad a desmontar.")]
		[Char]$Letter,
		[Parameter(Position = 1, HelpMessage = "Desmonta todas las unidades de red.")]
		[Switch]$All = $false
	)
	Begin
	{
		$WshNetwork = New-Object -ComObject Wscript.Network
	}
	Process
	{
		Try
		{
			if ($All)
			{
				foreach ($Letter in $WshNetwork.EnumNetworkDrives())
				{
					if ($Letter.Length -eq 2)
					{
						$WshNetwork.RemoveNetworkDrive($Letter + ":", $true)
					}
				}
			}
			else
			{
				$WshNetwork.RemoveNetworkDrive($Letter + ":", $true)
			}
		}
		Catch
		{
			Show-MessageBox -Message "$_" -Title "Error" | Out-Null
		}
	}
}