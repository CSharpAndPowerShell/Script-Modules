﻿#requires -RunAsAdministrator
#requires -Version 2.0
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
    Escrito por Cristopher Robles
 
    .LINK
    https://github.com/PowerShellScripting
    #>
    
    [CmdletBinding()]
    Param
	(
		[Parameter(Mandatory=$True,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Nombre del usuario o grupo a añadir.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name,
		
		[Parameter(Mandatory=$True,Position=1,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Grupo al que pertenecerá el usuario o grupo.")]
		[String]$Group
	)
	
    Process
    {
        $LocalGroups = net localgroup $Group
        if(!($LocalGroups.Contains("$Name")))
        {
			try
			{
	            $ToGroup = [ADSI]"WinNT://$ENV:Computername/$Group,group"
	            $ToGroup.Add("WinNT://$Name")
			}
			catch
			{
				[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
				[void][System.Windows.Forms.MessageBox]::Show("$_","Error")
			}
        }
    }
}

Export-ModuleMember Add-ToGroup


