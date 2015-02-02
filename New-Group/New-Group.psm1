#requires -RunAsAdministrator
#requires -Version 2.0
Function New-Group
{
    <#
    .SYNOPSIS
    Crear grupos de usuario locales.
    
    .DESCRIPTION
    Esta función necesita dos parámetros; "Name" y "Description", aunque solo el primero es obligatorio. Esta función verifica si el grupo a crear existe, si no existe lo crea.
 
    .EXAMPLE
    New-Group -Name "Pali" -Description "Usuarios Palidejos"
    New-Group "Pali"
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>
    
    [CmdletBinding()]
    Param
	(
		[Parameter(Mandatory=$True,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Nombre del nuevo grupo.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name,
		
		[Parameter(Position=1,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Descripción del contenido o función del grupo.")]
		[String]$Description
	)
	
    Process
    {
        $LocalGroups = (Get-WmiObject -Class Win32_Group).Name
	    #Comprueba si el grupo local existe, si no existe se crea
        if (($Name -ne "Administradores") -and ($Name -ne "Usuarios"))
        {
	        if (!($LocalGroups.Contains("$Name")))
	        {
				Try
				{
	                $Computer = [ADSI]"WinNT://$ENV:Computername"
	                $Group = $Computer.Create("Group",$Name)
	                $Group.SetInfo()
	                if ($Description.Length -ne 0)
	                {
	                    $Group.description = $Description
	                    $Group.SetInfo()
	                }
				}
				Catch
				{
					[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
					[void][System.Windows.Forms.MessageBox]::Show("$_","Error")
				}
	        }
        }
    }
}

Export-ModuleMember New-Group



