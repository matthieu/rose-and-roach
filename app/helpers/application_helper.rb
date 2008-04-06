# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def round(num)
    precision = [(6 - num.to_s.size), 0].max
    number_with_precision(num, precision).sub('.00', '').sub('.0', '')
  end

  def show_language
    langs = ["en"] + Dir.glob(File.join(RAILS_ROOT,"locale/*")).collect{|item| File.basename(item)}
    langs.delete(".svn")
    langs.uniq!
    ret = "<li>" + _("Select language:") + "</li>"
    langs.sort.each do |lang|
      ret << '<li>'
      html_opts = langs.sort.last == lang ? {:class => 'last'} : {}
      ret << '<strong>' if lang == Locale.get.to_s
      ret << link_to(lang, {:action => "cookie_locale", :lang => lang}, html_opts)
      ret << '</strong>' if lang == Locale.get.to_s
      ret << '</li>'
    end
    ret
  end

  def fuzzy_num(num)
    case num
    when 0: _"no"
    when 1: _"one"
    when 2: _"a couple of"
    when 3..5: _"a few"
    when 6..10: _"some"
    else _"many"
    end
  end

  def pluralize(count, str)
    count > 1 ? str+'s' : str
  end

  def flash_notice(msg)
    <<-EOS
      <script type="text/javascript">
      try {
        $("errorExplanation").update("<div id=\\"tmpNotice\\" style=\\"display: none;\\">#{msg}</div>");
        new Effect.Appear("tmpNotice",{duration:0.5});
        setTimeout( function() { ; new Effect.Fade("tmpNotice", {}); }, 7000);
      } catch (e) { alert('RJS error:' + e.toString()); throw e; }
      </script>
    EOS
  end

  def error_messages_for(*params)
    options = params.last.is_a?(Hash) ? params.pop.symbolize_keys : {}
    objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
    count   = objects.inject(0) {|sum, object| sum + object.errors.count }
    unless count.zero?
      html = {}
      message = "#{pluralize(count, 'error')} prevented us from saving: "
      message << objects.map {|object| object.errors.full_messages }.join(", ") << "."
      flash_notice(message)
    else
      ""
    end
  end

end
