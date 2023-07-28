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

- Create a storage account and azure fileshare ($IMSQL_FILE_SHARE), for e.g. imsqlfilestorage and add the folders ProcessingServer and TerminalServer
- Perfom below on ProcessingServer folder 
    - Place the Raincode license file  
    - Place your raincode compiled COBOL & PL1 dlls,if you dont have these handy then copy HIMENU.dll
    - Place your raincode compiled PSB xml files, if you dont have it handy then copy PSBMENU.xml
- Under TerminalServer folder place your raincode compiled MFS executables (dif,dof,mid,mod) ,if you dont have these handy then copy HIMENU.dif, HIMENU.dof, IHIMENU.mid and OHIMENU.mod

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
- View the running pod and access the terminal of ProcessingServer container by executing below command, you might need to set the namespace to current by executing set context command first 
    ```
    kubectl config set-context --current –namespace=$NAMESPACE
    kubectl get pods -o wide
    kubectl exec -it pod/$POD_NAME -- /bin/bash
    ```
- Copy the license to /opt/raincode folder inside container so that license can validated by the ProcessingServer 
    ```
    cp $RAINCODE_LICENSE_FILE /opt/raincode
    ```
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
- Monitor the deployment progress using below command
    ```
    kubectl get service $SERVICE_NAME --watch
    ```
- Once you see the external ip then consider the deployment is successful and you can access the same to connect from a 3270 terminal