# Post deployment activity to run your Mainframe JCL workloads on AKS containers

Below steps helps you to place your Mainframe JCLs and other artifacts on azure fileshare and execute them using AKS containers with the help of Raincode software.

## Configure Storage account: ##

Below steps helps you to have the JCL artifacts placed on the azure fileshare and let JCLContainer access it using the file mount

- Create azure fileshare ($AZURE_FILE_SHARE), for e.g. jclartifacts and add Catalog, Jcls and Programs directories under it
- Under Catalog directory copy the Raincode.Catalog.xml and Raincode license file
- Under Jcls directory, place your mainframe JCLs, you can copy the sample jcls SORTFILE.JCL & JCLHELLO.JCL if you dont have JCLs handy 
- Under Programs directory, place your raincode compiled COBOL & PL1 dlls, you can copy the sample HELLO.dll if you dont have compiled dlls handy
- Place DB connection strings if required by the COBOL & PL1 modules in the RcDbConnections.csv file under the fileshare jclartifacts

## Mount azure fileshare to AKS cluster: ##

- Login to the azure portal and open the Cloud Shell, Refer [Microsoft Documentation](https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-portal?tabs=azure-cli#connect-to-the-cluster)
- Configure kubectl by executing below command, provide resource group and cluster name of your AKS cluster
```
az aks get-credentials --resource-group $AKS_CLUSTER_RG --name $AKS_CLUSTER_NAME
```
- Create namespace for the JCLContainer objects
```
kubectl create namespace $NAMESPACE
```
- Create a generic sceret in AKS cluster so that AKS cluster can access fileshare using this secret
```
kubectl create secret generic $SECRET_NAME --from-literal=azurestorageaccountname=$STORAGE_ACCOUNT_NAME --from-literal=azurestorageaccountkey=$STORAGE_KEY --namespace=$NAMESPACE
```
- Create a new file named pv-jcl.yaml to provide persistent volume configuration to the cluster
```
code pv-jcl.yaml
```
- Copy and replace the content as required, save and close the editor.
- Create the persistent volume using the kubectl apply command
```
kubectl apply -f  pv-jcl.yaml
```

- Create a new file named pvc-jcl.yaml to provide persistent volume claim configuration to the cluster
```
code pvc-jcl.yaml
```
- Copy and replace the content as required, save and close the editor.
- Create the persistent volume claim using the kubectl apply command
```
kubectl apply -f  pvc-jcl.yaml
```

## Deploy the JCLContainer: ##

- Create a new file named deploy-jcl.yaml to provide deployment configurations to the cluster
```
code deploy-jcl.yaml
```
- Copy and replace the content as required, save and close the editor.
- Create the pod and service using the kubectl apply command
```
kubectl apply -f  deploy-jcl.yaml
```
- Check if the pod and service are created successfully using below commands
```
kubectl get pods -o wide -n $NAMESPACE
kubectl get service $NAME --namespace $NAMESPACE
```

![RaincodeJCL Pod](https://github.com/DeepkumarMulapakula/aks-private-cluster-example/raw/main/RaincodeJCLWrapper/screenshots/raincodejcl-pod.PNG)

![RaincodeJCL Service](https://github.com/DeepkumarMulapakula/aks-private-cluster-example/raw/main/RaincodeJCLWrapper/screenshots/service-external-ip.PNG)

- Once you see the external ip as above then consider the deployment is successful and you can access the same to trigger a request
- Use any HTTP client to trigger a job submission request to the Raincode JCL container, you would see response back with submitted job detials.

![RaincodeJCL Postman](https://github.com/DeepkumarMulapakula/aks-private-cluster-example/raw/main/RaincodeJCLWrapper/screenshots/Postman-client.PNG)

- Inspect the pod for the recent submitted job logs.

![RaincodeJCL ContainerJobLogs](https://github.com/DeepkumarMulapakula/aks-private-cluster-example/raw/main/RaincodeJCLWrapper/screenshots/Job-logs-from-container.PNG)

- Alternatively you can access the Job logs, SYSOUT, Default volume, etc from the Fileshare mouted to the container.

![RaincodeJCL FileShareJobLogs](https://github.com/DeepkumarMulapakula/aks-private-cluster-example/raw/main/RaincodeJCLWrapper/screenshots/SYSOUT-from-FileShare.PNG)

