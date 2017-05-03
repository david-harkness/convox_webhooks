class DeployProcessWorker < BaseWorker

  def perform(app_id)
    setup(app_id)
    @items = [
      "git pull",
      "convox login console.convox.com",
      "convox switch #{@the_rack}",
      "convox deploy --file docker-compose.pr.yml --app #{@app_name} --wait"
    ]
    run_commands()
  end

end
