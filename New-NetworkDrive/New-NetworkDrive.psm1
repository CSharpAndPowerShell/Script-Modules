#requires -Modules Rename-NetworkDrive
#requires -Version 4.0
Function New-NetworkDrive
{
    <#
    .SYNOPSIS
    Conectar y renombrar unidades de red.
    
    .DESCRIPTION
    Esta función necesita tres parámetros; "Letter" y "Path", ambos son obligatorios.
 
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
	
	Process
	{
		$Drive = $Letter + ":"
		$Path = $Path.TrimEnd("\")
		Try
		{
			If ($User.Length -ne 0)
			{
				If ($Pass.Length -ne 0)
				{
					Invoke-Expression "net use $Drive '$Path' /user:$User '$Pass' /Persistent:No" | Out-Null
				}
				Else
				{
					Invoke-Expression "net use $Drive '$Path' /user:$User /Persistent:No" | Out-Null
				}
			}
			Else
			{
				Invoke-Expression "net use $Drive '$Path' /Persistent:No" | Out-Null
			}
			If ($Name.Length -ne 0)
			{
				Rename-NetworkDrive -Letter $Letter -Name "$Name"
			}
			Else
			{
				$Name = $Path.Split("\")[-1]
				Rename-NetworkDrive -Letter $Letter -Name "$Name"
			}
		}
		Catch
		{
			New-MsgBox -Message "$_" -Title "Error"
		}
	}
}

Export-ModuleMember New-NetworkDrive