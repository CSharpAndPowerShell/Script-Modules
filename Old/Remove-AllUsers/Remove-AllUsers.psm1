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
		https://github.com/CSharpAndPowerShell/Script-Modules
	#>
	
	#region Parámetros
	Param (
		[Parameter(Position = 0, HelpMessage = "Nombre de usuarios a excluir, separado por comas.")]
		[Array]$Exclude,
		[Parameter(Position = 1, HelpMessage = "Si se establece se eliminarán todos los usuarios, utilice 'Exclude'.")]
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
		foreach ($User in $Users)
		{
			if (!($Exclude.Contains($User)))
			{
				Remove-User $User
			}
		}
	}
	catch
	{
		Write-Error -Message "$_"
	}
}