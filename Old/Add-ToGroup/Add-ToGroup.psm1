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

Function Add-ToGroup
{
    <#
    .SYNOPSIS
    Agrega usuarios o grupos a grupos locales.
    
    .DESCRIPTION
    Esta función necesita dos parámetros; "Name" y "Group". Esta función verifica si el usuario o grupo existen en el grupo, si no existen los agrega.

    .EXAMPLE
    Add-ToGroup -Name "NuevoUsuario" -Group "Administradores"
 
    .NOTES
    Script-Modules  Copyright (C) 2015  Cristopher Robles Ríos
    This program comes with ABSOLUTELY NO WARRANTY.
    This is free software, and you are welcome to redistribute it
    under certain conditions.
 
    .LINK
    https://github.com/CSharpAndPowerShell/Script-Modules
    #>
	
	#region "Parámetros"
	Param (
		[Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre del usuario o grupo a añadir.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name,
		[Parameter(Mandatory = $True, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Grupo al que pertenecerá el usuario o grupo.")]
		[ValidateNotNullOrEmpty()]
        [String]$Group
	)
	#endregion
	
	#region "Funciones"
	Process
	{
		Try
        {
            New-Group -Name $Group
			$ToGroup = [ADSI]"WinNT://$ENV:Computername/$Group,group"
		    $ToGroup.Add("WinNT://$Name")
		}
		Catch
		{
			Write-Error -Message "$_" -Category 'InvalidArgument'
		}
    }
    #endregion
}