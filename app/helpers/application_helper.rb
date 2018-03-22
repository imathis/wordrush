module ApplicationHelper
  def button(text = nil, options = nil, &block)
    if text.is_a?(Hash) || block_given? && options.nil?
      options = text 
      text = nil
    end
    options ||= {}
    tag_name = options[:href].present? ? :a : :button

    options[:class] = button_classes(options)

    options[:data] = {
      toggle: options.delete(:toggle),
      show: options.delete(:show),
      hide: options.delete(:hide),
      remote: options.delete(:remote),
      'toggle-class' => options.delete(:toggle_class),
      'submit-message' => options.delete(:submit_message),
      'disable-on-submit' => options.delete(:disable_on_submit),
      'disable-with' => options.delete(:disable_with),
    }.merge( options[:data] || {} )

    if options[:confirm]
      options[:dialog] ||= {}
      options[:dialog][:confirm] = options.delete(:confirm)
    end

    if options[:confirm_if]
      options[:dialog][:if] = options.delete(:confirm_if)
    end

    (options.delete(:dialog) || {}).each do |key, val|
      if key.to_s == 'confirm'
        options[:data]["dialog-title"] ||= val
        options[:data]["dialog-confirm"] = true
      else
        options[:data]["dialog-#{key}"] = val
      end
    end

    options[:type] = 'submit' if options[:to]

    if tooltip = options.delete(:tooltip)
      options[:aria_label] ||= tooltip
      options[:class] << ' has-tooltip'
    end

    button_options = {
      role: 'button',
      id: options.delete(:id),
      data: options.delete(:data),
      class: options.delete(:class),
      disabled: options.delete(:disabled),
      type: options.delete(:type) || 'button',
      target: options.delete(:target),
      href: options.delete(:href),
      'aria-label'=> options.delete(:aria_label),
      tabindex: options.delete(:tabindex)
    }

    button = content_tag tag_name, button_options do
      if options[:icon]
        concat content_tag(:span, class: 'inline-icon') {
          use_svg(options.delete(:icon), height: '1em', fill: 'currentColor', desc: options.delete(:desc))
        }
      end
      concat content_tag(:span, class: 'button-text') { text } if text
      concat capture(&block).html_safe if block_given?
    end

    content_tag(:span, class: 'button-wrapper') {
      if options[:to]
        options[:data] = {}
      
        form = button_to 'input', options.delete(:to), options
        form.sub(/<input type="submit".+?>/, button).html_safe
      else
        button
      end
    }
  end

  def primary_button(text = nil, options = nil, &block)
    if text.is_a?(Hash)
      options = text 
      text = nil
    end
    options ||= {}
    options[:class] = button_classes(options, 'primary')
    options[:type] = 'submit'
    button(text, options, &block)
  end

  def button_classes(options, more=nil)
    classes = ['button']
    classes << more
    classes << options[:class]
    classes << options.delete(:size)
    classes << 'clear' if options.delete(:clear)
    classes.flatten.compact.join(' ').split(' ').uniq.join(' ').strip
  end
end
