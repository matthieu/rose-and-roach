module PledgeHelper

  def resource_icon(action)
    res_type = RES_LOOKUP[action.saving_type].code
    base_img = case res_type
    when 1
      'electricity.png'
    when 2
      'air.png'
    when 3
      'water.png'
    when 4
      'water.png'
    when 5
      'ground.png'
    end
    icon_overlay("#{RAILS_ROOT}/public/images/", base_img, "#{round(action.quantity)} #{UNITS_LOOKUP[action.unit].symbol}")
  end

  def saving_text(action)
    "Saves #{round(action.quantity)} #{UNITS_LOOKUP[action.unit].symbol} of #{RES_LOOKUP[action.saving_type].name}"
  end

  def icon_overlay(dir, base_img, text_ov)
    unless File.exist? "#{dir}#{text_ov}-#{base_img}"
      image = Magick::ImageList.new(dir+base_img)
      text = Magick::Draw.new
      text.font_family = 'verdana'
      text.pointsize = 25
      text.gravity = Magick::NorthWestGravity

      # Computing text size to see if it fits
      metrics = text.get_multiline_type_metrics(text_ov)
      if (image.rows < metrics.width)
        rect = Magick::Image.new(metrics.width - image.columns, image.rows) { self.background_color = 'white' }
        image.unshift(rect)
        image = image.append(false)
      end

      text.annotate(image, 0, 0, 2, 1, text_ov) { self.fill = 'black' }
      text.annotate(image, 0, 0, 0, 1, text_ov) { self.fill = 'black' }
      text.annotate(image, 0, 0, 1, 2, text_ov) { self.fill = 'black' }
      text.annotate(image, 0, 0, 1, 0, text_ov) { self.fill = 'black' }
      text.annotate(image, 0, 0, 1, 1, text_ov) { self.fill = 'white' }

      image.write("#{dir}#{text_ov}-#{base_img}")
    end
    "/images/#{text_ov}-#{base_img}"
  end
end
