namespace :db do
  task :pull do
    on roles(:app) do
      file_name = "#{DateTime.now.strftime('%Y%m%d%H%M%S')}.sql"
      file_path = "#{shared_path}/tmp/#{file_name}"
      execute "#{current_path}/lib/bin/db_pull.sh", file_path
      if test "[ -f #{file_path} ]"
        download! file_path, './tmp'
        puts "## You got restore command!"
        puts "mysql -uroot donusagi_bot < ./tmp/#{file_name}"
      end
    end
  end
end