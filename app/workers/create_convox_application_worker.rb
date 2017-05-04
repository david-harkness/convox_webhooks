class CreateConvoxApplicationWorker < BaseWorker

  # One Git repository per branch
  # This prevents need for mutex lock
  # TODO: copy the repository, don't reclone
  def perform(app_id)
    @convox_app = App.find(app_id)

    # Never run more than once
    return false if @convox_app.created

    setup(app_id)

    @items = [
      "git clone git@github.com:david-harkness/terminus.git #{@working_dir} || git fetch &&  git pull && git checkout #{@convox_app.branch}",
      #"convox login console.convox.com",
      #"convox switch #{@the_rack}",
      #"convox apps create #{@app_name}  --wait",
      #"convox env set campaigns=2 tactics_per_campaign=2 accounts=3 daily_stats=3 account_stats=3 device_stats=3 geographic_stats=2 site_stats=3 time_stats=3 creative_stats=4 --app #{@app_name} --wait",
      #"convox env set RAILS_ENV=pr RACK_ENV=pr --app #{@app_name} --wait",
      #"convox deploy --file docker-compose.pr.yml --app #{@app_name} --wait",
      ##"convox scale web --memory=512 --app #{@app_name} --wait",
      #"convox apps info --app #{@app_name} | grep web | grep 80" # Needs regex to extract
    ]
    run_commands()
    @convox_app.update(created: true)
  end
end

# Test in console (app id 10)
#  reload!; App.find(10).update(created:false); CreateConvoxApplicationWorker.new.perform(10)
