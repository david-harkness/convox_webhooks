class BaseWorker
  include Sidekiq::Worker

  # TODO: Need to add a lock so only one of these can be run at a time
  # TODO: Add a way to
  private
  def setup(app_id)
    @convox_app = App.find(app_id)
    @convox_app.update(status: 'updating')
    @app_name    = @convox_app.name
    @the_rack    = @convox_app.platform.name
  end

  def run_commands
    @convox_app.update(status: 'running')
    @job = Job.create(job_type: self.class.to_s, status: 'starting', app_id: @convox_app.id, steps: @items.size)
    @items.each_with_index do |cmd, i|
      return false unless run_command(cmd, i)
    end
    @job.update(status: 'complete')
  end

  def run_command(cmd, i)
    cmd = "cd /usr/src/terminus && #{cmd}"
    command = @job.commands.create(cli: cmd, output: '', step: i )
    STDOUT << cmd
    output = `#{cmd}`
    STDOUT << output

    command.update(output: output, status_code: $?, success: $?.success?)

    unless $?.success?
      STDOUT << "Breaking!"
      @job.update(status: 'failed')
      return false
    end
    true
  end

end
