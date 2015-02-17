#requires -RunAsAdministrator
#requires -Version 4.0
function Remove-AllUsers
{
	<#
	.SYNOPSIS
		Elimina todos los usuarios.
	
	.DESCRIPTION
		Elimina todos los usuarios excepto "Administrador" e "Invitado". Puede utilizar el parámetro "Exclude" para excluir más usuarios. O bien utilice el parametro "All" para eliminar todos los usuarios y crear una exclusión personalizada.
	
	.EXAMPLE
		Remove-AllUsers
		Remove-AllUsers -Exclude "Pedro","Juan"
		Remove-AllUsers -Exclude "Pedro","Juan" -All
	
	.NOTES
		Escrito por Cristopher Robles

	.LINK
		https://github.com/PowerShellScripting
	#>
	
	#region Parámetros
	[CmdletBinding()]
	Param (
		[Parameter(ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre del recurso compartido existente.")]
		[String[]]$Exclude,
		[Parameter(ValueFromPipeline = $true, Position = 1, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre del recurso compartido existente.")]
		[Switch]$All = $false
	)
	#endregion
	
	#Se obtiene la lista de usuarios
	[String[]]$LocalUsers = (Get-WmiObject -Class win32_UserAccount).Name
	if (!($All))
	{
		$Exclude += @("Administrador", "Invitado")
	}
	try
	{
		foreach ($User in $LocalUsers)
		{
			if ((!($Exclude.Contains("$User"))) -and (!($User.Contains('$'))))
			{
				$User | Remove-User
			}
		}
	}
	catch
	{
		New-MsgBox -Message "$_" -Title "Error" | Out-Null
	}
}

Export-ModuleMember Remove-AllUsers