helpers do
  def show_hide(divid, linkid)
    str = "$(document).ready(function(){"
    str << "$('#{linkid}').click(function(){"
    str << "$(\"#{divid}\").fadeToggle('fast');});});"
  end
end

