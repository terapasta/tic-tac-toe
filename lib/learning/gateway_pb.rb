# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: learning/gateway.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "gateway.LearningParameter" do
    optional :algorithm, :int32, 1
    optional :feedback_algorithm, :int32, 2
  end
  add_message "gateway.Result" do
    optional :question_answer_id, :int32, 1
    optional :probability, :float, 2
    optional :question, :string, 3
    repeated :processing, :string, 4
  end
  add_message "gateway.SetupRequest" do
  end
  add_message "gateway.SetupResponse" do
  end
  add_message "gateway.ReplyRequest" do
    optional :bot_id, :int32, 1
    optional :body, :string, 2
    optional :learning_parameter, :message, 3, "gateway.LearningParameter"
  end
  add_message "gateway.ReplyRequests" do
    repeated :data, :message, 1, "gateway.ReplyRequest"
  end
  add_message "gateway.ReplyResponse" do
    optional :question_feature_count, :int32, 1
    repeated :results, :message, 2, "gateway.Result"
    optional :noun_count, :int32, 3
    optional :verb_count, :int32, 4
    optional :algorithm, :int32, 5
    optional :feedback_algorithm, :int32, 6
    optional :query, :message, 7, "gateway.Query"
    optional :meta, :message, 8, "gateway.LearnMetaResponse"
  end
  add_message "gateway.ReplyResponses" do
    repeated :data, :message, 1, "gateway.ReplyResponse"
  end
  add_message "gateway.Query" do
    optional :query, :string, 1
    repeated :processing, :string, 2
  end
  add_message "gateway.LearnRequest" do
    optional :bot_id, :int32, 1
    optional :learning_parameter, :message, 3, "gateway.LearningParameter"
  end
  add_message "gateway.LearnResponse" do
    optional :accuracy, :float, 2
    optional :precision, :float, 3
    optional :recall, :float, 4
    optional :f1, :float, 5
    optional :meta, :message, 6, "gateway.LearnMetaResponse"
  end
  add_message "gateway.LearnMetaResponse" do
    optional :env, :string, 1
    optional :bot_id, :int32, 2
    optional :algorithm, :int32, 3
    optional :feedback_algorithm, :int32, 4
    optional :config, :message, 5, "gateway.LearnConfigResponse"
  end
  add_message "gateway.LearnConfigResponse" do
    optional :word2vec_model_is_binary, :bool, 1
    optional :dicdir, :string, 2
    optional :datasource_type, :string, 3
    optional :word2vec_model_name, :string, 4
  end
end

module Gateway
  LearningParameter = Google::Protobuf::DescriptorPool.generated_pool.lookup("gateway.LearningParameter").msgclass
  Result = Google::Protobuf::DescriptorPool.generated_pool.lookup("gateway.Result").msgclass
  SetupRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gateway.SetupRequest").msgclass
  SetupResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("gateway.SetupResponse").msgclass
  ReplyRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gateway.ReplyRequest").msgclass
  ReplyRequests = Google::Protobuf::DescriptorPool.generated_pool.lookup("gateway.ReplyRequests").msgclass
  ReplyResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("gateway.ReplyResponse").msgclass
  ReplyResponses = Google::Protobuf::DescriptorPool.generated_pool.lookup("gateway.ReplyResponses").msgclass
  Query = Google::Protobuf::DescriptorPool.generated_pool.lookup("gateway.Query").msgclass
  LearnRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gateway.LearnRequest").msgclass
  LearnResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("gateway.LearnResponse").msgclass
  LearnMetaResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("gateway.LearnMetaResponse").msgclass
  LearnConfigResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("gateway.LearnConfigResponse").msgclass
end
