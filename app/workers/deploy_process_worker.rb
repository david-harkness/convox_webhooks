class DeployProcessWorker
  include Sidekiq::Worker

  def perform(*args)
    app_name = 'david-convox' # Branch name typically
    the_rack = 'personal/staging4'
    items = [
      "git clone git@github.com:david-harkness/terminus.git --depth=1 ./ || git fetch && git checkout #{app_name}",
      'convox login', # CONVOX Environmental Variables need to be set
      "convox build --file docker-compose.staging.yml --app #{app_name} --rack #{the_rack}",
      "convox releases promote `convox releases --app #{app_name} --rack #{the_rack} | head -n 2 | tail -n 1  | cut -f1 -d \" \"`  --app #{app_name} --rack #{the_rack} --wait",
    ]
    items.each do |cmd|
      STDOUT << cmd
      STDOUT << `cd /usr/src/terminus && #{cmd}`
      unless $?.success?
        STDOUT << "Breaking!"
        break
      end
    end

  end
end
