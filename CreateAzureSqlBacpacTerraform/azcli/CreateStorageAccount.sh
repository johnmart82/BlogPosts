az account set --subscription "00000000-0000-0000-0000-000000000000"

az group create --location UKSouth --name "rg-dbstaging"

az storage account create --name "sadbstaging" --resource-group "rg-dbstaging" --location UKSouth --sku Standard_LRS

az storage container create --name "dbbacpc" --account-name "sadbstaging" --auth-mode login

az storage container generate-sas --account-name "sadbstaging" --name "dbbacpc" --permissions acdlrw --expiry 2021-02-22 --auth-mode login --as-user