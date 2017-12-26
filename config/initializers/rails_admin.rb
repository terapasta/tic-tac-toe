RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authorize_with do
    unless current_user.try(:staff?)
      redirect_to main_app.root_path, alert: '管理者用ページです。権限があるアカウントでログインしてください。'
    end
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model "User" do
    exclude_fields :bots
    create do
      field :confirmation_token do
        formatted_value { Devise.token_generator.generate(User, :confirmation_token) }
      end
      field :role do
        formatted_value { User.roles[:normal] }
      end
      include_all_fields
      exclude_fields :reset_password_sent_at,
        :bots,
        :remember_created_at,
        :sign_in_count,
        :current_sign_in_at,
        :last_sign_in_at,
        :current_sign_in_ip,
        :last_sign_in_ip,
        :confirmation_sent_at,
        :unconfirmed_email,
        :created_at, :updated_at
    end
  end

  config.excluded_models += %w(
    Contact
  )
end

module RailsAdmin
  module Config
    module Fields
      module Types
        class Serialized < RailsAdmin::Config::Fields::Types::Text
          # monkey patch for `no implicit conversion of Fixnum into String` error
          # @see https://github.com/sferik/rails_admin/pull/2759
          def parse_value(value)
            value.present? ? (RailsAdmin.yaml_load(value.try(:to_s)) || nil) : nil
          end
        end
      end
    end
  end
end

module ActiveRecord
  module RailsAdminEnum
    def enum(definitions)
      super
      definitions.each do |name, values|
        define_method("#{ name }_enum") { self.class.send(name.to_s.pluralize).map(&:first) }
      end
    end
  end
end
ActiveRecord::Base.send(:extend, ActiveRecord::RailsAdminEnum)
