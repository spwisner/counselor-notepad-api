# frozen_string_literal: true

class ObservationsController < OpenReadController
  before_action :set_observation, only: [:show, :update, :destroy]
  before_action :set_student, only: [:index, :create]
  before_action :set_setting, only: [:index, :create]

  # GET /observations
  def index
    @observations = @setting.observations
    # @observations = @student.observations
    render json: { observations: @observations }
    # @observations = current_user.observations
    # render json: @observations
  end

  # GET /observations/1
  def show
    render json: @observation
  end

  # POST /observations
  def create
    @observation = current_user.observations.build(observation_params)
    @observation.setting = @setting
    @observation.student = @student
    if @observation.save
      render json: @observation, status: :created
    else
      render json: @observation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /observations/1
  def update
    if @observation.update(observation_params)
      render json: @observation
      # render json: @observation, status: :ok
    else
      render json: @observation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /observations/1
  def destroy
    @observation.destroy
    head :no_content
  end

  private

  def set_student
    @student = current_user.students.find(params[:student_id])
  end

  def set_setting
    @setting = current_user.settings.find(params[:setting_id])
  end

  def set_observation
    # @observation = Observation.find(params[:id])
    @observation = Observation.where(id: params[:id], user: current_user).take
  end

  def observation_params
    params.require(:observation).permit(:aet, :pet, :oft_m, :oft_v,
                                        :oft_p, :obs_comment, :obs_num)
  end

  # private :set_observation, :observation_params
end
