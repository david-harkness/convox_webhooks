class DeployProcessWorker < BaseWorker

  def perform(app_id)
    setup(app_id)
    @items = [
      "#git clone git@github.com:david-harkness/terminus.git --depth=1 ./ || git fetch && git checkout #{@app_name}",
      '#convox login', # CONVOX Environmental Variables need to be set
      "#convox build --file docker-compose.staging.yml --app #{@app_name} --rack #{@the_rack}",
      "#convox releases promote `convox releases --app #{@app_name} --rack #{@the_rack} | head -n 2 | tail -n 1  | cut -f1 -d \" \"`  --app #{@app_name} --rack #{@the_rack} --wait",
    ]
    run_commands()
  end

end
