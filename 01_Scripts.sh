TENANT_NAME="cloudchristoph.com"
SUBSCRIPTION_ID="b3f95b75-66a8-466b-81ec-168f0e11d98c"

# Login to Azure and set subscription
az login --tenant $TENANT_NAME
az account set --subscription $SUBSCRIPTION_ID

# Deploy 01_resource.bicep
az deployment group create --resource-group "01_Examples" --template-file "./01_Examples/01_resource.bicep"

# Deploy 02_resource_with_param.bicep - parameters not given
az deployment group create \
    --resource-group "01_Examples" \
    --template-file "./01_Examples/02_resource_with_param.bicep"

# Deploy 02_resource_with_param.bicep - parameters given
az deployment group create \
    --resource-group "01_Examples" \
    --template-file "./01_Examples/02_resource_with_param.bicep" \
    --parameters "name=sysadminday2023"

# Deploy 02_resource_with_param.bicep - parameters given with parameter file
az deployment group create \
    --resource-group "01_Examples" \
    --template-file "./01_Examples/02_resource_with_param.bicep" \
    --parameters "./01_Examples/02_resource_with_param.bicepparam" --confirm-with-what-if

# Deploy 03_resource_with_param.bicep - parameters given with parameter file


#### TODO: This does not work yet