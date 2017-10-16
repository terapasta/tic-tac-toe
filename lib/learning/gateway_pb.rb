# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: learning/gateway.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "gateway.LearningParameter" do
    optional :use_similarity_classification, :bool, 1
    optional :algorithm, :int32, 2
    optional :datasource_type, :string, 3
  end
  add_message "gateway.Result" do
    optional :question_answer_id, :int32, 1
    optional :probability, :float, 2
    optional :question, :string, 3
  end
  add_message "gateway.ReplyRequest" do
    optional :bot_id, :int32, 1
    optional :body, :string, 2
    optional :learning_parameter, :message, 3, "gateway.LearningParameter"
  end
  add_message "gateway.ReplyResponse" do
    optional :question_feature_count, :int32, 1
    repeated :results, :message, 2, "gateway.Result"
    optional :noun_count, :int32, 3
    optional :verb_count, :int32, 4
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
  end
end

module Gateway
  LearningParameter = Google::Protobuf::DescriptorPool.generated_pool.lookup("gateway.LearningParameter").msgclass
  Result = Google::Protobuf::DescriptorPool.generated_pool.lookup("gateway.Result").msgclass
  ReplyRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gateway.ReplyRequest").msgclass
  ReplyResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("gateway.ReplyResponse").msgclass
  LearnRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gateway.LearnRequest").msgclass
  LearnResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("gateway.LearnResponse").msgclass
end
