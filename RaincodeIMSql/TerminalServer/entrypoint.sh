#!/bin/sh
dotnet /opt/raincode/bin.core/IMSql.TerminalServer.dll -LogLevel=TRACE -Port=8080 -RegionId=$REGION_ID -ConnectionString="$CONN_STRING"