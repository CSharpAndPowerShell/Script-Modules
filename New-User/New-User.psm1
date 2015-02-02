#requires -RunAsAdministrator
#requires -Modules New-Group, Add-ToGroup
#requires -Version 2.0
Function New-User
{
    <#
    .SYNOPSIS
    Crear usuarios locales.
    
    .DESCRIPTION
    Esta función necesita un parámetro; "Name". Esta función verifica si el usuario existe, si no existe lo crea. El parámetro "HomeDirectory" generalmente es una carpeta compartida similar a "\\127.0.0.1\NombredeUsuario". El parámetro "HomeDirDrive" generalmente es "T:\" y en esta letra se encuentra "HomeDirectory".
 
    .EXAMPLE
    New-User -Name "P" -Description "Usuario P"
    New-User -Name "P" -Pass "Password"
    New-User "P"
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>
    
    [CmdletBinding()]
    Param
	(
		[Parameter(Mandatory=$True,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Nombre del nuevo usuario.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name,
		
		[Parameter(Position=1,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Contraseña para el nuevo usuario.")]
		[String]$Pass,
		
		[Parameter(Position=2,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Descripción del nuevo usuario.")]
		[String]$Description,
		
		[Parameter(Position=3,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Carpeta personal del nuevo usuario.")]
		[String]$HomeDirectory,
		
		[Parameter(Position=4,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Script de inicio de sesión para el nuevo usuario.")]
		[String]$LoginScript,
		
		[Parameter(Position=5,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Ruta al perfil para el nuevo usuario.")]
		[String]$Profile,
		
		[Parameter(Position=6,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Letra en la que se montará el 'HomeDirectory'.")]
		[String]$HomeDirDrive,
		
		[Parameter(Position=7,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Grupo al que pertenecerá el nuevo usuario.")]
		[String]$Group
	)
	
    Process
    {
		Try
		{
            #Se valida si el usuario existe
            $LocalUsers = (Get-WmiObject -Class Win32_UserAccount).Name
	        if (!($LocalUsers.Contains($Name)))
	        {
		        #Objeto con la conexión de ruta donde se crearán los usuarios 
		        $Computer = [adsi]"WinNT://$ENV:COMPUTERNAME"
		        #Objeto que llamará metodos del API para asignar del usuario para luego crearlo
		        $User = $Computer.Create("user", $Name)
		        #Se establece el nombre completo para el usuario
		        $User.Put("Fullname", $Name)
		        if ($Pass.Length -ne 0)
		        { #Comprueba si el usuario se creará con contraseña
			        $User.SetPassword($Pass)
		        }
		        #Se crea el usuario con los valores anteriores
		        $User.SetInfo()
		        if ($Description.Length -ne 0)
		        { #Se asigna descripción del usuario
			        $User.Description = $Description
		        }
		        if ($HomeDirectory.Length -ne 0)
		        { #Comprueba si se ha asignado una carpeta particular al usuario
			        #Se asigna carpeta particular al usuario
			        $User.Put("HomeDirectory",$HomeDirectory)
		        }
		        if ($LoginScript.Length -ne 0)
		        { #Comprueba si se ha asignado un script de inicio de sesión al usuario
			        #Se asigna script de inicio de sesión al usuario
			        $User.Put("LoginScript",$LoginScript)
		        }
		        if ($Profile.Length -ne 0)
		        { #Comprueba si se ha asignado un perfil mandatorio al usuario
			        $User.Put("Profile",$Profile)
		        }
		        if ($HomeDirDrive.Length -ne 0)
		        { #Comprueba si se ha asignado una unidad en red al usuario
			        $User.Put("HomeDirDrive",$HomeDirDrive)
		        }
		        #El usuario no puede cambiar contraseña y contraseña no caduca
		        $User.UserFlags = 64+65536
		        #Se aplican los cambios al usuario
		        $User.SetInfo()
		        if ($Group.Length -ne 0)
		        { #Comprueba si el usuario será agregado a un grupo local
                    New-Group -Name $Group
			        Add-ToGroup -Name $Name -Group $Group
		        }
	        }
	        else
	        { #Si el usuario ya existe
		        if ($Group.Length -ne 0)
		        { #Se agrega el usuario al grupo local
                    New-Group -Name $Group
				    Add-ToGroup -Name $Name -Group $Group
                }
		    }
		}
		Catch
		{
			[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
			[void][System.Windows.Forms.MessageBox]::Show("$_","Error")
		}
    }
}

Export-ModuleMember New-User


