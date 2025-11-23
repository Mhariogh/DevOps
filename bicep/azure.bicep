@description('Name prefix')
param namePrefix string = 'cloud101'

param adminUsername string = 'azureuser'
@secure()
param adminPassword string

param instanceCount int = 1
param vmSize string = 'Standard_B1s'

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: '${namePrefix}-vnet'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}

resource lb 'Microsoft.Network/loadBalancers@2021-05-01' = {
  name: '${namePrefix}-lb'
  location: resourceGroup().location
  properties: {
    frontendIPConfigurations: [
      {
        name: 'LoadBalancerFrontEnd'
        properties: {
          subnet: {
            id: vnet.properties.subnets[0].id
          }
        }
      }
    ]
  }
}

resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2021-07-01' = {
  name: '${namePrefix}-vmss'
  location: resourceGroup().location
  sku: {
    name: vmSize
    capacity: instanceCount
  }
  properties: {
    upgradePolicy: {
      mode: 'Manual'
    }
    virtualMachineProfile: {
      storageProfile: {
        imageReference: {
          publisher: 'Canonical'
          offer: 'UbuntuServer'
          sku: '18.04-LTS'
          version: 'latest'
        }
      }
      osProfile: {
        computerNamePrefix: '${namePrefix}-vm'
        adminUsername: adminUsername
        adminPassword: adminPassword
        customData: base64('''#!/bin/bash
sudo apt update
sudo apt install -y apache2
sudo systemctl enable apache2
sudo systemctl start apache2
echo "<h1>Cloud101 Azure VMSS</h1>" > /var/www/html/index.html
''')
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: 'nicConfig'
            properties: {
              ipConfigurations: [
                {
                  name: 'ipconfig'
                  properties: {
                    subnet: {
                      id: vnet.properties.subnets[0].id
                    }
                  }
                }
              ]
            }
          }
        ]
      }
    }
  }
}

output vmssName string = vmss.name
