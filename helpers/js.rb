helpers do
  def show_hide(divid, linkid)
    str = "$(document).ready(function(){"
    str << "$('#{linkid}').click(function(){"
    str << "$(\"#{divid}\").fadeToggle('fast');});});"
  end

  def deletable(warning = 'Are you sure you want to delete this?')
    str = "jQuery(function($) {$('a.delete').live('click', function(event) {"
    str << "if ( confirm('#{warning}') )$('<form method=\"post\" action=\"'+this.href.replace('/delete', '') + '\" />').append('<input type=\"hidden\" name=\"_method\" value=\"delete\" />').appendTo('body').submit();return false;});});"
  end
end

