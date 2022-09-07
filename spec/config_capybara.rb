def register_driver(driver_name, args = [])
  opts = { js_errors: true, headless: true, window_size: [1920, 1200], browser_options: {} }
  args.each do |arg|
    opts[:browser_options][arg] = nil
  end

  Capybara.register_driver(driver_name) do |app|
    Capybara::Cuprite::Driver.new(app, opts)
  end
end

# Register our own custom drivers
register_driver(:headless_chrome, %w[disable-gpu no-sandbox disable-dev-shm-usage])

# Configure Capybara JS driver
Capybara.current_driver    = :headless_chrome
Capybara.javascript_driver = :headless_chrome

# Configure Capybara server
Capybara.run_server = true
Capybara.server     = :puma, { Silent: true }
