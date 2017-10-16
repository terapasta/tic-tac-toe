class Admin::OrganizationsController < ApplicationController
  before_action :set_organization, only: [:edit, :update, :destroy]

  def index
    @organizations = Organization.order(created_at: :desc)
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(permitted_attributes(Organization))
    if @organization.save
      redirect_to edit_admin_organization_path(@organization), notice: 'Succeeded create new organization'
    else
      flash.now.alert = 'Failed create new organization'
      render :new
    end
  end

  def edit
  end

  def update
    # render json: permitted_attributes(@organization) and return
    if @organization.update(permitted_attributes(@organization))
      redirect_to edit_admin_organization_path(@organization), notice: 'Succeeded update organization'
    else
      flash.now.alert = 'Failed update organization'
      render :new
    end
  end

  def destroy
    @organization.destroy!
    redirect_to admin_organizations_path, notice: 'Succeeded delete organization'
  end

  private
    def set_organization
      @organization = Organization.find(params[:id])
    end
end
