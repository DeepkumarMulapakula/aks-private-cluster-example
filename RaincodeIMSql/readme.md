# Post deployment activity to run your Mainframe IMS workloads on AKS containers

Below steps helps you to place your IMSql artifacts on azure fileshare and execute the IMSql terminal application on AKS containers with the help of Raincode software.

## Configure IMSql Config database: ##

Below steps helps you to create the IMSql configuration database, required tables, stored procedures and service broker setup in order to execute your IMS workloads using raincode software on AKS platform.

- Run the sql script **IMSql_Config_ServiceBroker.sql** to create IMSql_Config database and servicebroker setup required on the sqlserver instance you wish to store IMSql configuration
- Run the sql script **IMSql_Config_Tables.sql** to create IMSql config tables on the database created in the above step
- Create the IMSQL System by making an entry into Systems table, you can even use DEFAULT system which is present already
- Create the IMSQL Region by making an entry into Regions table, you can even use $CONTROL region which is present already
- Register the COBOL/PL1 programs to be used in this terminal applications by making entries into Programs table,if you dont have it handly then make entry with ProgramName - HIMENU , IsBMP - 0, Language - COBOL, ShedulingType - 0
- Register the transaction mapping between backend programs and frontend transactions by making entries into TransactionMappings table, if you dont have it handy then make entry with RegionId - <NEW_REGION OR $CONTROL> TransactionCode - himenu, ExecutableName - HIMENU, PsbName - PSBMENU, SpaSize - 0. 


## Configure Storage account: ##

Below steps helps you to have the IMS artifacts placed on the azure fileshare and let IMSql contianers access it using the file mount

- Create a storage account and azure fileshare ($IMSQL_FILE_SHARE), for e.g. imsqlfilestorage and add ProcessingServer and TerminalServer directories under it 
- Perfom below on ProcessingServer directory 
    - Place the Raincode license file  
    - Place your raincode compiled COBOL & PL1 dlls,if you dont have these handy then copy HIMENU.dll
    - Place your raincode compiled PSB xml files, if you dont have it handy then copy PSBMENU.xml
- Under TerminalServer directory place your raincode compiled MFS executables (dif,dof,mid,mod) ,if you dont have these handy then copy HIMENU.dif, HIMENU.dof, IHIMENU.mid and OHIMENU.mod

## Mount azure fileshare to AKS cluster: ##

In this step you would create required setup in order to provide the access required for AKS cluster to connect to the IMSql fileshare which is configured in the above step.

- Login to the azure portal and open the Cloud Shell, Refer [Microsoft Documentation](https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-portal?tabs=azure-cli#connect-to-the-cluster)
- Configure kubectl by executing below command
    ```
    az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME
    ```
- Create namespace for the IMSqlContainer objects
    ```
    kubectl create namespace $NAMESPACE
    ```
- Create a generic sceret in AKS cluster so that AKS cluster can access fileshare using this secret
    ```
    kubectl create secret generic $IMSQL_STORAGE_SECRET --from-literal=azurestorageaccountname=$STORAGE_ACCOUNT_NAME --from-literal=azurestorageaccountkey=$STORAGE_KEY --namespace=$NAMESPACE
    ```
- Create a new file named pv-imsql.yaml to provide Processing & Terminal server's persistent volume configuration to the cluster
    ```
    code pv-imsql.yaml
    ```
- Copy and replace the content as required, save and close the editor.
- Create the persistent volume using the kubectl apply command
    ```
    kubectl apply -f  pv-imsql.yaml
    ```
- Create a new file named pvc-imsql.yaml to provide Processing & Terminal server's persistent volume claim configuration to the cluster
    ```
    code pvc-imsql.yaml
    ```
- Copy and replace the content as required, save and close the editor.
- Create the persistent volume claim using the kubectl apply command
    ```
    kubectl apply -f  pvc-imsql.yaml
    ```
## Create IMSql config secrets: ##

Below step helps you to store the IMSql config database connectionstring ($IMSQL_CONFIG_DB_CONNSTRING) and region ($REGION_ID) as a secret in AKS cluster so that IMSql containers can access it securely.
```
kubectl create secret generic $IMSQL_CONFIG_SECRET --from-literal=configdbconnstring="$IMSQL_CONFIG_DB_CONNSTRING" --from-literal=regionid=$REGION_ID --namespace=$NAMESPACE
```
## Deploy the IMSqlProcessingServerContainer: ##

- Create a new file named imsql-processingserver.yaml to provide ProcessingServer configurations to the cluster
    ```
    code imsql-processingserver.yaml
    ```
- Copy and replace the content as required, save and close the editor.
- Create the pod using the kubectl apply command
    ```
    kubectl apply -f  imsql-processingserver.yaml
    ```
- Check if the deployment is successful using below command
    ```
    kubectl get pods -o wide –n $NAMESPACE
    ```
![IMSql PS](https://github.com/DeepkumarMulapakula/aks-private-cluster-example/raw/main/RaincodeIMSql/screenshots/imsql-ps.PNG)

## Deploy the IMSqlTerminalServerContainer: ##

- Create a new file named imsql-terminalserver.yaml to provide TerminalServer deployment configurations to the cluster
    ```
    code imsql-terminalserver.yaml
    ```
- Copy and replace the content as required, save and close the editor.
- Create the pod and service using the kubectl apply command
    ```
    kubectl apply -f  imsql-terminalserver.yaml
    ```
- Check if the pod and service are created using below commands
    ```
    kubectl get pods -o wide –n $NAMESPACE
    kubectl get services -o wide –n $NAMESPACE
    ```
![IMSql TS](https://github.com/DeepkumarMulapakula/aks-private-cluster-example/raw/main/RaincodeIMSql/screenshots/imsql-ts.PNG)
![IMSql TS-SERVICE](https://github.com/DeepkumarMulapakula/aks-private-cluster-example/raw/main/RaincodeIMSql/screenshots/imsql-ts-service.PNG)

- Once you see the external ip then consider the deployment is successful and you can access the same to connect from a 3270 terminal


## Test the deployed application: ##

- Use open command with the external ip address and port number on a 3270 terminal as below to connect to IMSql terminal container.

![IMSql WC3270-OPEN](https://github.com/DeepkumarMulapakula/aks-private-cluster-example/raw/main/RaincodeIMSql/screenshots/wc3270-open.PNG)

- Once the connection is successful you would be prompted with login screen, use DEEP & DEEP as the credentials to login.

- Key in **/FOR OHIMENU** on terminal to see first screen in the demo application.

![IMSql WC3270-OHIMENU](https://github.com/DeepkumarMulapakula/aks-private-cluster-example/raw/main/RaincodeIMSql/screenshots/wc3270-ohimenu.PNG)

- The first screen of IMSql Demo application is promoted asking you to provide the first name and press enter.

![IMSql WC3270-FIRST](https://github.com/DeepkumarMulapakula/aks-private-cluster-example/raw/main/RaincodeIMSql/screenshots/wc3270-firstscreen.PNG)

- A welcome message would be prompted with number of letters in your first name.

![IMSql WC3270-FINAL](https://github.com/DeepkumarMulapakula/aks-private-cluster-example/raw/main/RaincodeIMSql/screenshots/wc320-final.PNG)

- When you inspect the processing server pod then you can see the logs related to conversation and IMS module execution.

![IMSql WC3270-PS-LOGS-1](https://github.com/DeepkumarMulapakula/aks-private-cluster-example/raw/main/RaincodeIMSql/screenshots/imsql-ps-logs-1.PNG)
![IMSql WC3270-PS-LOGS-2](https://github.com/DeepkumarMulapakula/aks-private-cluster-example/raw/main/RaincodeIMSql/screenshots/imsql-ps-logs-2.PNG)





