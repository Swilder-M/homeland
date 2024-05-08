# frozen_string_literal: true

module Admin
  class LocationsController < Admin::ApplicationController
    before_action :set_location, only: %i[show edit update]

    def index
      @locations = Location.hot.page(params[:page])
    end

    def edit
    end

    def show
    end

    def update
      if @location.update(params[:location].permit!)
        redirect_to(admin_locations_path, notice: t("views.admin.location_was_update_successfully"))
      else
        render action: "edit"
      end
    end

    private

    def set_location
      @location = Location.find(params[:id])
    end
  end
end
