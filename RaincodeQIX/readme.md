# Post deployment activity to run your Mainframe QIX terminal workloads on AKS containers

Below steps helps you to place your QIX artifacts on azure fileshare and execute the QIX terminal application on AKS containers with the help of Raincode software.

## Configure QIX Config database: ##

Below steps helps you to create the QIX configuration database, required tables, stored procedures and service broker setup in order to execute your QIX workloads using raincode software on AKS platform.

- Create a database (E.g. RaincodeQIXMS) , enable service broker (if not done automatically) and Run the sql script **rcqix_db.sql** to create required tables and servicebroker setup on the sqlserver instance you wish to store QIX configuration
- Run the sql script **rcqix_ts.sql** to create database and tables required to support TS queues configuration, skip if there are no TS queues usage in your application
- Execute the **RegionCreator.exe** (Part of Raincode compiler, available in C:\Program Files\Raincode\Compilers\net6.0\bin) with the required parameters stated below to create the QIX region and store the configurations programmatically.
    - $QIX_CONFIG_DB_CONNSTRING - Connectionstring to the database you used in the above to create the QIX config setup
    - $REGION_ID - The name of QIX region you want to create for this application execution
    - $QIX_TRAN:$QIX_PROGRAM - QIX transactions and COBOL/PL1 programs you would like to execute, in case you dont have handy then fill in "HIMU:HIMENU"
    - ApplicationConnectionString - The application database connection string where you have application specific data is present, if case you dont have handy then fill same connection string used for $QIX_CONFIG_DB_CONNSTRING
        ```
        RegionCreator.exe -qixconnectionstring=$QIX_CONFIG_DB_CONNSTRING -region=$REGION_ID -mapspaths="/app/terminalserver" -programspaths="/app/processingserver" -qixtransactions=$QIX_TRAN:$QIX_PROGRAM -ApplicationConnectionString="$QIX_APPL_DB_CONNSTRING"
        ```

## Configure Storage account: ##

Below steps helps you to have the QIX artifacts placed on the azure fileshare and let QIX contianers access it using the file mount

- Create a storage account and azure fileshare ($QIX_FILE_SHARE), for e.g. qixfileshare and add processingserver and terminalserver directories under it
- Perfom below on processingserver directory 
    - Place the Raincode license file
    - Place your raincode compiled COBOL & PL1 dlls,if you dont have these handy then copy HIMENU.dll
- Perfom below on terminalserver directory
    - Place the Raincode license file
    - Place your raincode compiled BMS executables (xml files) ,if you dont have these handy then copy HIMENU.xml

## Mount azure fileshare to AKS cluster: ##

In this step you would perform required setup in order to provide the access required for AKS cluster to connect to the QIX fileshare which is configured in the above step.

- Login to the azure portal and open the Cloud Shell, Refer [Microsoft Documentation](https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-portal?tabs=azure-cli#connect-to-the-cluster)
- Configure kubectl by executing below command
    ```
    az aks get-credentials --resource-group $AKS_CLUSTER_RESOURCE_GROUP --name $AKS_CLUSTER_NAME
    ```
- Create namespace for the QIXContainer objects
    ```
    kubectl create namespace $NAMESPACE
    ```
- Create a generic sceret in AKS cluster so that AKS cluster can access storage account and it's fileshare using this secret
    ```
    kubectl create secret generic $QIX_STORAGE_SECRET --from-literal=azurestorageaccountname=$STORAGE_ACCOUNT_NAME --from-literal=azurestorageaccountkey=$STORAGE_KEY --namespace=$NAMESPACE
    ```
- Create a new file named pv-qix.yaml to provide Processing & Terminal server's persistent volume configuration to the cluster
    ```
    code pv-qix.yaml
    ```
- Copy and replace the content as required, save and close the editor.
- Create the persistent volume using the kubectl apply command
    ```
    kubectl apply -f  pv-qix.yaml
    ```
- Create a new file named pvc-qix.yaml to provide Processing & Terminal server's persistent volume claim configuration to the cluster
    ```
    code pvc-qix.yaml
    ```
- Copy and replace the content as required, save and close the editor.
- Create the persistent volume claim using the kubectl apply command
    ```
    kubectl apply -f  pvc-qix.yaml
    ```
## Create QIX config secrets: ##

Below step helps you to store the QIX config database connectionstring ($QIX_CONFIG_DB_CONNSTRING) and region ($REGION_ID) as a secret in AKS cluster so that QIX containers can access it securely.
```
kubectl create secret generic $QIX_CONFIG_SECRET --from-literal=configdbconnstring="$QIX_CONFIG_DB_CONNSTRING" --from-literal=regionid=$REGION_ID --namespace=$NAMESPACE
```
## Deploy the QIXProcessingServerContainer: ##

- Create a new file named qix-processingserver.yaml to provide ProcessingServer configurations to the cluster
    ```
    code qix-processingserver.yaml
    ```
- Copy and replace the content as required, save and close the editor.
- Create the pod using the kubectl apply command
    ```
    kubectl apply -f  qix-processingserver.yaml
    ```
- Check if the deployment is successful and pod created using below command
    ```
    kubectl get pods -o wide -n $NAMESPACE
    ```
![QIX PS](https://github.com/DeepkumarMulapakula/aks-private-cluster-example/raw/main/RaincodeQIX/screenshots/qix-ps.PNG)

## Deploy the QIXTerminalServerContainer: ##

- Create a new file named qix-terminalserver.yaml to provide TerminalServer deployment configurations to the cluster
    ```
    code qix-terminalserver.yaml
    ```
- Copy and replace the content as required, save and close the editor.
- Create the pod and service using the kubectl apply command
    ```
    kubectl apply -f  qix-terminalserver.yaml
    ```
- Check if the pod and service are created using below commands
    ```
    kubectl get pods -o wide -n $NAMESPACE
    kubectl get services -o wide -n $NAMESPACE
    ```
![QIX TS](https://github.com/DeepkumarMulapakula/aks-private-cluster-example/raw/main/RaincodeQIX/screenshots/qix-ts.PNG)
![QIX TS-Service](https://github.com/DeepkumarMulapakula/aks-private-cluster-example/raw/main/RaincodeQIX/screenshots/qix-ts-service.PNG)

- Once you see the external ip as shown above then consider the deployment is successful and you can access the same to connect from a 3270 terminal


## Test the deployed application: ##

- Use open command with the external ip address and port number on a 3270 terminal as below to connect to QIX terminal container.

![QIX WC3270-OPEN](https://github.com/DeepkumarMulapakula/aks-private-cluster-example/raw/main/RaincodeQIX/screenshots/wc3270-open.PNG)

- Once the connection is successful you would be prompted with blank screen allowing you to type the first transaction of the application.

- Key in **HIMU** on terminal to see the first screen in the demo application.

![QIX WC3270-OHIMENU](https://github.com/DeepkumarMulapakula/aks-private-cluster-example/raw/main/RaincodeQIX/screenshots/wc3270-HIMU.PNG)

- The first screen of QIX Demo application is promoted asking you to provide the first name and press enter.

![QIX WC3270-FIRST](https://github.com/DeepkumarMulapakula/aks-private-cluster-example/raw/main/RaincodeQIX/screenshots/wc3270-first-screen.PNG)

- A welcome message would be prompted with number of letters in your first name.

![QIX WC3270-FINAL](https://github.com/DeepkumarMulapakula/aks-private-cluster-example/raw/main/RaincodeQIX/screenshots/wc3270-last-screen.PNG)

- When you inspect the processing server pod then you can see the logs related to conversation and QIX module execution.

![QIX WC3270-PS-LOGS-1](https://github.com/DeepkumarMulapakula/aks-private-cluster-example/raw/main/RaincodeQIX/screenshots/qix-ps-logs-1.PNG)
![QIX WC3270-PS-LOGS-2](https://github.com/DeepkumarMulapakula/aks-private-cluster-example/raw/main/RaincodeQIX/screenshots/qix-ps-logs-2.PNG)
