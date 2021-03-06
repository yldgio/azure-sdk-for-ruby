# encoding: utf-8
# Code generated by Microsoft (R) AutoRest Code Generator.
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.

module Azure::Network::Mgmt::V2016_12_01
  module Models
    #
    # VpnClientParameters
    #
    class VpnClientParameters

      include MsRestAzure

      # @return [ProcessorArchitecture] VPN client Processor Architecture.
      # Possible values are: 'AMD64' and 'X86'. Possible values include:
      # 'Amd64', 'X86'
      attr_accessor :processor_architecture


      #
      # Mapper for VpnClientParameters class as Ruby Hash.
      # This will be used for serialization/deserialization.
      #
      def self.mapper()
        {
          client_side_validation: true,
          required: false,
          serialized_name: 'VpnClientParameters',
          type: {
            name: 'Composite',
            class_name: 'VpnClientParameters',
            model_properties: {
              processor_architecture: {
                client_side_validation: true,
                required: true,
                serialized_name: 'ProcessorArchitecture',
                type: {
                  name: 'String'
                }
              }
            }
          }
        }
      end
    end
  end
end
