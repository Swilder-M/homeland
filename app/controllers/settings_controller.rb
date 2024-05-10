# frozen_string_literal: true

class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show
  end

  def account
  end

  def profile
  end

  def password
    render_404 if Setting.sso_enabled?
  end

  def update
    case params[:by]
    when "password"
      update_password
    when "profile"
      update_profile
    else
      update_basic
    end
  end

  def destroy
    current_password = params[:user][:current_password]

    unless @user.valid_password?(current_password)
      @user.errors.add(:current_password, :invalid)
      render "show"
      return
    end

    @user.soft_delete
    sign_out
    redirect_to root_path, notice: t("users.account_deleted")
  end

  def auth_unbind
    provider = params[:provider]

    if current_user.legacy_omniauth_logined?
      redirect_to account_setting_path, alert: t("users.legacy_unbind_tip")
      return
    end

    current_user.authorizations.where(provider: provider).delete_all
    redirect_to account_setting_path, notice: t("users.unbind_success", provider: provider.titleize)
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    attrs = User::ACCESSABLE_ATTRS.dup
    attrs << :login if Setting.allow_change_login?
    attrs << :email unless current_user.email_locked?
    params.require(:user).permit(*attrs)
  end

  def user_profile_params
    params.permit(user_profile: {})[:user_profile]
  end

  def update_basic
    if @user.update(user_params)
      theme = params[:user][:theme]
      @user.update_theme(theme)
      WebhookJob.perform_later("user_update", {
        user_id: @user.id,
        user_login: @user.login,
        user_name: @user.name,
        user_tagline: @user.tagline
      })
      redirect_to setting_path, notice: t("common.update_success")
    else
      render "show"
    end
  end

  def update_profile
    if @user.update(user_params)
      @user.update_profile_fields(user_profile_params)
      redirect_to profile_setting_path, notice: t("common.update_success")
    else
      render "profile"
    end
  end

  def update_password
    if @user.update_with_password(user_params)
      redirect_to new_session_path(:user), notice: t("users.password_update_success")
    else
      render "password"
    end
  end
end
