TENANT_NAME="cloudchristoph.com"
SUBSCRIPTION_ID="b3f95b75-66a8-466b-81ec-168f0e11d98c"

# Login to Azure and set subscription
az login --tenant $TENANT_NAME
az account set --subscription $SUBSCRIPTION_ID


# Deploy Dev
az deployment sub create \
    --location "germanywestcentral" \
    --name "DemoEnvironment-dev" \
    --template-file "./02_Modules/DemoEnvironment.bicep" \
    --parameters "./02_Modules/DemoEnvironment-dev.bicepparam" \
    --confirm-with-what-if

# Deploy Test
az deployment sub create \
    --location "germanywestcentral" \
    --name "DemoEnvironment-test" \
    --template-file "./02_Modules/DemoEnvironment.bicep" \
    --parameters "./02_Modules/DemoEnvironment-test.bicepparam" \
    --confirm-with-what-if

# Deploy Prod
az deployment sub create \
    --location "germanywestcentral" \
    --name "DemoEnvironment-prod" \
    --template-file "./02_Modules/DemoEnvironment.bicep" \
    --parameters "./02_Modules/DemoEnvironment-prod.bicepparam" \
    --confirm-with-what-if


##### Publish Modules
MODULE_FILE="./02_Modules/modules/windowsVirtualMachine.bicep"
BICEP_REGISTRY_TARGET="br:ccbicep.azurecr.io/bicep/modules/windows_vm:v1"
az bicep publish --file $MODULE_FILE --target $BICEP_REGISTRY_TARGET --documentationUri https://christoph.vollmann.co/

MODULE_FILE="./02_Modules/modules/virtualNetwork.bicep"
BICEP_REGISTRY_TARGET="br:ccbicep.azurecr.io/bicep/modules/virtual_network:v1"
az bicep publish --file $MODULE_FILE --target $BICEP_REGISTRY_TARGET --documentationUri https://christoph.vollmann.co/



# Deploy Dev with Module from Registry
az deployment sub create \
    --location "germanywestcentral" \
    --name "DemoEnvironment-dev" \
    --template-file "./03_ModuleRegistry/DemoEnvironment.bicep" \
    --parameters "./03_ModuleRegistry/DemoEnvironment-dev.bicepparam" \
    --confirm-with-what-if