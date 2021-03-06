# encoding: utf-8
# Code generated by Microsoft (R) AutoRest Code Generator.
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.

module Azure::StorSimple8000Series::Mgmt::V2017_06_01
  module Models
    #
    # The collections of features.
    #
    class FeatureList

      include MsRestAzure

      # @return [Array<Feature>] The value.
      attr_accessor :value


      #
      # Mapper for FeatureList class as Ruby Hash.
      # This will be used for serialization/deserialization.
      #
      def self.mapper()
        {
          client_side_validation: true,
          required: false,
          serialized_name: 'FeatureList',
          type: {
            name: 'Composite',
            class_name: 'FeatureList',
            model_properties: {
              value: {
                client_side_validation: true,
                required: true,
                serialized_name: 'value',
                type: {
                  name: 'Sequence',
                  element: {
                      client_side_validation: true,
                      required: false,
                      serialized_name: 'FeatureElementType',
                      type: {
                        name: 'Composite',
                        class_name: 'Feature'
                      }
                  }
                }
              }
            }
          }
        }
      end
    end
  end
end
