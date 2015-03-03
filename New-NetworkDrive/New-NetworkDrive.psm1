#requires -Modules Rename-Drive
#requires -Version 4.0
Function New-NetworkDrive
{
    <#
    .SYNOPSIS
    Conectar y renombrar unidades de red.
    
    .DESCRIPTION
    Esta función necesita dos parámetros; "Letter" y "Path", ambos son obligatorios. Si no se establece el parámetro "Name", la unidad tomará el nombre del recurso compartido, no se muestra el nombre del host ni la dirección IP donde se encuentra el recurso compartido.
	
    .EXAMPLE
    New-NetworkDrive -Letter "Z" -Path "\\127.0.0.1\C$"
    New-NetworkDrive -Letter "Z" -Path "\\127.0.0.1\C$" -Name "Sistema"
	
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>
	
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Letra que será utilizada como punto de montaje para la unidad de red.")]
		[ValidateNotNullOrEmpty()]
		[Char]$Letter,
		[Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Ruta UNC del recurso compartido.")]
		[ValidateNotNullOrEmpty()]
		[String]$Path,
		[Parameter(Position = 2, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre del usuario con permiso sobre la unidad de red.")]
		[String]$User,
		[Parameter(Position = 3, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Contraseña del usuario con permiso sobre la unidad de red.")]
		[String]$Pass,
		[Parameter(Position = 4, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre de la unidad de red.")]
		[String]$Name
	)
	Begin
	{
		$WshNetwork = New-Object -ComObject Wscript.Network
	}
	Process
	{
		$Path = $Path.TrimEnd("\")
		Try
		{
			If ($User.Length -ne 0)
			{
				If ($Pass.Length -ne 0)
				{
					$WshNetwork.MapNetworkDrive("$Letter" + ":", "$Path", $false, "$User", "$Pass")
				}
				Else
				{
					$WshNetwork.MapNetworkDrive("$Letter" + ":", "$Path", $false, "$User")
				}
			}
			Else
			{
				$WshNetwork.MapNetworkDrive("$Letter" + ":", "$Path", $false)
			}
			If ($Name.Length -ne 0)
			{
				Rename-Drive -Letter $Letter -Name "$Name"
			}
			Else
			{
				$Name = $Path.Split("\")[-1]
				Rename-Drive -Letter $Letter -Name "$Name"
			}
		}
		Catch
		{
			New-MsgBox -Message "$_" -Title "Error" | Out-Null
		}
	}
}
