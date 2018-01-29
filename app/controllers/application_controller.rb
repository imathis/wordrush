class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def short_code
    source = [*?A..?Z] - ['O']
    short = ''
    5.times { short << source.sample.to_s }
    short
  end
end
