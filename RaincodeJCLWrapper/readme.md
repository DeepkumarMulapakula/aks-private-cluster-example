# Post deployment activity to run your Mainframe workloads on AKS containers

## Configure Storage account: ##

Below steps helps you to have the JCL artifacts placed on the azure fileshare and let JCLContainer access it using the file mount

- Create azure fileshare ($AZURE_FILE_SHARE), for e.g. jclartifacts and add the folders Catalog, Jcls and Programs
- Under Catalog folder copy the Raincode.Catalog.xml and Raincode license file
- Under Jcls folder, place your mainframe JCLs, you can copy the sample jcls SUBSTR.JCL & JCLHELLO.JCL if you dont have JCLs handy 
- Under Programs folder, place your raincode compiled COBOL & PL1 dlls, you can copy the sample HELLO.dll if you dont have compiled dlls handy
- Place DB connection strings if required by the COBOL & PL1 modules in the RcDbConnections.csv file under the fileshare jclartifacts

## Mount azure fileshare to AKS cluster: ##

- Login to the azure portal and open the Cloud Shell, Refer [Microsoft Documentation](https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-portal?tabs=azure-cli#connect-to-the-cluster)
- Configure kubectl by executing below command
```
az aks get-credentials --resource-group myResourceGroup --name $AKS_CLUSTER_NAME
```
- Create namespace for the JCLContainer objects
```
kubectl create namespace $NAMESPACE
```
- Create a generic sceret in AKS cluster so that AKS cluster can access fileshare using this secret
```
kubectl create secret generic $SECRET_NAME --from-literal=azurestorageaccountname=$STORAGE_ACCOUNT_NAME --from-literal=azurestorageaccountkey=$STORAGE_KEY --namespace=$NAMESPACE
```
- Create a new file named pv-fileshare.yaml to provide persistent volume configuration to the cluster
```
code pv-fileshare.yaml
```
- Copy and replace the content as required, save and close the editor.
- Create the persistent volume using the kubectl apply command
```
kubectl apply -f  pv-fileshare.yaml
```

- Create a new file named pvc-fileshare.yaml to provide persistent volume claim configuration to the cluster
```
code pvc-fileshare.yaml
```
- Copy and replace the content as required, save and close the editor.
- Create the persistent volume claim using the kubectl apply command
```
kubectl apply -f  pvc-fileshare.yaml
```

## Deploy the JCLContainer: ##

- Create a new file named deploy.yaml to provide deployment configurations to the cluster
```
code deploy.yaml
```
- Copy and replace the content as required, save and close the editor.
- Create the pod and service using the kubectl apply command
```
kubectl apply -f  deploy.yaml
```
- Monitor the deployment progress using below command
```
kubectl get service $SERVICE_NAME --watch
```
- Once you see the external ip then consider the deployment is successful and you can access the same to trigger a request