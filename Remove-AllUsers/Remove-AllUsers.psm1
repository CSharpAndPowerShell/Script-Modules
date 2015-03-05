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
	Param (
		[Parameter(ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre de usuarios a excluir, separado por comas.")]
		[Array]$Exclude,
		[Parameter(ValueFromPipeline = $true, Position = 1, ValueFromPipelineByPropertyName = $true, HelpMessage = "Si se establece se eliminarán todos los usuarios, utilice 'Exclude'.")]
		[Switch]$All = $false
	)
	#endregion
	
	#Se obtiene la lista de usuarios
	$Users = (Get-WmiObject -Class win32_UserAccount).Name
	if (!($All))
	{
		$Exclude += @("Administrador", "Invitado", 'HomeGroupUser$')
	}
	try
	{
		for ($i = 0; $i -lt $Users.Length; $i++)
		{
			if (!($Exclude.Contains($Users[$i])))
			{
				Remove-User $Users[$i]
			}
		}
	}
	catch
	{
		New-MsgBox -Message "$_" -Title "Error" | Out-Null
	}
}