class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :edit, :update, :destroy, :join, :leave]

  # GET /organizations
  # GET /organizations.json
  def index
    if current_user
    @organizations = Organization.all
      render :index
    else
      format.html { render :index }
      format.json { render json: @organization.errors, status: :unprocessable_entity }
    end
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    if @organization
      render :show
    else
      format.html { render :show }
      format.json { render json: @organization.errors, status: :unprocessable_entity }
    end
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.new(organization_params)

    respond_to do |format|
      if @organization.save
        format.html { redirect_to @organization, notice: 'Organization was successfully created.' }
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render :new }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to @organization, notice: 'Organization was successfully updated.' }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    @organization.destroy
    respond_to do |format|
      format.html { redirect_to organizations_url, notice: 'Organization was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def join
    current_user.update_attribute(:organization_id, @organization.id)
    redirect_to current_user
  end

  def leave
    current_user.update_attribute(:organization_id, nil)
    userShifts = Shift.where(:user_id => current_user.id)
    userShifts.destroy_all

    redirect_to current_user
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def organization_params
      params.require(:organization).permit(:name, :hourly_rate)
    end
end
