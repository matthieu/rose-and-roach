module ProjectHelper

  def tree_picker(struct, checked=[])
    tree_render("", struct, checked, Counter.new)
  end

private

  def tree_render(out, struct, checked, count)
    group_render(out, struct, count) do |elmt|
      if (elmt.is_a? Array)
        # Neat trick, with the counter class we have a counter
        # incremented even after being passed by ref
        elmt_render(out, elmt.first, checked.include?(elmt.first.code), count.inc)
        tree_render(out, elmt[1..-1], checked, count)
      elsif (elmt.respond_to? :code)
        # Elmt is a contribution
        elmt_render(out, elmt, checked.include?(elmt.code))
      else
        # Unrecognized type, ignoring
        logger.warn("Tree picker has found an unrecognized object in the passed structure: #{elmt}")
      end
    end
  end

  def elmt_render(out, elmt, checked, count = 0)
    out << '<li>'
    out << check_box_tag("contr_#{elmt.code}", "1", checked)
    out << '&nbsp;'
    out << "<a onclick=\"new Effect.toggle('div_contr_#{count}', 'blind', {duration: 0.5})\">" if count > 0
    out << _(elmt.name)
    out << '</a>' if count > 0
    out << observe_field("contr_#{elmt.code}", 
                          :url => url_for(:action=>"set_project_need" , :code=>elmt.code, :id=>@project),
                          :with => "'state=' + encodeURIComponent(value)")
    out << "</li>\n"
  end

  def group_render(out, group, count)
    c = count.counter
    out << "<div id=\"div_contr_#{count}\" style=\"display: none;\">\n" if c > 0
    out << '<ul style="list-style-type: none;">'
    group.each { |elmt| yield(elmt) }
    out << "</ul>\n"
    out << "</div>\n" if c > 0
    out
  end

  class Counter
    attr_reader :counter
    def initialize; @counter = 0; end
    def inc; @counter += 1; end
    def >(i); @counter > i; end
    def to_s; @counter.to_s; end
  end
end
