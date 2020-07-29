$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}


$resourceGroupName = "testazurevending"
$location = "australia east"
$TemplateURI = "https://raw.githubusercontent.com/teletoppy/azurevending/master/azurevmbasictemplate.json"
$adminUsername = "thetoppy"
$adminPassword = ConvertTo-SecureString "Demo@demo123" -AsPlainText -Force 
$dnsLabelPrefix = "testazurevending"

#create resource group
New-AzureRMResourceGroup -Name "$resourceGroupName" -Location "$location" -Force


#create vm
New-AzureRMResourceGroupDeployment `
-ResourceGroupName $resourceGroupName `
-TemplateUri $TemplateURI `
-Location $location `
-adminUsername $adminUsername `
-adminPassword $adminPassword `
-dnsLabelPrefix $dnsLabelPrefix -verbose
