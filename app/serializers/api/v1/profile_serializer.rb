class Api::V1::ProfileSerializer < ActiveModel::Serializer
  attributes %i[id email admin created_at updated_at]
end
