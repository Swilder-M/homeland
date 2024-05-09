# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, except: %i[index]
  before_action :check_exist!, except: %i[index block unblock
    follow unfollow]

  etag { @user }

  include Users::UserActions

  def index
    @total_user_count = User.count

    @counters = Counter.where(countable_type: "User")
    @counters = if params[:type] == "monthly"
      @counters.where(key: :monthly_replies_count)
    else
      @counters.where(key: :yearly_replies_count)
    end

    @active_users = @counters.includes(:countable).order("value desc").limit(100).map(&:countable)
  end

  def feed
    @topics = @user.topics.recent.limit(20)
  end

  def show
    user_show
  end

  protected

  def set_user
    @user = User.find_by_login!(params[:id])

    # 转向正确的拼写
    if @user.login != params[:id]
      redirect_to user_path(@user.login), status: 301
      return
    end

    @user_type = @user.user_type
  end

  def check_exist!
    render_404 if @user.deleted?
  end

  # Override render method to render difference view path
  def render(*args)
    options = args.extract_options!
    if @user_type
      options[:template] ||= "/#{@user_type.to_s.tableize}/#{params[:action]}"
    end
    super(*(args << options))
  end
end
