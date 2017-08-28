namespace :db do
  task :pull do
    on roles(:app) do
      set :bot_ids, ask('input bot ids (ex: 8,11,13):', nil, echo: true)
      unless fetch(:bot_ids).nil?
        file_name = "#{DateTime.now.strftime('%Y%m%d%H%M%S')}.sql"
        file_path = "#{shared_path}/tmp/#{file_name}"
        execute "#{current_path}/lib/bin/db_pull.sh", file_path, fetch(:bot_ids)
        if test "[ -f #{file_path} ]"
          download! file_path, './tmp'
          puts "## You got restore command!"
          puts "mysql -uroot donusagi_bot < ./tmp/#{file_name}"
        end
      end
    end
  end
end