#!/bin/sh
dotnet /opt/raincode/bin.core/IMSql.ProcessingServer.dll -LogLevel=TRACE -RegionId=$REGION_ID -ConnectionString="$CONN_STRING"