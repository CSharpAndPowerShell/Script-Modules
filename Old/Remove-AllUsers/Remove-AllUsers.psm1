<#
CSharpAndPowerShell Modules, tries to help Microsoft Windows admins to write automated scripts easier.
Copyright (C) 2015  Cristopher Robles Ríos

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
#>

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
		Script-Modules  Copyright (C) 2015  Cristopher Robles Ríos
        This program comes with ABSOLUTELY NO WARRANTY.
        This is free software, and you are welcome to redistribute it
        under certain conditions.

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