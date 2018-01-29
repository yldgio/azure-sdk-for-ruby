# encoding: utf-8
# Code generated by Microsoft (R) AutoRest Code Generator.
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.

module Azure::CognitiveServices::ContentModerator::V1_0
  module Models
    #
    # Refresh Index Response.
    #
    class RefreshIndex

      include MsRestAzure

      # @return [String] Content source Id.
      attr_accessor :content_source_id

      # @return [Boolean] Update success status.
      attr_accessor :is_update_success

      # @return [Array<RefreshIndexAdvancedInfoItem>] Advanced info list.
      attr_accessor :advanced_info

      # @return [Status] Refresh index status.
      attr_accessor :status

      # @return [String] Tracking Id.
      attr_accessor :tracking_id


      #
      # Mapper for RefreshIndex class as Ruby Hash.
      # This will be used for serialization/deserialization.
      #
      def self.mapper()
        {
          client_side_validation: true,
          required: false,
          serialized_name: 'RefreshIndex',
          type: {
            name: 'Composite',
            class_name: 'RefreshIndex',
            model_properties: {
              content_source_id: {
                client_side_validation: true,
                required: false,
                serialized_name: 'ContentSourceId',
                type: {
                  name: 'String'
                }
              },
              is_update_success: {
                client_side_validation: true,
                required: false,
                serialized_name: 'IsUpdateSuccess',
                type: {
                  name: 'Boolean'
                }
              },
              advanced_info: {
                client_side_validation: true,
                required: false,
                serialized_name: 'AdvancedInfo',
                type: {
                  name: 'Sequence',
                  element: {
                      client_side_validation: true,
                      required: false,
                      serialized_name: 'RefreshIndexAdvancedInfoItemElementType',
                      type: {
                        name: 'Composite',
                        class_name: 'RefreshIndexAdvancedInfoItem'
                      }
                  }
                }
              },
              status: {
                client_side_validation: true,
                required: false,
                serialized_name: 'Status',
                type: {
                  name: 'Composite',
                  class_name: 'Status'
                }
              },
              tracking_id: {
                client_side_validation: true,
                required: false,
                serialized_name: 'TrackingId',
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