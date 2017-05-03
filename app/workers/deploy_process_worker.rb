class DeployProcessWorker
  include Sidekiq::Worker

  # TODO: Need to add a lock so only one of these can be run at a time
  # TODO: Add a way to
  def perform(app_id)
    convox_app = App.find(app_id)

    app_name    = convox_app.name
    the_rack    = convox_app.platform.name
    items = [
      'ls',
      'cat /etc/hosts',
      'ps aux',
      'echo "hi"',
      'env'
      #"git clone git@github.com:david-harkness/terminus.git --depth=1 ./ || git fetch && git checkout #{app_name}",
      #'convox login', # CONVOX Environmental Variables need to be set
      #"convox build --file docker-compose.staging.yml --app #{app_name} --rack #{the_rack}",
      #"convox releases promote `convox releases --app #{app_name} --rack #{the_rack} | head -n 2 | tail -n 1  | cut -f1 -d \" \"`  --app #{app_name} --rack #{the_rack} --wait",
    ]
    @job = Job.create(job_type: self.class.to_s, status:'starting', app_id: app_id, steps: items.size)
    items.each_with_index do |cmd, i|
      run_command(cmd, i)
    end

  end

  def run_command(cmd, i)
    cmd = "cd /usr/src/terminus && #{cmd}"
    STDOUT << cmd
    output = `#{cmd}`
    STDOUT << output

    @job.commands.create(cli: cmd, output: output, status_code: $?, success: $?.success?, step: i)

    unless $?.success?
      STDOUT << "Breaking!"
      @job.status = 'failed'
      @job.save
      return false
    end

    @job.status = 'complete'
    @job.save
  end

end
