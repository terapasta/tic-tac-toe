module RailsAdmin
  module Config
    module Fields
      module Types
        # 日付フォーマットが日本語になってしまうため日付による検索が出来ない問題の対処
        class Datetime < RailsAdmin::Config::Fields::Base
          register_instance_option :date_format do
            :default
          end
        end
        class Date < RailsAdmin::Config::Fields::Types::Datetime
          register_instance_option :date_format do
            :default
          end
        end
      end
    end
  end
end
