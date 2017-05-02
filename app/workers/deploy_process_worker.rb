class DeployProcessWorker
  include Sidekiq::Worker

  # TODO: Need to add a lock so only one of these can be run at a time
  # TODO: Add a way to
  def perform(app_id)
    convox_app = App.find App.find(app_id)

    app_name    = convox_app.name
    the_rack    = convox_app.platform.name
    items = [
      'ls',
      'cat /etc/hosts'
      #"git clone git@github.com:david-harkness/terminus.git --depth=1 ./ || git fetch && git checkout #{app_name}",
      #'convox login', # CONVOX Environmental Variables need to be set
      #"convox build --file docker-compose.staging.yml --app #{app_name} --rack #{the_rack}",
      #"convox releases promote `convox releases --app #{app_name} --rack #{the_rack} | head -n 2 | tail -n 1  | cut -f1 -d \" \"`  --app #{app_name} --rack #{the_rack} --wait",
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
