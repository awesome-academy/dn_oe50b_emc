class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
end
