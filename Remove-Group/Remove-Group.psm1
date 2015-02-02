#requires -RunAsAdministrator
#requires -Version 2.0
Function Remove-Group
{
    <#
    .SYNOPSIS
    Borrar grupos de usuario locales.
    
    .DESCRIPTION
    Esta función necesita un parámetro; "Name", esta función verifica que el grupo exista para intentar borrarlo.
 
    .EXAMPLE
    Remove-Group -Name "P"
    Remove-Group "P"
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>
    
    [CmdletBinding()]
    Param
	(
		[Parameter(Mandatory=$True,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Nombre del grupo a eliminar.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name
	)
	
    Process
    {
		Try
		{
		    $Groups = (Get-WmiObject -Class Win32_Group).Name
		    if ($Groups.Contains($Name))
		    { #Comprueba si el grupo local existe y lo elimina
			    $Computer = [ADSI]"WinNT://$ENV:Computername"
	            $Group = $Computer.Delete("Group",$Name)
		    }
		}
		Catch
		{
			[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
			[void][System.Windows.Forms.MessageBox]::Show("$_","Error")
		}
    }
}

Export-ModuleMember Remove-Group



