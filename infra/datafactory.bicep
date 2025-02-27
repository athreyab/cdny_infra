@description('Data Factory Name')
param dataFactoryName string

@description('Location for the data factory')
param location string

@description('Enable Managed VNet')
//param enableManagedVNet bool
param userManagedIdentityId string
param logAnalyticsWorkspaceId string 
param purviewResourceId string
//param factoryName string = 'cdny-dwh-eus-dev-datafactory01'

//@description('Paramter New or Existing passed from main')
//param newOrExisting string 

//@secure()
//param mediskedcx_properties_MediskedCX_pipeline_parameters_creds string = '/Workspace/Users/anuragm@caredesignny.org/configs/creds.yaml'
//param mediskedcx_properties_MediskedCX_pipeline_parameters_source_type string = 'mediskedcx'
//param mediskedcx_properties_MediskedCX_pipeline_parameters_pimi_schema_path string = '/Workspace/Users/anuragm@caredesignny.org/schemas/pimi_schema.yaml'
///param mediskedcx_properties_MediskedCX_pipeline_parameters_log_file_schema_path string = '/Workspace/Users/anuragm@caredesignny.org/schemas/log_file_schema.yaml'
//param mediskedcx_properties_MediskedCX_pipeline_parameters_log_job_schema_path string = '/Workspace/Users/anuragm@caredesignny.org/schemas/log_job_schema.yaml'
//param mediskedcx_properties_MediskedCX_pipeline_parameters_destination_path string = '/dbfs/mnt/raw/'
//param mediskedcx_properties_MediskedCX_pipeline_parameters_sub_source_path string = '/Workspace/Users/anuragm@caredesignny.org/configs/sourceToBronze.yaml'
//param mediskedcx_properties_MediskedCX_pipeline_parameters_validation_config_file_path string = '/Workspace/Users/anuragm@caredesignny.org/configs/silver_validation.yaml'
//param sharepoint_properties_Sharepoint_pipeline_parameters_creds string = '/Workspace/Users/anuragm@caredesignny.org/configs/creds.yaml'
//param sharepoint_properties_Sharepoint_pipeline_parameters_source_type string = 'sharepoint'
//param sharepoint_properties_Sharepoint_pipeline_parameters_pimi_schema_path string = '/Workspace/Users/anuragm@caredesignny.org/schemas/pimi_schema.yaml'
//param sharepoint_properties_Sharepoint_pipeline_parameters_log_file_schema_path string = '/Workspace/Users/anuragm@caredesignny.org/schemas/log_file_schema.yaml'
//param sharepoint_properties_Sharepoint_pipeline_parameters_log_job_schema_path string = '/Workspace/Users/anuragm@caredesignny.org/schemas/log_job_schema.yaml'
//param sharepoint_properties_Sharepoint_pipeline_parameters_destination_path string = '/dbfs/mnt/raw/'
//param sharepoint_properties_Sharepoint_pipeline_parameters_sub_source_path string = '/Workspace/Users/anuragm@caredesignny.org/configs/subSource.yaml'
//param sharepoint_properties_Sharepoint_pipeline_parameters_validation_config_file_path string = '/Workspace/Users/anuragm@caredesignny.org/configs/silver_validation.yaml'
//param mediskedsftp_properties_MediskedSFTP_pipeline_parameters_creds string = '/Workspace/Users/anuragm@caredesignny.org/configs/creds.yaml'
//param mediskedsftp_properties_MediskedSFTP_pipeline_parameters_source_type string = 'mediskedsftp'
//param mediskedsftp_properties_MediskedSFTP_pipeline_parameters_pimi_schema_path string = '/Workspace/Users/anuragm@caredesignny.org/schemas/pimi_schema.yaml'
//param mediskedsftp_properties_MediskedSFTP_pipeline_parameters_log_file_schema_path string = '/Workspace/Users/anuragm@caredesignny.org/schemas/log_file_schema.yaml'
//param mediskedsftp_properties_MediskedSFTP_pipeline_parameters_log_job_schema_path string = '/Workspace/Users/anuragm@caredesignny.org/schemas/log_job_schema.yaml'
//param mediskedsftp_properties_MediskedSFTP_pipeline_parameters_destination_path string = '/dbfs/mnt/raw/'
//param mediskedsftp_properties_MediskedSFTP_pipeline_parameters_sub_source_path string = '/Workspace/Users/anuragm@caredesignny.org/configs/subSource.yaml'
//param mediskedsftp_properties_MediskedSFTP_pipeline_parameters_validation_config_file_path string = '/Workspace/Users/anuragm@caredesignny.org/configs/silver_validation.yaml'


resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: dataFactoryName
  location: location
  properties: {
    publicNetworkAccess: 'Disabled' // Disable public network access
    purviewConfiguration: {
      purviewResourceId: purviewResourceId
    }
    repoConfiguration: {
      accountName: 'ProarchCDNY'
      clientId: null
      clientSecret: null
      collaborationBranch: 'etl_pipeline_dev'
      disablePublish: false
      hostName: 'https://github.com'
      lastCommitId: 'd050bb804b934877ff7ffe31a257f990efa3829b'
      repositoryName: 'CDNY.DWH.ETL'
      rootFolder: '/'
      type: 'FactoryGitHubConfiguration'
    }
  }
  identity: {
    type: 'SystemAssigned,UserAssigned'
      userAssignedIdentities: {
        '${userManagedIdentityId}': {}
      }
  }
  
}


resource dataFactoryDiagnostic 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'DataFactoryDiagnostics'
  scope: dataFactory
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'PipelineRuns'
        enabled: true
        retentionPolicy: {
          days: 90
          enabled: false
        }
      }
      {
        category: 'ActivityRuns'
        enabled: true
        retentionPolicy: {
          days: 90
          enabled: false
        }
      }
      {
        category: 'TriggerRuns'
        enabled: true
        retentionPolicy: {
          days: 90
          enabled: false
        }
      }
      
    ]
  }
}
 

// resource factoryName_dev_db_dataset 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
//   name: '${factoryName}/dev_db_dataset'
//   properties: {
//     linkedServiceName: {
//       referenceName: 'datafactory-SQLDB'
//       type: 'LinkedServiceReference'
//     }
//     annotations: []
//     type: 'AzureSqlTable'
//     schema: []
//     typeProperties: {
//       schema: 'EDW'
//       table: 'FactMembership5'
//     }
//   }
  
// }

// resource factoryName_manual_db_dataset 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
//   name: '${factoryName}/manual_db_dataset'
//   properties: {
//     linkedServiceName: {
//       referenceName: 'Manual created DB'
//       type: 'LinkedServiceReference'
//     }           
//     annotations:     []
//     type: 'AzureSqlTable'
//     schema: [
//       {
//         name: 'ID'
//         type: 'int'
//         precision: 10
//       }
//       {
//         name: 'TabsID'
//         type: 'nvarchar'
//       }
//       {
//         name: 'FullName'
//         type: 'nvarchar'
//       }
//       {
//         name: 'DOB'
//         type: 'date'
//       }
//       {
//         name: 'Gender'
//         type: 'nvarchar'
//       }
//       {
//         name: 'Languages'
//         type: 'nvarchar'
//       }
//       {
//         name: 'Age'
//         type: 'int'
//         precision: 10
//       }
//       {
//         name: 'MedicaidID'
//         type: 'nvarchar'
//       }
//       {
//         name: 'WillowBrookIndicator'
//         type: 'bit'
//       }
//       {
//         name: 'AddressLine1'
//         type: 'nvarchar'
//       }
//       {
//         name: 'AddressLine2'
//         type: 'nvarchar'
//       }
//       {
//         name: 'City'
//         type: 'nvarchar'
//       }
//       {
//         name: 'State'
//         type: 'nvarchar'
//       }
//       {
//         name: 'ZipCode'
//         type: 'nvarchar'
//       }
//       {
//         name: 'CountyOfResidence'
//         type: 'nvarchar'
//       }
//       {
//         name: 'OPWDDEligibilityStatus'
//         type: 'nvarchar'
//       }
//       {
//         name: 'HCBSWaiverEnrolled'
//         type: 'nvarchar'
//       }
//       {
//         name: 'HCBSWaiverEnrollmentDate'
//         type: 'date'
//       }
//       {
//         name: 'IsCurrentFlag'
//         type: 'bit'
//       }
//       {
//         name: 'StartDate'
//         type: 'date'
//       }
//       {
//         name: 'EndDate'
//         type: 'date'
//       }
//       {
//         name: 'CreatedBy'
//         type: 'nvarchar'
//       }
//       {
//         name: 'CreatedDateTimeUTC'
//         type: 'datetime'
//         precision: 23
//         scale: 3
//       }
//     ]
//     typeProperties: {
//       schema: 'EDW'
//       table: 'factmembership5'
//     }
//   }
  
// }


// resource factoryName_Sharepoint_pipeline 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
//   name: '${factoryName}/Sharepoint_pipeline'
//   properties: {
//     activities: [
//       {
//         name: 'sourcetobronze'
//         type: 'DatabricksNotebook'
//         dependsOn: []
//         policy: {
//           timeout: '0.12:00:00'
//           retry: 0
//           retryIntervalInSeconds: 30
//           secureOutput: false
//           secureInput: false
//         }
//         userProperties: []
//         typeProperties: {
//           notebookPath: '/Users/anuragm@caredesignny.org/sourceToBronze'
//           baseParameters: {
//             creds: {
//               value: '@pipeline().parameters.creds'
//               type: 'Expression'
//             }
//             source_type: {
//               value: '@pipeline().parameters.source_type'
//               type: 'Expression'
//             }
//             pimi_schema_path: {
//               value: '@pipeline().parameters.pimi_schema_path'
//               type: 'Expression'
//             }
//             log_file_schema_path: {
//               value: '@pipeline().parameters.log_file_schema_path'
//               type: 'Expression'
//             }
//             log_job_schema_path: {
//               value: '@pipeline().parameters.log_job_schema_path'
//               type: 'Expression'
//             }
//             destination_path: {
//               value: '@pipeline().parameters.destination_path'
//               type: 'Expression'
//             }
//             sub_source_path: {
//               value: '@pipeline().parameters.sub_source_path'
//               type: 'Expression'
//             }
//           }
//         }
//         linkedServiceName: {
//           referenceName: 'AzureDatabricks1'
//           type: 'LinkedServiceReference'
//         }
//       }
//       {
//         name: 'bronzetoengineered'
//         type: 'DatabricksNotebook'
//         dependsOn: [
//           {
//             activity: 'sourcetobronze'
//             dependencyConditions: [
//               'Succeeded'
//             ]
//           }
//         ]
//         policy: {
//           timeout: '0.12:00:00'
//           retry: 0
//           retryIntervalInSeconds: 30
//           secureOutput: false
//           secureInput: false
//         }
//         userProperties: []
//         typeProperties: {
//           notebookPath: '/Users/anuragm@caredesignny.org/bronzeToSilver'
//           baseParameters: {
//             creds: {
//               value: '@pipeline().parameters.creds'
//               type: 'Expression'
//             }
//             log_file_schema_path: {
//               value: '@pipeline().parameters.log_file_schema_path'
//               type: 'Expression'
//             }
//             log_job_schema_path: {
//               value: '@pipeline().parameters.log_job_schema_path'
//               type: 'Expression'
//             }
//             source_type: {
//               value: '@pipeline().parameters.source_type'
//               type: 'Expression'
//             }
//             sub_source_path: {
//               value: '@pipeline().parameters.sub_source_path'
//               type: 'Expression'
//             }
//             validation_config_file_path: {
//               value: '@pipeline().parameters.validation_config_file_path'
//               type: 'Expression'
//             }
//           }
//         }
//         linkedServiceName: {
//           referenceName: 'AzureDatabricks1'
//           type: 'LinkedServiceReference'
//         }
//       }
//       {
//         name: 'adf_failure_alert'
//         type: 'DatabricksNotebook'
//         dependsOn: [
//           {
//             activity: 'sourcetobronze'
//             dependencyConditions: [
//               'Failed'
//             ]
//           }
//         ]
//         policy: {
//           timeout: '0.12:00:00'
//           retry: 0
//           retryIntervalInSeconds: 30
//           secureOutput: false
//           secureInput: false
//         }
//         userProperties: []
//         typeProperties: {
//           notebookPath: '/Shared/adf_alerts'
//           baseParameters: {
//             pipeline_runid: {
//               value: '@pipeline().RunId'
//               type: 'Expression'
//             }
//             pipeline_status: {
//               value: '@activity(\'sourcetobronze\').status'
//               type: 'Expression'
//             }
//             failure_reason: {
//               value: '@if(not(equals(activity(\'sourcetobronze\').status, \'Succeeded\')), activity(\'sourcetobronze\').error.message, \'\')'
//               type: 'Expression'
//             }
//             pipeline_name: {
//               value: '@pipeline().Pipeline'
//               type: 'Expression'
//             }
//           }
//         }
//         linkedServiceName: {
//           referenceName: 'AzureDatabricks1'
//           type: 'LinkedServiceReference'
//         }
//       }
//       {
//         name: 'adf_failure_alert2'
//         type: 'DatabricksNotebook'
//         dependsOn: [
//           {
//             activity: 'bronzetoengineered'
//             dependencyConditions: [
//               'Failed'
//             ]
//           }
//         ]
//         policy: {
//           timeout: '0.12:00:00'
//           retry: 0
//           retryIntervalInSeconds: 30
//           secureOutput: false
//           secureInput: false
//         }
//         userProperties: []
//         typeProperties: {
//           notebookPath: '/Shared/adf_alerts'
//           baseParameters: {
//             pipeline_runid: {
//               value: '@pipeline().RunId'
//               type: 'Expression'
//             }
//             pipeline_status: {
//               value: '@activity(\'bronzetoengineered\').status'
//               type: 'Expression'
//             }
//             failure_reason: {
//               value: '@if(not(equals(activity(\'bronzetoengineered\').status, \'Succeeded\')), activity(\'bronzetoengineered\').error.message, \'\')'
//               type: 'Expression'
//             }
//             pipeline_name: {
//               value: '@pipeline().Pipeline'
//               type: 'Expression'
//             }
//           }
//         }
//         linkedServiceName: {
//           referenceName: 'AzureDatabricks1'
//           type: 'LinkedServiceReference'
//         }
//       }
//       {
//         name: 'adf_success_alert'
//         type: 'DatabricksNotebook'
//         dependsOn: [
//           {
//             activity: 'bronzetoengineered'
//             dependencyConditions: [
//               'Succeeded'
//             ]
//           }
//         ]
//         policy: {
//           timeout: '0.12:00:00'
//           retry: 0
//           retryIntervalInSeconds: 30
//           secureOutput: false
//           secureInput: false
//         }
//         userProperties: []
//         typeProperties: {
//           notebookPath: '/Shared/adf_alerts'
//           baseParameters: {
//             pipeline_runid: {
//               value: '@pipeline().RunId'
//               type: 'Expression'
//             }
//             pipeline_status: {
//               value: '@activity(\'bronzetoengineered\').status'
//               type: 'Expression'
//             }
//             failure_reason: {
//               value: '\'\''
//               type: 'Expression'
//             }
//             pipeline_name: {
//               value: '@pipeline().Pipeline'
//               type: 'Expression'
//             }
//           }
//         }
//         linkedServiceName: {
//           referenceName: 'AzureDatabricks1'
//           type: 'LinkedServiceReference'
//         }
//       }
//     ]
//     policy: {
//       elapsedTimeMetric: {}
//     }
//     parameters: {
//       creds: {
//         type: 'string'
//         defaultValue: '/Workspace/Users/anuragm@caredesignny.org/configs/creds.yaml'
//       }
//       source_type: {
//         type: 'string'
//         defaultValue: 'sharepoint'
//       }
//       pimi_schema_path: {
//         type: 'string'
//         defaultValue: '/Workspace/Users/anuragm@caredesignny.org/schemas/pimi_schema.yaml'
//       }
//       log_file_schema_path: {
//         type: 'string'
//         defaultValue: '/Workspace/Users/anuragm@caredesignny.org/schemas/log_file_schema.yaml'
//       }
//       log_job_schema_path: {
//         type: 'string'
//         defaultValue: '/Workspace/Users/anuragm@caredesignny.org/schemas/log_job_schema.yaml'
//       }
//       destination_path: {
//         type: 'string'
//         defaultValue: '/dbfs/mnt/raw/'
//       }
//       sub_source_path: {
//         type: 'string'
//         defaultValue: '/Workspace/Users/anuragm@caredesignny.org/configs/subSource.yaml'
//       }
//       validation_config_file_path: {
//         type: 'string'
//         defaultValue: '/Workspace/Users/anuragm@caredesignny.org/configs/silver_validation.yaml'
//       }
//     }
    
//   }
  
// }

// resource factoryName_MediskedSFTP_pipeline 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
//   name: '${factoryName}/MediskedSFTP_pipeline'
//   properties: {
//     activities: [
//       {
//         name: 'sourcetobronze'
//         type: 'DatabricksNotebook'
//         dependsOn: []
//         policy: {
//           timeout: '0.12:00:00'
//           retry: 0
//           retryIntervalInSeconds: 30
//           secureOutput: false
//           secureInput: false
//         }
//         userProperties: []
//         typeProperties: {
//           notebookPath: '/Users/anuragm@caredesignny.org/sourceToBronze'
//           baseParameters: {
//             creds: {
//               value: '@pipeline().parameters.creds'
//               type: 'Expression'
//             }
//             source_type: {
//               value: '@pipeline().parameters.source_type'
//               type: 'Expression'
//             }
//             pimi_schema_path: {
//               value: '@pipeline().parameters.pimi_schema_path'
//               type: 'Expression'
//             }
//             log_file_schema_path: {
//               value: '@pipeline().parameters.log_file_schema_path'
//               type: 'Expression'
//             }
//             log_job_schema_path: {
//               value: '@pipeline().parameters.log_job_schema_path'
//               type: 'Expression'
//             }
//             destination_path: {
//               value: '@pipeline().parameters.destination_path'
//               type: 'Expression'
//             }
//             sub_source_path: {
//               value: '@pipeline().parameters.sub_source_path'
//               type: 'Expression'
//             }
//           }
//         }
//         linkedServiceName: {
//           referenceName: 'AzureDatabricks1'
//           type: 'LinkedServiceReference'
//         }
//       }
//       {
//         name: 'bronzetoengineered'
//         type: 'DatabricksNotebook'
//         dependsOn: [
//           {
//             activity: 'sourcetobronze'
//             dependencyConditions: [
//               'Succeeded'
//             ]
//           }
//         ]
//         policy: {
//           timeout: '0.12:00:00'
//           retry: 0
//           retryIntervalInSeconds: 30
//           secureOutput: false
//           secureInput: false
//         }
//         userProperties: []
//         typeProperties: {
//           notebookPath: '/Users/anuragm@caredesignny.org/bronzeToSilver'
//           baseParameters: {
//             creds: {
//               value: '@pipeline().parameters.creds'
//               type: 'Expression'
//             }
//             log_file_schema_path: {
//               value: '@pipeline().parameters.log_file_schema_path'
//               type: 'Expression'
//             }
//             log_job_schema_path: {
//               value: '@pipeline().parameters.log_job_schema_path'
//               type: 'Expression'
//             }
//             source_type: {
//               value: '@pipeline().parameters.source_type'
//               type: 'Expression'
//             }
//             sub_source_path: {
//               value: '@pipeline().parameters.sub_source_path'
//               type: 'Expression'
//             }
//             validation_config_file_path: {
//               value: '@pipeline().parameters.validation_config_file_path'
//               type: 'Expression'
//             }
//           }
//         }
//         linkedServiceName: {
//           referenceName: 'AzureDatabricks1'
//           type: 'LinkedServiceReference'
//         }
//       }
//       {
//         name: 'adf_failure_alert'
//         type: 'DatabricksNotebook'
//         dependsOn: [
//           {
//             activity: 'sourcetobronze'
//             dependencyConditions: [
//               'Failed'
//             ]
//           }
//         ]
//         policy: {
//           timeout: '0.12:00:00'
//           retry: 0
//           retryIntervalInSeconds: 30
//           secureOutput: false
//           secureInput: false
//         }
//         userProperties: []
//         typeProperties: {
//           notebookPath: '/Shared/adf_alerts'
//           baseParameters: {
//             pipeline_runid: {
//               value: '@pipeline().RunId'
//               type: 'Expression'
//             }
//             pipeline_status: {
//               value: '@activity(\'sourcetobronze\').status'
//               type: 'Expression'
//             }
//             failure_reason: {
//               value: '@if(not(equals(activity(\'sourcetobronze\').status, \'Succeeded\')), activity(\'sourcetobronze\').error.message, \'\')'
//               type: 'Expression'
//             }
//             pipeline_name: {
//               value: '@pipeline().Pipeline'
//               type: 'Expression'
//             }
//           }
//         }
//         linkedServiceName: {
//           referenceName: 'AzureDatabricks1'
//           type: 'LinkedServiceReference'
//         }
//       }
//       {
//         name: 'adf_failure_alert2'
//         type: 'DatabricksNotebook'
//         dependsOn: [
//           {
//             activity: 'bronzetoengineered'
//             dependencyConditions: [
//               'Failed'
//             ]
//           }
//         ]
//         policy: {
//           timeout: '0.12:00:00'
//           retry: 0
//           retryIntervalInSeconds: 30
//           secureOutput: false
//           secureInput: false
//         }
//         userProperties: []
//         typeProperties: {
//           notebookPath: '/Shared/adf_alerts'
//           baseParameters: {
//             pipeline_runid: {
//               value: '@pipeline().RunId'
//               type: 'Expression'
//             }
//             pipeline_status: {
//               value: '@activity(\'bronzetoengineered\').status'
//               type: 'Expression'
//             }
//             failure_reason: {
//               value: '@if(not(equals(activity(\'bronzetoengineered\').status, \'Succeeded\')), activity(\'bronzetoengineered\').error.message, \'\')'
//               type: 'Expression'
//             }
//             pipeline_name: {
//               value: '@pipeline().Pipeline'
//               type: 'Expression'
//             }
//           }
//         }
//         linkedServiceName: {
//           referenceName: 'AzureDatabricks1'
//           type: 'LinkedServiceReference'
//         }
//       }
//       {
//         name: 'adf_success_alert'
//         type: 'DatabricksNotebook'
//         dependsOn: [
//           {
//             activity: 'bronzetoengineered'
//             dependencyConditions: [
//               'Succeeded'
//             ]
//           }
//         ]
//         policy: {
//           timeout: '0.12:00:00'
//           retry: 0
//           retryIntervalInSeconds: 30
//           secureOutput: false
//           secureInput: false
//         }
//         userProperties: []
//         typeProperties: {
//           notebookPath: '/Shared/adf_alerts'
//           baseParameters: {
//             pipeline_runid: {
//               value: '@pipeline().RunId'
//               type: 'Expression'
//             }
//             pipeline_status: {
//               value: '@activity(\'bronzetoengineered\').status'
//               type: 'Expression'
//             }
//             failure_reason: '\'\''
//             pipeline_name: {
//               value: '@pipeline().Pipeline'
//               type: 'Expression'
//             }
//           }
//         }
//         linkedServiceName: {
//           referenceName: 'AzureDatabricks1'
//           type: 'LinkedServiceReference'
//         }
//       }
//     ]
//     policy: {
//       elapsedTimeMetric: {}
//     }
//     parameters: {
//       creds: {
//         type: 'string'
//         defaultValue: '/Workspace/Users/anuragm@caredesignny.org/configs/creds.yaml'
//       }
//       source_type: {
//         type: 'string'
//         defaultValue: 'medisked_sftp'
//       }
//       pimi_schema_path: {
//         type: 'string'
//         defaultValue: '/Workspace/Users/anuragm@caredesignny.org/schemas/pimi_schema.yaml'
//       }
//       log_file_schema_path: {
//         type: 'string'
//         defaultValue: '/Workspace/Users/anuragm@caredesignny.org/schemas/log_file_schema.yaml'
//       }
//       log_job_schema_path: {
//         type: 'string'
//         defaultValue: '/Workspace/Users/anuragm@caredesignny.org/schemas/log_job_schema.yaml'
//       }
//       destination_path: {
//         type: 'string'
//         defaultValue: '/dbfs/mnt/raw/'
//       }
//       sub_source_path: {
//         type: 'string'
//         defaultValue: '/Workspace/Users/anuragm@caredesignny.org/configs/subSource.yaml'
//       }
//       validation_config_file_path: {
//         type: 'string'
//         defaultValue: '/Workspace/Users/anuragm@caredesignny.org/configs/silver_validation.yaml'
//       }
//     }
    
//   }
  
// }

// resource factoryName_MediskedCX_pipeline 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
//   name: '${factoryName}/MediskedCX_pipeline'
//   properties: {
//     activities: [
//       {
//         name: 'sourcetobronze'
//         type: 'DatabricksNotebook'
//         dependsOn: []
//         policy: {
//           timeout: '0.12:00:00'
//           retry: 0
//           retryIntervalInSeconds: 30
//           secureOutput: false
//           secureInput: false
//         }
//         userProperties: []
//         typeProperties: {
//           notebookPath: '/Users/anuragm@caredesignny.org/sourceToBronze'
//           baseParameters: {
//             creds: {
//               value: '@pipeline().parameters.creds'
//               type: 'Expression'
//             }
//             source_type: {
//               value: '@pipeline().parameters.source_type'
//               type: 'Expression'
//             }
//             pimi_schema_path: {
//               value: '@pipeline().parameters.pimi_schema_path'
//               type: 'Expression'
//             }
//             log_file_schema_path: {
//               value: '@pipeline().parameters.log_file_schema_path'
//               type: 'Expression'
//             }
//             log_job_schema_path: {
//               value: '@pipeline().parameters.log_job_schema_path'
//               type: 'Expression'
//             }
//             destination_path: {
//               value: '@pipeline().parameters.destination_path'
//               type: 'Expression'
//             }
//             sub_source_path: {
//               value: '@pipeline().parameters.sub_source_path'
//               type: 'Expression'
//             }
//           }
//         }
//         linkedServiceName: {
//           referenceName: 'AzureDatabricks1'
//           type: 'LinkedServiceReference'
//         }
//       }
//       {
//         name: 'bronzetoengineered'
//         type: 'DatabricksNotebook'
//         dependsOn: [
//           {
//             activity: 'sourcetobronze'
//             dependencyConditions: [
//               'Succeeded'
//             ]
//           }
//         ]
//         policy: {
//           timeout: '0.12:00:00'
//           retry: 0
//           retryIntervalInSeconds: 30
//           secureOutput: false
//           secureInput: false
//         }
//         userProperties: []
//         typeProperties: {
//           notebookPath: '/Users/anuragm@caredesignny.org/bronzeToSilver'
//           baseParameters: {
//             creds: {
//               value: '@pipeline().parameters.creds'
//               type: 'Expression'
//             }
//             log_file_schema_path: {
//               value: '@pipeline().parameters.log_file_schema_path'
//               type: 'Expression'
//             }
//             log_job_schema_path: {
//               value: '@pipeline().parameters.log_job_schema_path'
//               type: 'Expression'
//             }
//             source_type: {
//               value: '@pipeline().parameters.source_type'
//               type: 'Expression'
//             }
//             sub_source_path: {
//               value: '@pipeline().parameters.sub_source_path'
//               type: 'Expression'
//             }
//             validation_config_file_path: {
//               value: '@pipeline().parameters.validation_config_file_path'
//               type: 'Expression'
//             }
//           }
//         }
//         linkedServiceName: {
//           referenceName: 'AzureDatabricks1'
//           type: 'LinkedServiceReference'
//         }
//       }
//       {
//         name: 'adf_failure_alert'
//         type: 'DatabricksNotebook'
//         dependsOn: [
//           {
//             activity: 'sourcetobronze'
//             dependencyConditions: [
//               'Failed'
//             ]
//           }
//         ]
//         policy: {
//           timeout: '0.12:00:00'
//           retry: 0
//           retryIntervalInSeconds: 30
//           secureOutput: false
//           secureInput: false
//         }
//         userProperties: []
//         typeProperties: {
//           notebookPath: '/Shared/adf_alerts'
//           baseParameters: {
//             pipeline_runid: {
//               value: '@pipeline().RunId'
//               type: 'Expression'
//             }
//             pipeline_status: {
//               value: '@activity(\'sourcetobronze\').status'
//               type: 'Expression'
//             }
//             failure_reason: {
//               value: '@if(not(equals(activity(\'sourcetobronze\').status, \'Succeeded\')), activity(\'sourcetobronze\').error.message, \'\')'
//               type: 'Expression'
//             }
//             pipeline_name: {
//               value: '@pipeline().Pipeline'
//               type: 'Expression'
//             }
//           }
//         }
//         linkedServiceName: {
//           referenceName: 'AzureDatabricks1'
//           type: 'LinkedServiceReference'
//         }
//       }
//       {
//         name: 'adf_failure_alert2'
//         type: 'DatabricksNotebook'
//         dependsOn: [
//           {
//             activity: 'bronzetoengineered'
//             dependencyConditions: [
//               'Failed'
//             ]
//           }
//         ]
//         policy: {
//           timeout: '0.12:00:00'
//           retry: 0
//           retryIntervalInSeconds: 30
//           secureOutput: false
//           secureInput: false
//         }
//         userProperties: []
//         typeProperties: {
//           notebookPath: '/Shared/adf_alerts'
//           baseParameters: {
//             pipeline_runid: {
//               value: '@pipeline().RunId'
//               type: 'Expression'
//             }
//             pipeline_status: {
//               value: '@activity(\'bronzetoengineered\').status'
//               type: 'Expression'
//             }
//             failure_reason: {
//               value: '@if(not(equals(activity(\'bronzetoengineered\').status, \'Succeeded\')), activity(\'bronzetoengineered\').error.message, \'\')'
//               type: 'Expression'
//             }
//             pipeline_name: {
//               value: '@pipeline().Pipeline'
//               type: 'Expression'
//             }
//           }
//         }
//         linkedServiceName: {
//           referenceName: 'AzureDatabricks1'
//           type: 'LinkedServiceReference'
//         }
//       }
//       {
//         name: 'adf_success_alert'
//         type: 'DatabricksNotebook'
//         dependsOn: [
//           {
//             activity: 'bronzetoengineered'
//             dependencyConditions: [
//               'Succeeded'
//             ]
//           }
//         ]
//         policy: {
//           timeout: '0.12:00:00'
//           retry: 0
//           retryIntervalInSeconds: 30
//           secureOutput: false
//           secureInput: false
//         }
//         userProperties: []
//         typeProperties: {
//           notebookPath: '/Shared/adf_alerts'
//           baseParameters: {
//             pipeline_runid: {
//               value: '@pipeline().RunId'
//               type: 'Expression'
//             }
//             pipeline_status: {
//               value: '@activity(\'bronzetoengineered\').status'
//               type: 'Expression'
//             }
//             failure_reason: '\'\''
//             pipeline_name: {
//               value: '@pipeline().Pipeline'
//               type: 'Expression'
//             }
//           }
//         }
//         linkedServiceName: {
//           referenceName: 'AzureDatabricks1'
//           type: 'LinkedServiceReference'
//         }
//       }
//     ]
//     policy: {
//       elapsedTimeMetric: {}
//     }
//     parameters: {
//       creds: {
//         type: 'string'
//         defaultValue: '/Workspace/Users/anuragm@caredesignny.org/configs/creds.yaml'
//       }
//       source_type: {
//         type: 'string'
//         defaultValue: 'medisked_cx'
//       }
//       pimi_schema_path: {
//         type: 'string'
//         defaultValue: '/Workspace/Users/anuragm@caredesignny.org/schemas/pimi_schema.yaml'
//       }
//       log_file_schema_path: {
//         type: 'string'
//         defaultValue: '/Workspace/Users/anuragm@caredesignny.org/schemas/log_file_schema.yaml'
//       }
//       log_job_schema_path: {
//         type: 'string'
//         defaultValue: '/Workspace/Users/anuragm@caredesignny.org/schemas/log_job_schema.yaml'
//       }
//       destination_path: {
//         type: 'string'
//         defaultValue: '/dbfs/mnt/raw/'
//       }
//       sub_source_path: {
//         type: 'string'
//         defaultValue: '/Workspace/Users/anuragm@caredesignny.org/configs/subSource.yaml'
//       }
//       validation_config_file_path: {
//         type: 'string'
//         defaultValue: '/Workspace/Users/anuragm@caredesignny.org/configs/silver_validation.yaml'
//       }
//     }
    
//   }
  
// }

// resource factoryName_Migrate_manual_db_to_dev 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
//   name: '${factoryName}/Migrate manual db to dev'
//   properties: {
//     activities: [
//       {
//         name: 'MIgrate each table'
//         type: 'Copy'
//         dependsOn: []
//         policy: {
//           timeout: '0.12:00:00'
//           retry: 0
//           retryIntervalInSeconds: 30
//           secureOutput: false
//           secureInput: false
//         }
//         userProperties: []
//         typeProperties: {
//           source: {
//             type: 'AzureSqlSource'
//             queryTimeout: '02:00:00'
//             partitionOption: 'None'
//           }
//           sink: {
//             type: 'AzureSqlSink'
//             writeBehavior: 'insert'
//             sqlWriterUseTableLock: false
//             tableOption: 'autoCreate'
//             disableMetricsCollection: false
//           }
//           enableStaging: false
//           translator: {
//             type: 'TabularTranslator'
//             typeConversion: true
//             typeConversionSettings: {
//               allowDataTruncation: true
//               treatBooleanAsNumber: false
//             }
//           }
//         }
//         inputs: [
//           {
//             referenceName: 'manual_db_dataset'
//             type: 'DatasetReference'
//             parameters: {}
//           }
//         ]
//         outputs: [
//           {
//             referenceName: 'dev_db_dataset'
//             type: 'DatasetReference'
//             parameters: {}
//           }
//         ]
//       }
//     ]
//     policy: {
//       elapsedTimeMetric: {}
//     }
    
  
// }
// }
// resource factoryName_mediskedcx 'Microsoft.DataFactory/factories/triggers@2018-06-01' = {
//   name: '${factoryName}/mediskedcx'
//   properties: {
//     annotations: []
//     runtimeState: 'Stopped'
//     pipelines: [
//       {
//         pipelineReference: {
//           referenceName: 'MediskedCX_pipeline'
//           type: 'PipelineReference'
//         }
//         parameters: {
//           creds: mediskedcx_properties_MediskedCX_pipeline_parameters_creds
//           source_type: mediskedcx_properties_MediskedCX_pipeline_parameters_source_type
//           pimi_schema_path: mediskedcx_properties_MediskedCX_pipeline_parameters_pimi_schema_path
//           log_file_schema_path: mediskedcx_properties_MediskedCX_pipeline_parameters_log_file_schema_path
//           log_job_schema_path: mediskedcx_properties_MediskedCX_pipeline_parameters_log_job_schema_path
//           destination_path: mediskedcx_properties_MediskedCX_pipeline_parameters_destination_path
//           sub_source_path: mediskedcx_properties_MediskedCX_pipeline_parameters_sub_source_path
//           validation_config_file_path: mediskedcx_properties_MediskedCX_pipeline_parameters_validation_config_file_path
//         }
//       }
//     ]
//     type: 'ScheduleTrigger'
//     typeProperties: {
//       recurrence: {
//         frequency: 'Month'
//         interval: 1
//         startTime: '2025-01-10T07:42:00'
//         timeZone: 'India Standard Time'
//         schedule: {
//           minutes: [
//             0
//           ]
//           hours: [
//             9
//           ]
//           monthDays: [
//             2
//           ]
//         }
//       }
//     }
//   }
 
// }

// resource factoryName_sharepoint 'Microsoft.DataFactory/factories/triggers@2018-06-01' = {
//   name: '${factoryName}/sharepointtrigger'
//   properties: {
//     annotations: []
//     runtimeState: 'Stopped'
//     pipelines: [
//       {
//         pipelineReference: {
//           referenceName: 'Sharepoint_pipeline'
//           type: 'PipelineReference'
//         }
//         parameters: {
//           creds: sharepoint_properties_Sharepoint_pipeline_parameters_creds
//           source_type: sharepoint_properties_Sharepoint_pipeline_parameters_source_type
//           pimi_schema_path: sharepoint_properties_Sharepoint_pipeline_parameters_pimi_schema_path
//           log_file_schema_path: sharepoint_properties_Sharepoint_pipeline_parameters_log_file_schema_path
//           log_job_schema_path: sharepoint_properties_Sharepoint_pipeline_parameters_log_job_schema_path
//           destination_path: sharepoint_properties_Sharepoint_pipeline_parameters_destination_path
//           sub_source_path: sharepoint_properties_Sharepoint_pipeline_parameters_sub_source_path
//           validation_config_file_path: sharepoint_properties_Sharepoint_pipeline_parameters_validation_config_file_path
//         }
//       }
//       {
//         pipelineReference: {
//           referenceName: 'MediskedCX_pipeline'
//           type: 'PipelineReference'
//         }
//         parameters: {}
//       }
//     ]
//     type: 'ScheduleTrigger'
//     typeProperties: {
//       recurrence: {
//         frequency: 'Month'
//         interval: 1
//         startTime: '2025-01-10T07:15:00'
//         timeZone: 'India Standard Time'
//         schedule: {
//           minutes: [
//             0
//           ]
//           hours: [
//             9
//           ]
//           monthDays: [
//             2
//           ]
//         }
//       }
//     }
//   }
  
// }

// resource factoryName_mediskedsftp 'Microsoft.DataFactory/factories/triggers@2018-06-01' = {
//   name: '${factoryName}/mediskedsftp'
//   properties: {
//     annotations: []
//     runtimeState: 'Stopped'
//     pipelines: [
//       {
//         pipelineReference: {
//           referenceName: 'MediskedSFTP_pipeline'
//           type: 'PipelineReference'
//         }
//         parameters: {
//           creds: mediskedsftp_properties_MediskedSFTP_pipeline_parameters_creds
//           source_type: mediskedsftp_properties_MediskedSFTP_pipeline_parameters_source_type
//           pimi_schema_path: mediskedsftp_properties_MediskedSFTP_pipeline_parameters_pimi_schema_path
//           log_file_schema_path: mediskedsftp_properties_MediskedSFTP_pipeline_parameters_log_file_schema_path
//           log_job_schema_path: mediskedsftp_properties_MediskedSFTP_pipeline_parameters_log_job_schema_path
//           destination_path: mediskedsftp_properties_MediskedSFTP_pipeline_parameters_destination_path
//           sub_source_path: mediskedsftp_properties_MediskedSFTP_pipeline_parameters_sub_source_path
//           validation_config_file_path: mediskedsftp_properties_MediskedSFTP_pipeline_parameters_validation_config_file_path
//         }
//       }
//     ]
//     type: 'ScheduleTrigger'
//     typeProperties: {
//       recurrence: {
//         frequency: 'Month'
//         interval: 1
//         startTime: '2025-01-10T07:48:00'
//         timeZone: 'India Standard Time'
//         schedule: {
//           minutes: [
//             0
//           ]
//           hours: [
//             9
//           ]
//           monthDays: [
//             2
//           ]
//         }
//       }
//     }
//   }
  
// }

output dataFactoryId string =   dataFactory.id
output dataFactoryName string =  dataFactory.name
