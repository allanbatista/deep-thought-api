class ApplicationController < ActionController::API
  protected

  def e(error, options={})
    I18n.t("error.#{error}").merge(options)
  end
end
