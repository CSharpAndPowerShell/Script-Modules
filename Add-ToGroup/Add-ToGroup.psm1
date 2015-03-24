#requires -RunAsAdministrator
#requires -Modules Show-MessageBox
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
	
	Param (
		[Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre del usuario o grupo a añadir.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name,
		[Parameter(Mandatory = $True, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Grupo al que pertenecerá el usuario o grupo.")]
		[String]$Group
	)
	
	Process
	{
        Function Test-User ($Group, $Name)
        {
            $LocalGroup = net localgroup $Group
            for ($i = 0; $i -lt $LocalGroup.Length; $i++)
            {
                if ($LocalGroup.Get($i) -eq $Name)
                {
                    return $true
                }
                else
                {
                    return $false
                }
            }
        }
		New-Group -Name $Group -Description "Este grupo ha sido creado implicitamente por 'Add-ToGroup'."
		If (!(Test-User -Group $Group -Name $Name))
		{
			Try
			{
				$ToGroup = [ADSI]"WinNT://$ENV:Computername/$Group,group"
				$ToGroup.Add("WinNT://$Name")
			}
			Catch
			{
				Show-MessageBox -Message "$_" -Title "Error" -Type Error | Out-Null
			}
		}
	}
}