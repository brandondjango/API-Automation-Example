require 'rake'

namespace 'api' do

  desc 'Launches an IRB page model sandbox'
  task :launch_sandbox do |_t, _args|
    irb_env_path = "#{__dir__}/support/irb_env.rb"
    system("irb -r #{irb_env_path}")
  end

end


task default: 'api:launch_sandbox'