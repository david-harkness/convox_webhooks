class AppsController < ApplicationController
  before_action :set_platform
  before_action :set_app, only: [:show, :edit, :update, :destroy, :deploy_process, :reseed, :create_convox_application ]

  # GET /apps
  # GET /apps.json
  def index
    @apps = @platform.apps = @platform.apps
  end

  # GET /apps/new
  def new
    @app = @platform.apps.new
  end

  # GET /apps/1/edit
  def edit
  end

  def show
    @jobs = @app.jobs
  end

  # POST /platforms/1/deploy_process
  def deploy_process
    flash[:notice] = "Updating and Promoting application: #{@app.name}"
    DeployProcessWorker.perform_async(@app.id)
    redirect_to platform_app_path(@platform, @app)
  end

  def reseed
    flash[:notice] = "Reseeding Application: #{@app.name}"
    ReseedDatabaseWorker.perform_async(@app.id)
    redirect_to platform_app_path(@platform, @app)
  end

  def create_convox_application
    flash[:notice] = "Creating Application: #{@app.name}"
    CreateConvoxApplicationWorker.perform_async(@app.id)
    redirect_to platform_app_path(@platform, @app)
  end

  # POST /apps
  # POST /apps.json
  def create
    @app = @platform.apps.new(app_params)

    respond_to do |format|
      if @app.save
        STDOUT << "SAVED!"
        format.html { redirect_to platform_apps_path(@platform), notice: 'App was successfully created.' }
        format.json { render :show, status: :created, location: @app }
      else
        STDOUT << " Failed to SAVED!"
        format.html { render :new }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /apps/1
  # PATCH/PUT /apps/1.json
  def update
    respond_to do |format|
      if @app.update(app_params)
        format.html { redirect_to platform_apps_path(@platform), notice: 'App was successfully updated.' }
        format.json { render :show, status: :ok, location: @app }
      else
        format.html { render :edit }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apps/1
  # DELETE /apps/1.json
  def destroy
    @app.destroy
    respond_to do |format|
      format.html { redirect_to platform_apps_path(@platform), notice: 'App was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app
      @app = @platform.apps.find(params[:id])
    end

    def set_platform
      @platform = Platform.find(params[:platform_id]) # TODO: secruity
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_params
      params.require(:app).permit(:branch, :url, :release)
    end
end
