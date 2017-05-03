class ReseedDatabaseWorker < BaseWorker
  def perform(app_id)
    @convox_app = App.find(app_id)

    # Don't run if app doesn't exist
    return false unless @convox_app.created
    
    setup(app_id)
    @items = [
      'convox login', # CONVOX Environmental Variables need to be set
      "convox run web rake db:setup --app #{@app_name}"
    ]
    run_commands()
  end
end
