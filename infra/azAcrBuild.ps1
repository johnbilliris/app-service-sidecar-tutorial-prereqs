Write-Host "Getting environment values from azd..."
$AZURE_SUBSCRIPTION_ID = azd env get-value 'AZURE_SUBSCRIPTION_ID'
$GROUP_NAME = azd env get-value 'GROUP_NAME'
$GROUP_URL = azd env get-value 'GROUP_URL'
$ACR_NAME = azd env get-value 'ACR_NAME'
$APPLICATIONINSIGHTS_CONNECTION_STRING = azd env get-value 'APPLICATIONINSIGHTS_CONNECTION_STRING'
$MI_ID = azd env get-value 'MI_ID'
$MI_CLIENT_ID = azd env get-value 'MI_CLIENT_ID'

# Make sure az commands use the same subscription
az account set -s $AZURE_SUBSCRIPTION_ID

Write-Host "Building and uploading nginx image. Please wait..."
az acr build --resource-group $GROUP_NAME `
  --registry $ACR_NAME `
  --image nginx https://github.com/Azure-Samples/app-service-sidecar-tutorial-prereqs.git#main:images/nginx `
  --file Dockerfile `
  --platform linux `
  --no-logs `
  --output none
Write-Host "Success!"

Write-Host "Building and uploading otel-collector image. Please wait..."
az acr build --resource-group $GROUP_NAME `
  --registry $ACR_NAME `
  --image otel-collector https://github.com/Azure-Samples/app-service-sidecar-tutorial-prereqs.git#main:images/otel-collector `
  --file Dockerfile `
  --platform linux `
  --no-logs `
  --output none
Write-Host "Success!"
