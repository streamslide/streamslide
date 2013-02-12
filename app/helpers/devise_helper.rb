module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?
    html= resource.errors.full_messages.map do |msg|
      html = <<-HTML
      <div class="alert alert-error">
        <a class="close" data-dismiss="alert"></a>
        #{content_tag(:div, msg)}
      </div>
      HTML
    end.join

    html.html_safe
  end
end
